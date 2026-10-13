{
  skills,
  cliPackages ? {},
}: {config, lib, pkgs, ...}: let
  cfg = config.programs.agent-skills;
  inherit (lib) mkOption types mkIf mkMerge mapAttrs';
  # An empty skills list installs everything in the registry.
  selected = if cfg.skills == [] then builtins.attrNames skills else cfg.skills;

  # CLI packages for whichever skills were selected. Resolved against the
  # consumer's pkgs so there is only ever one nixpkgs instance in play.
  clis = builtins.filter (n: n != null) (map (name:
    if cliPackages ? ${name}
    then pkgs.${cliPackages.${name}}
    else null)
  selected);
in {
  options.programs.agent-skills = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Install AI agent skills from the agent-skills registry.";
    };

    skills = mkOption {
      type = types.listOf (types.enum (builtins.attrNames skills));
      default = [];
      description = "Skill names to install.";
    };

    targets = mkOption {
      type = types.listOf types.str;
      default = [".agents/skills" ".config/opencode/skills" ".claude/skills" ".codex/skills" ".cursor/skills"];
      description = "Relative skill directories to populate, one per agent.";
    };
    settings = mkOption {
      type = types.attrsOf types.attrs;
      default = {};
      example.graphify.outputDir = "~/graphs";
      description = ''
        Per-skill settings, written to
        `$XDG_CONFIG_HOME/agent-skills/<name>.json`.

        shortcut: no shipped skill reads this yet. It is the documented hook for
        skills that want a config file; adopters must add a reader.
      '';
    };
  };

  config = mkIf cfg.enable {
    # CLIs ride along with whichever skills were selected.
    home.packages = clis;

    home.file = mkMerge (map (target:
      builtins.listToAttrs (map (name: {
        name = "${target}/${name}";
        value.source = skills.${name};
      })
      selected)) cfg.targets);

    # mapAttrs' already returns the attrset xdg.configFile wants; mkMerge would
    # need a list and fails on a set.
    xdg.configFile = mapAttrs' (name: value: {
      name = "agent-skills/${name}.json";
      value.text = builtins.toJSON value;
    }) cfg.settings;
  };
}
