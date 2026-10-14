{
  description = "Nix packaging for AI agent skills (opencode, claude, codex, cursor)";

  inputs = {
    # flake.lock pins rev + narHash per input; `nix flake update` moves them except where noted.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
    stop-slop = {
      url = "github:hardikpandya/stop-slop";
      flake = false;
    };
    ponytail = {
      url = "github:DietrichGebert/ponytail";
      flake = false;
    };
    # Pinned by ref; master is v3.x. Bump the tag to upgrade.
    oh-my-opencode-slim = {
      url = "github:alvinunreal/oh-my-opencode-slim";
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

    # This input's skills import @understand-anything/core, which only exists as packages/core/dist.
    # shortcut: tsc output is arch-independent JS. For per-arch, make sources take system.
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
        # pnpm deploy materialises real deps; other members' symlinks dangle unstaged.
        installPhase = ''
          runHook preInstall
          mkdir -p $out/packages
          cp -r agents skills hooks $out/
          cp package.json pnpm-workspace.yaml $out/
          pnpm --filter @understand-anything/core deploy --prod $out/packages/core
          # pnpm's virtual store at node_modules/.pnpm keeps a package's
          # transitive deps as siblings inside its entry, so copying one
          # package dir leaves graphology-utils unresolved. -L follows the chain.
          mkdir -p $out/node_modules
          for d in node_modules/.pnpm/graphology*/node_modules; do
            cp -rL "$d"/. $out/node_modules/
          done
          # Fail loudly rather than shipping a closure that looks built.
          [ -d $out/node_modules/graphology ] || { echo "no graphology staged" >&2; exit 1; }
          runHook postInstall
        '';
      });

    # shortcut: output is arch-independent, like mkUnderstandCore.
    mkGraphifySkill = system:
      nixpkgs.legacyPackages.${system}.runCommand "graphify-skill" {} ''
        mkdir -p $out
        cp ${inputs.graphify}/graphify/skill-opencode.md $out/SKILL.md
      '';

    sources = {
      stop-slop.stop-slop = "${inputs.stop-slop}";
      ponytail.ponytail = "${inputs.ponytail}/skills/ponytail";

      # Wrapping keeps the derivation's attrs (type, drvPath, outPath) out of the registry.
      graphify.graphify = mkGraphifySkill "x86_64-linux";
      understand-anything = skillDirs "${mkUnderstandCore "x86_64-linux"}/skills";
      ui-ux-pro-max = skillDirs "${inputs.ui-ux-pro-max}/.claude/skills";
      # v2.2.6 also ships loop-engineering; drop it if unwanted.
      oh-my-opencode-slim = skillDirs "${inputs.oh-my-opencode-slim}/src/skills";
    };

    skills = lib.foldlAttrs (acc: _: set: acc // set) {} sources;
  in {
    packages = forAll (system: {
      default = mkGraphifySkill system;
      understand-core = mkUnderstandCore system;
    });

    # cliPackages resolves against the consumer's pkgs, so CLIs come from their nixpkgs.
    homeManagerModules.default = import ./modules/agent-skills.nix {
      inherit skills;
      # graphify's CLI needs 24 tree-sitter pins; map it once it lands in nixpkgs.
      # Merge steps are Python and python3 is not assumed on PATH; keyed off the
      # source, not a name prefix, so unrelated understand-* skills don't pull it in.
      cliPackages = lib.genAttrs (builtins.attrNames sources.understand-anything) (_: "python3");
    };

    agentSkills = skills;

    commandsDir = "${inputs.ponytail}/.opencode/command";
    pluginsDir = "${inputs.ponytail}/.opencode/plugins";
  };
}
