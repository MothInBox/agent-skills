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

    # Adding a source = one line here.
    sources = {
      understand-anything = skillDirs "${inputs.understand-anything}/understand-anything-plugin/skills";
      ui-ux-pro-max = skillDirs "${inputs.ui-ux-pro-max}/.claude/skills";
    };

    # Flat registry: every skill from every source.
    skills = lib.foldlAttrs (acc: _: set: acc // set) {} sources;
  in {
    packages = forAll (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # graphify ships lowercase skill-<agent>.md; agents want SKILL.md.
      default = pkgs.runCommand "graphify-skill" {} ''
        mkdir -p $out
        cp ${inputs.graphify}/graphify/skill-opencode.md $out/SKILL.md
      '';
    });

    # Registry injected by partial application, so consumers need no plumbing.
    homeManagerModules.default = import ./modules/agent-skills.nix skills;

    agentSkills = skills;
  };
}
