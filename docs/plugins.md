# Plugins

The upstream skill inputs this flake fetches, plus the build inputs used to
package Python CLIs. No third-party content is stored in this repository: every
input is fetched at evaluation time and pinned by `flake.lock` to an exact rev +
narHash, so nothing can drift. The skills each input provides are cataloged in
[skills.md](skills.md).

## Sources

| Input | Repository | License | Runtime dependencies |
|---|---|---|---|
| `understand-anything` | [Egonex-AI/Understand-Anything](https://github.com/Egonex-AI/Understand-Anything) | Unverified, check before redistributing | `node`, `python3`; this flake builds `packages/core` with pnpm |
| `ui-ux-pro-max` | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | MIT | None |
| `oh-my-opencode-slim` | [alvinunreal/oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) | MIT | None |
| `ponytail` | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | MIT | None |
| `stop-slop` | [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) | MIT | None |
| `graphify` | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) | Apache-2.0 | `packages.graphify` builds the CLI from `uv.lock` with uv2nix |
| `mattpocock-skills` | [mattpocock/skills](https://github.com/mattpocock/skills) | MIT | None |
| `context7` | [upstash/context7](https://github.com/upstash/context7) | MIT | MCP skills need the Context7 server; CLI skills use `npx ctx7@latest` |

## Build inputs

| Input | Repository | Purpose |
|---|---|---|
| `pyproject-nix` | [pyproject-nix/pyproject.nix](https://github.com/pyproject-nix/pyproject.nix) | Python package builders used by uv2nix |
| `uv2nix` | [pyproject-nix/uv2nix](https://github.com/pyproject-nix/uv2nix) | Lockfile-driven Python packages for graphify |
| `pyproject-build-systems` | [pyproject-nix/build-system-pkgs](https://github.com/pyproject-nix/build-system-pkgs) | Wheel/sdist build-system overlays |

## Pinning

`oh-my-opencode-slim` is pinned to `v2.2.6` in `flake.lock`, not in the input URL.
That is deliberate: master is v3.x, which rewrites most of those skills. A bare
`nix flake lock` moves the input to master, so after a lock refresh restore the
lock node (rev `dabdfe8`) rather than editing the URL or bumping the tag. To
upgrade intentionally, update both the lock node and this note. Expect
`loop-engineering` and the other `src/skills/` entries to change with it.

`mattpocock-skills` is pinned to `v1.3.1` for the same reason: the repo ships
changesets continuously and skill prose changes between tags. `context7` follows
the default branch; `flake.lock` still pins the exact rev.

`simplify` additionally credits github.com/addyosmani/agent-skills
(`skills/code-simplification`) as its ancestral upstream, MIT, same lineage,
but not the file installed here.
