skills: {config, lib, ...}: let
  cfg = config.programs.agent-skills;
  inherit (lib) mkOption types mkIf mkMerge;
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
  };

  config = mkIf cfg.enable {
    home.file = mkMerge (map (target:
      builtins.listToAttrs (map (name: {
        name = "${target}/${name}";
        value.source = skills.${name};
      })
      cfg.skills)) cfg.targets);
  };
}
