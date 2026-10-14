# agent-skills

Nix packaging for AI agent skills that had none. Skills arrive as store paths
from `flake = false` inputs, so most of them need no build step.

The installable skill names, grouped by input, are in
[docs/skills.md](docs/skills.md); upstream repositories, licenses, and
dependencies are in [docs/plugins.md](docs/plugins.md).

## Requirements

- Nix with flakes enabled (`experimental-features = nix-command flakes`)
- home-manager, for the module usage below
- Supported systems: `x86_64-linux`, `aarch64-linux`, `aarch64-darwin`

## Install

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

Check the flake evaluates and see what it exposes:

```sh
nix flake show agent-skills
```

After rebuilding your home-manager generation, confirm the skills landed:

```sh
ls ~/.agents/skills/
```

Default targets: `.agents/skills`, `.config/opencode/skills`, `.claude/skills`,
`.codex/skills`, `.cursor/skills`.

## Module options

| Option | Type | Default | Description |
|---|---|---|---|
| `enable` | bool | `false` | Install skills from the registry. |
| `skills` | list of enum | `[]` (all) | Skill names to install; empty installs every registry entry. |
| `targets` | list of str | five agent dirs | Relative directories to populate, one per agent. |
| `settings` | attrs of attrs | `{}` | Per-skill JSON settings, written to `$XDG_CONFIG_HOME/agent-skills/<name>.json`. No shipped skill reads these yet. |

## Flake outputs

- `homeManagerModules.default`: the module above
- `agentSkills`: attrset of skill name to store path
- `packages.default`: the graphify skill directory. graphify ships `skill-opencode.md` lowercase; agents want `SKILL.md`, so this derivation renames it.
- `packages.understand-core`: the built understand-anything core
- `commandsDir`, `pluginsDir`: ponytail's slash commands and plugins, for consumers who place files themselves

## Use the paths directly

```nix
skills = agent-skills.agentSkills;   # name -> store path
home.file.".agents/skills/ui-ux-pro-max".source = skills.ui-ux-pro-max;
```

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

- **graphify's CLI is not packaged here.** Use `pkgs.graphify` from nixpkgs. The skill's guidance works without it, but its CLI invocations need it.
- **understand-anything's core is built here** (`tsc` + `pnpm deploy`). Upstream moving its pnpm lockfile or `packageManager` pin breaks the build until this repo catches up.
- opencode and Claude paths are meaningfully tested; codex and cursor follow the documented conventions but are unverified.

## Upstream and licenses

No third-party skill content is stored in this repository. Every skill is fetched
as a `flake = false` input at evaluation time and pinned by `flake.lock` to an
exact rev + narHash, so nothing can drift.

| Skills | Upstream | License |
|---|---|---|
| clonedeps, codemap, deepwork, loop-engineering, oh-my-opencode-slim, reflect, simplify, verification-planning, worktrees | github.com/alvinunreal/oh-my-opencode-slim, pinned to tag v2.2.6 | MIT |
| stop-slop | github.com/hardikpandya/stop-slop | MIT |
| ponytail | github.com/DietrichGebert/ponytail | MIT |
| ui-ux-pro-max | github.com/nextlevelbuilder/ui-ux-pro-max-skill | MIT |
| graphify | github.com/Graphify-Labs/graphify | MIT |
| understand-anything | github.com/Egonex-AI/Understand-Anything | unverified, check before redistributing |

`nix flake update` will not move the oh-my-opencode-slim input, because it is
pinned by ref (`/v2.2.6`) rather than the default branch. That is deliberate:
master is v3.x, which rewrites most of those skills. To upgrade, change the tag
in `flake.nix` and re-lock. Expect `loop-engineering` to come along too, since
it ships in that repo's `src/skills/`.

`simplify` additionally credits github.com/addyosmani/agent-skills
(`skills/code-simplification`) as its ancestral upstream, MIT, same lineage,
but not the file installed here.

## Support

Issues and PRs: https://github.com/MothInBox/agent-skills/issues

## License

MIT. See [LICENSE](LICENSE). This covers the packaging in this repo only; the
skills themselves stay under their upstream licenses.
