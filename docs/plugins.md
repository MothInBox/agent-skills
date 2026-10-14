# Skills

Catalog of the 28 skills this flake can install, pickable by name in
`programs.agent-skills.skills`. Skills are grouped into flake inputs;
[Sources](#sources) lists each input's repository, license, and the runtime
dependencies it pulls. An empty skills list installs everything.

## Available skills

| Skill | Description | Source |
|---|---|---|
| `banner-design` | Banners for social media, ads, website heroes, and print | ui-ux-pro-max |
| `brand` | Brand voice, visual identity, messaging, and asset management | ui-ux-pro-max |
| `clonedeps` | Clones project dependencies locally so library internals are inspectable | oh-my-opencode-slim |
| `codemap` | Generates comprehensive repository codemaps | oh-my-opencode-slim |
| `deepwork` | Orchestrator workflow for large, high-risk, multi-phase coding efforts | oh-my-opencode-slim |
| `design` | Brand identity, logos, corporate identity programs, presentations, and icons | ui-ux-pro-max |
| `design-system` | Token architecture, component specs, and slide generation | ui-ux-pro-max |
| `graphify` | Turns code, docs, papers, images, and videos into a persistent knowledge graph | graphify |
| `loop-engineering` | Loop engineering runtime, Grill plus Monitor | oh-my-opencode-slim |
| `oh-my-opencode-slim` | Configures and tunes agents, models, skills, and MCPs for this setup | oh-my-opencode-slim |
| `ponytail` | Lazy senior dev mode: the smallest change that fully solves the task | ponytail |
| `reflect` | Reviews recent sessions and proposes reusable skills, agents, and playbooks | oh-my-opencode-slim |
| `simplify` | Simplifies code for clarity without changing behavior | oh-my-opencode-slim |
| `slides` | Strategic HTML presentations with Chart.js and design tokens | ui-ux-pro-max |
| `stop-slop` | Removes AI writing patterns from prose | stop-slop |
| `ui-styling` | Accessible interfaces with shadcn/ui and Tailwind | ui-ux-pro-max |
| `ui-ux-pro-max` | UI/UX design intelligence: styles, palettes, font pairings, guidelines, stacks | ui-ux-pro-max |
| `understand` | Analyzes a codebase into a knowledge graph for architecture understanding | understand-anything |
| `understand-chat` | Ask questions about a codebase via its knowledge graph | understand-anything |
| `understand-dashboard` | Web dashboard to visualize the knowledge graph | understand-anything |
| `understand-diff` | Analyzes git diffs and pull requests for what changed and the risks | understand-anything |
| `understand-domain` | Extracts business domain knowledge into a domain flow graph | understand-anything |
| `understand-explain` | Deep-dive explanation of a specific file, function, or module | understand-anything |
| `understand-figma` | Turns a Figma file into an interactive design knowledge graph | understand-anything |
| `understand-knowledge` | Builds a knowledge graph from an LLM-trained wiki knowledge base | understand-anything |
| `understand-onboard` | Generates an onboarding guide for new team members | understand-anything |
| `verification-planning` | Builds project-specific verification plans before non-trivial changes | oh-my-opencode-slim |
| `worktrees` | Manages git worktrees as isolated coding lanes | oh-my-opencode-slim |

## Sources

| Input | Repository | License | Runtime dependencies |
|---|---|---|---|
| `understand-anything` | [Egonex-AI/Understand-Anything](https://github.com/Egonex-AI/Understand-Anything) | Unverified, check before redistributing | `node`, `python3`; this flake builds `packages/core` with pnpm |
| `ui-ux-pro-max` | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | MIT | None |
| `oh-my-opencode-slim` | [alvinunreal/oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim), pinned to tag `v2.2.6` | MIT | None; `worktrees` shells out to `git` |
| `ponytail` | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | MIT | None |
| `stop-slop` | [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) | MIT | None |
| `graphify` | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) | MIT | `graphify` CLI; not packaged here, use `pkgs.graphify` from nixpkgs |

## Notes

- `node` and `python3` for the understand-anything skills are mapped through `cliPackages`, so home-manager installs them automatically with the skills.
- `understand-figma` needs a Figma API token for the Figma REST API.
- Image-generating styles in `design` use external AI providers and need their own API access.
- The ponytail input also ships `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help`, and `ponytail-review`; this flake exposes only the main skill.
- `nix flake update` does not move `oh-my-opencode-slim`; it is pinned by ref. See the README.

## Usage

```nix
programs.agent-skills = {
  enable = true;
  skills = [ "understand" "ui-ux-pro-max" "ponytail" "worktrees" ];
};
```

Valid names are exactly the entries in the table above.
