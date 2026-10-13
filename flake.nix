{
  description = "Nix packaging for AI agent skills (opencode, claude, codex, cursor)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # One input per upstream. Adding a source = one line in `sources` below.
    understand-anything = {
      url = "github:Egonex-AI/Understand-Anything";
      flake = false;
    };
    graphify = {
      url = "github:Graphify-Labs/graphify";
      flake = false;
    };
    ui-ux-pro-max = {
      url = "github:nextlevelbuilder/ui-ux-pro-max-skill";
      flake = false;
    };
    # Skills arrive as inputs, never stored in this repo: flake.lock pins an
    # exact rev + narHash, so `nix flake update` is the only way to move them.
    stop-slop = {
      url = "github:hardikpandya/stop-slop";
      flake = false;
    };
    ponytail = {
      url = "github:DietrichGebert/ponytail";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
    forAll = f: lib.genAttrs systems f;

    # A flat directory of skill dirs -> { name = <store path>; }.
    skillDirs = dir:
      lib.mapAttrs' (n: _: lib.nameValuePair n (dir + "/${n}"))
      (lib.filterAttrs (_: v: v == "directory") (builtins.readDir dir));

    # understand-anything's skills must resolve to the BUILT plugin, not the raw
    # input: their scripts import @understand-anything/core, which only exists as
    # packages/core/dist after the tsc build. Upstream builds it with a bare
    # `tsc`; only core is built, since the workspace's other members (dashboard,
    # homepage) are unused. Runtime deps are all WASM/JS, so no native compile.
    mkUnderstandCore = system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "understand-anything-core";
        version = "0.1.0";
        src = "${inputs.understand-anything}/understand-anything-plugin";
        pnpmDeps = pkgs.fetchPnpmDeps {
          inherit (finalAttrs) pname version src;
          fetcherVersion = 4;
          hash = "sha256-ehac7mDZyUomy987+ZiSXLVBf9wa+9KcPbLrtmx3RtE=";
        };
        nativeBuildInputs = [pkgs.pnpm pkgs.nodejs pkgs.pnpmConfigHook];
        buildPhase = ''
          runHook preBuild
          pnpm --filter @understand-anything/core run build
          runHook postBuild
        '';
        # Ship only what the skills reference: agents/, skills/, hooks/, the
        # workspace manifests, and a deployed packages/core. `pnpm deploy`
        # materialises deps as real files; the workspace's other members ship
        # node_modules symlinks that dangle once node_modules is not staged
        # alongside them, so they are excluded entirely.
        installPhase = ''
          runHook preInstall
          mkdir -p $out/packages
          cp -r agents skills hooks $out/
          cp package.json pnpm-workspace.yaml $out/
          pnpm --filter @understand-anything/core deploy --prod $out/packages/core
          runHook postInstall
        '';
      });

    # shortcut: tsc output is arch-independent JS, so one build serves every
    # system. To go per-arch, make sources a function of system and expose
    # homeManagerModules via forAll.
    # graphify ships lowercase skill-<agent>.md; agents want SKILL.md. This
    # derivation is the skill directory itself, so it registers without the
    # skillDirs helper (which expects a directory of skill dirs).
    mkGraphifySkill = system:
      nixpkgs.legacyPackages.${system}.runCommand "graphify-skill" {} ''
        mkdir -p $out
        cp ${inputs.graphify}/graphify/skill-opencode.md $out/SKILL.md
      '';

    # shortcut: skill output is arch-independent, so one build serves every
    # system. Same reasoning as mkUnderstandCore above.
    sources = {
      # Each is an attrset mapping skill name -> store path. A single-skill repo
      # needs a hand-written entry because skillDirs expects a dir OF skill dirs.
      stop-slop.stop-slop = inputs.stop-slop;
      ponytail.ponytail = "${inputs.ponytail}/skills/ponytail";

      # graphify's derivation IS an attrset, so it must be wrapped or its own
      # attributes (type, drvPath, outPath, ...) land in the registry as skills.
      graphify.graphify = mkGraphifySkill "x86_64-linux";
      understand-anything = skillDirs "${mkUnderstandCore "x86_64-linux"}/skills";
      ui-ux-pro-max = skillDirs "${inputs.ui-ux-pro-max}/.claude/skills";
      local = skillDirs ./skills;
    };

    # Flat registry: every skill from every source.
    skills = lib.foldlAttrs (acc: _: set: acc // set) {} sources;
  in {
    packages = forAll (system: {
      default = mkGraphifySkill system;
      understand-core = mkUnderstandCore system;
    });

    # Registry injected by partial application, so consumers need no plumbing.
    # cliPackages maps skill name -> a package name resolved against the
    # CONSUMER's pkgs, so the CLI comes from their nixpkgs rather than this
    # flake's own instance. Only skills that actually need a CLI are listed.
    homeManagerModules.default = import ./modules/agent-skills.nix {
      inherit skills;
      # graphify's CLI is not in nixpkgs-unstable, so it cannot be mapped here:
      # building it needs 24 tree-sitter grammar pins. Once it lands in
      # nixpkgs this becomes cliPackages.graphify = "graphify";
      cliPackages = {};
    };

    agentSkills = skills;

    # Raw directories for consumers who place files themselves rather than via
    # the home-manager module: ponytail's slash commands and its plugin.
    commandsDir = "${inputs.ponytail}/.opencode/command";
    pluginsDir = "${inputs.ponytail}/.opencode/plugins";
  };
}
