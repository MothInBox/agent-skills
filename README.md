# agent-skills

Nix packaging for AI agent skills that had none. Skill directories arrive as
plain store paths from `flake = false` inputs, so there is nothing to build for
most of them.

| Skill | Upstream | Nix packaging before |
|---|---|---|
| ui-ux-pro-max | nextlevelbuilder | none |
| understand-anything | Egonex-AI | none |
| graphify | Graphify-Labs | CLI only, no skill |

## Use as a home-manager module

```nix
# flake.nix
inputs.agent-skills.url = "github:MothInBox/agent-skills";

# home config
imports = [ agent-skills.homeManagerModules.default ];
programs.agent-skills = {
  enable = true;
  skills = [ "ui-ux-pro-max" "understand" ];
  # Optional: override which agents get the skills.
  # targets = [ ".config/opencode/skills" ".claude/skills" ];
};
```

Default targets: `.agents/skills`, `.config/opencode/skills`, `.claude/skills`,
`.codex/skills`, `.cursor/skills`.

## Use the paths directly

```nix
skills = agent-skills.agentSkills;   # name -> store path
home.file.".agents/skills/ui-ux-pro-max".source = skills.ui-ux-pro-max;
```

Or a single package: `nix build .#` produces the graphify skill directory
(`graphify` ships `skill-opencode.md` lowercase; agents want `SKILL.md`).

## Adding a skill

One line in `sources` in `flake.nix`, plus the input:

```nix
sources = {
  ui-ux-pro-max = skillDirs "${inputs.ui-ux-pro-max}/.claude/skills";
  my-skill       = skillDirs "${inputs.my-skill}/skills";   # <- new
};
```

Sources laid out as a flat directory of skill dirs need nothing more. Anything
else (a nested layout, a build step) needs a small derivation in `packages`.

## Caveats

- **understand-anything is not runnable yet.** Its skill needs
  `packages/core/dist`, which upstream builds with pnpm. No build derivation is
  provided here yet, so the skill fails at Phase 0. Packaging it needs a pnpm
  workspace build plus native tree-sitter plumbing; nobody has done it in Nix.
- **graphify's CLI is not packaged here.** Use `pkgs.graphify` from nixpkgs.
- Only opencode and Claude paths are meaningfully tested; codex/cursor targets
  follow the documented conventions but are unverified.
