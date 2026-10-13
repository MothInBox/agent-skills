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

- **graphify's CLI is not packaged here.** Use `pkgs.graphify` from nixpkgs. The
  skill's guidance works without it, but its CLI invocations need it.
- **understand-anything's core is built here** (`tsc` + `pnpm deploy`). This is
  the first Nix packaging of it, so expect it to need maintenance when upstream
  moves its pnpm lockfile or `packageManager` pin.
- Only opencode and Claude paths are meaningfully tested; codex/cursor targets
  follow the documented conventions but are unverified.

## Upstream

No third-party skill content is stored in this repository. Every skill is fetched
as a `flake = false` input at evaluation time and pinned by `flake.lock` to an
exact rev + narHash, so nothing can drift and no source has to be maintained
here.

| Skill | Upstream | License |
|---|---|---|
| clonedeps, codemap, deepwork, loop-engineering, oh-my-opencode-slim, reflect, simplify, verification-planning, worktrees | github.com/alvinunreal/oh-my-opencode-slim, pinned to tag **v2.2.6** | MIT |
| stop-slop | github.com/hardikpandya/stop-slop | MIT |
| ponytail | github.com/DietrichGebert/ponytail | MIT |
| ui-ux-pro-max | github.com/nextlevelbuilder/ui-ux-pro-max-skill | MIT |
| graphify | github.com/Graphify-Labs/graphify | MIT |

`nix flake update` will not move the oh-my-opencode-slim input, because it is
pinned by **ref** (`/v2.2.6`) rather than the default branch. That is
deliberate: master is v3.x, which rewrites most of those skills. To upgrade,
change the tag in `flake.nix` and re-lock. Expect `loop-engineering` to come
along too, since it ships in that repo's `src/skills/`.

`simplify` additionally credits github.com/addyosmani/agent-skills
(`skills/code-simplification`) as its ancestral upstream — MIT, same lineage,
but not the file that is installed here.

`understand-anything` (github.com/Egonex-AI/Understand-Anything) is the one
remaining source vendored in raw form, because its `packages/core` must be
compiled. Its license was not verified when this was written — check it before
redistributing.
