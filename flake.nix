{
  description = "Nix packaging for AI agent skills (opencode, claude, codex, cursor)";

  inputs = {
    # flake.lock pins rev + narHash per input; `nix flake update` moves them except where noted.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # uv2nix builds graphify from its uv.lock; see mkGraphifyCli.
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
    };

    mattpocock-skills = {
      url = "github:mattpocock/skills/v1.3.1";
      flake = false;
    };
    context7 = {
      url = "github:upstash/context7";
      flake = false;
    };

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

    # Narrow dir inputs keep the large upstream repos out of the store.
    impeccable = {
      url = "github:pbakaus/impeccable?dir=.claude/skills/impeccable";
      flake = false;
    };
    paper-shaders = {
      url = "github:akillness/jeo-skills?dir=.agent-skills/paper-shaders";
      flake = false;
    };
    mcp-21st = {
      url = "github:21st-dev/magic-mcp?dir=skills/21st-ui";
      flake = false;
    };
    # The v2.2.6 pin lives in flake.lock, not this URL: master is v3.x and
    # rewrites the skills. A bare `nix flake lock` moves this input; restore
    # the lock node afterward instead of editing the URL.
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

    # OMP installs skills under ~/.agents/skills, not Claude's plugin layout.
    # Upstream's core SKILL.md hardcodes a plugin-root prefix, so search.py
    # cannot be found there. Make its paths skill-relative like the sub-skills.
    # Backslash keeps the literal shell variable name out of Nix interpolation.
    pluginRootPrefix = "\${CLAUDE_PLUGIN_ROOT}/.claude/skills/ui-ux-pro-max/scripts/";
    mkUiUxProMaxSkill = system:
      nixpkgs.legacyPackages.${system}.runCommand "ui-ux-pro-max-skill" {} ''
        cp -r ${inputs.ui-ux-pro-max}/.claude/skills/ui-ux-pro-max $out
        chmod -R u+w $out
        substituteInPlace $out/SKILL.md \
          --replace-fail '"${pluginRootPrefix}' '"scripts/' \
          --replace-fail "The search script lives inside this skill's own directory, not the project directory. Always invoke it by its full path — do not assume a particular working directory:" "Script paths below are relative to this skill's directory (the folder containing SKILL.md), not the project directory. Build the full path from that directory and keep the working directory at the project root."
        # Fail instead of shipping a skill whose search path still cannot resolve.
        test -f $out/scripts/search.py
        ! grep -q CLAUDE_PLUGIN_ROOT $out/SKILL.md
      '';

    # graphify's ~30 base deps include 19 tree-sitter grammars absent from
    # nixpkgs. Build from the upstream uv.lock instead of pinning them by hand.
    graphifyWorkspace = inputs.uv2nix.lib.workspace.loadWorkspace {
      workspaceRoot = inputs.graphify;
    };
    graphifyOverlay = graphifyWorkspace.mkPyprojectOverlay {
      sourcePreference = "wheel";
    };
    mkGraphifyCli = system: let
      pkgs = nixpkgs.legacyPackages.${system};
      pythonSet = (pkgs.callPackage inputs.pyproject-nix.build.packages {
        python = pkgs.python3;
      }).overrideScope (lib.composeManyExtensions [
        inputs.pyproject-build-systems.overlays.wheel
        graphifyOverlay
      ]);
      venv = pythonSet.mkVirtualEnv "graphify-env" graphifyWorkspace.deps.default;
    in
      # Expose only the entry points: the venv's bin/python3 would collide with
      # the pkgs.python3 installed for understand-*. The symlinked scripts keep
      # their venv shebangs, so the skill's `which graphify` + import probe works.
      pkgs.linkFarm "graphify-cli" [
        {
          name = "bin/graphify";
          path = "${venv}/bin/graphify";
        }
        {
          name = "bin/graphify-mcp";
          path = "${venv}/bin/graphify-mcp";
        }
      ];

    sources = {
      stop-slop.stop-slop = "${inputs.stop-slop}";
      ponytail.ponytail = "${inputs.ponytail}/skills/ponytail";
      impeccable.impeccable = "${inputs.impeccable}";
      paper-shaders.paper-shaders = "${inputs.paper-shaders}";
      "21st-ui"."21st-ui" = "${inputs.mcp-21st}";

      # Wrapping keeps the derivation's attrs (type, drvPath, outPath) out of the registry.
      graphify.graphify = mkGraphifySkill "x86_64-linux";
      understand-anything = skillDirs "${mkUnderstandCore "x86_64-linux"}/skills";
      ui-ux-pro-max =
        (skillDirs "${inputs.ui-ux-pro-max}/.claude/skills")
        // {
          ui-ux-pro-max = mkUiUxProMaxSkill "x86_64-linux";
        };
      # v2.2.6 also ships loop-engineering; drop it if unwanted.
      oh-my-opencode-slim = skillDirs "${inputs.oh-my-opencode-slim}/src/skills";

      # Upstream plugin manifest = engineering (20) + productivity (7).
      mattpocock-engineering = skillDirs "${inputs.mattpocock-skills}/skills/engineering";
      mattpocock-productivity = skillDirs "${inputs.mattpocock-skills}/skills/productivity";

      # Repo-wide skills plus the pi-specific entry (context7-docs).
      context7 =
        (skillDirs "${inputs.context7}/skills")
        // (skillDirs "${inputs.context7}/packages/pi/skills");
    };

    skills = lib.foldlAttrs (acc: _: set: acc // set) {} sources;
  in {
    packages = forAll (system: {
      default = mkGraphifySkill system;
      understand-core = mkUnderstandCore system;
      graphify = mkGraphifyCli system;
    });

    # cliPackages resolves against the consumer's pkgs, so CLIs come from their nixpkgs.
    homeManagerModules.default = import ./modules/agent-skills.nix {
      inherit skills;
      # Merge steps are Python and python3 is not assumed on PATH; keyed off the
      # source, not a name prefix, so unrelated understand-* skills don't pull it in.
      cliPackages =
        (lib.genAttrs (builtins.attrNames sources.understand-anything) (_: "python3"))
        // {
          "ui-ux-pro-max" = "python3";
        };
      # Lockfile-built CLIs are per-system derivations, not nixpkgs attributes.
      extraPackages = system: {
        graphify = mkGraphifyCli system;
      };
    };

    agentSkills = skills;

    commandsDir = "${inputs.ponytail}/.opencode/command";
    pluginsDir = "${inputs.ponytail}/.opencode/plugins";
  };
}
