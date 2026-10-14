# Plugins

The six upstream inputs this flake fetches. No third-party content is stored in
this repository: every input is fetched at evaluation time and pinned by
`flake.lock` to an exact rev + narHash, so nothing can drift. The skills each
input provides are cataloged in [skills.md](skills.md).

## Sources

| Input | Repository | License | Runtime dependencies |
|---|---|---|---|
| `understand-anything` | [Egonex-AI/Understand-Anything](https://github.com/Egonex-AI/Understand-Anything) | Unverified, check before redistributing | `node`, `python3`; this flake builds `packages/core` with pnpm |
| `ui-ux-pro-max` | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | MIT | None |
| `oh-my-opencode-slim` | [alvinunreal/oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim), | MIT | None |
| `ponytail` | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | MIT | None |
| `stop-slop` | [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) | MIT | None |
| `graphify` | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) | MIT | `graphify` CLI; not packaged here, use `pkgs.graphify` from nixpkgs |

## Pinning

`nix flake update` will not move `oh-my-opencode-slim`, because it is pinned by
ref (`/v2.2.6`) rather than the default branch. That is deliberate: master is
v3.x, which rewrites most of those skills. To upgrade, change the tag in
`flake.nix` and re-lock. Expect `loop-engineering` to come along too, since it
ships in that repo's `src/skills/`.

`simplify` additionally credits github.com/addyosmani/agent-skills
(`skills/code-simplification`) as its ancestral upstream, MIT, same lineage,
but not the file installed here.
