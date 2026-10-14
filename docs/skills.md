# Skills

The 28 skills this flake can install, sorted by the input that provides them.
Every name below is a valid entry in `programs.agent-skills.skills`; an empty
list installs all of them. Input repositories, licenses, and dependencies are
in [plugins.md](plugins.md).

| Skill | Description | Source |
|---|---|---|
| `understand` | Analyzes a codebase into a knowledge graph for architecture understanding | [understand-anything](https://github.com/Egonex-AI/Understand-Anything) |
| `understand-chat` | Ask questions about a codebase via its knowledge graph | [understand-anything](https://github.com/Egonex-AI/Understand-Anything) |
| `understand-dashboard` | Web dashboard to visualize the knowledge graph | [understand-anything](https://github.com/Egonex-AI/Understand-Anything) |
| `understand-diff` | Analyzes git diffs and pull requests for what changed and the risks | [understand-anything](https://github.com/Egonex-AI/Understand-Anything) |
| `understand-domain` | Extracts business domain knowledge into a domain flow graph | [understand-anything](https://github.com/Egonex-AI/Understand-Anything) |
| `understand-explain` | Deep-dive explanation of a specific file, function, or module | [understand-anything](https://github.com/Egonex-AI/Understand-Anything) |
| `understand-figma` | Turns a Figma file into an interactive design knowledge graph | [understand-anything](https://github.com/Egonex-AI/Understand-Anything) |
| `understand-knowledge` | Builds a knowledge graph from an LLM-trained wiki knowledge base | [understand-anything](https://github.com/Egonex-AI/Understand-Anything) |
| `understand-onboard` | Generates an onboarding guide for new team members | [understand-anything](https://github.com/Egonex-AI/Understand-Anything) |
| `banner-design` | Banners for social media, ads, website heroes, and print | [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) |
| `brand` | Brand voice, visual identity, messaging, and asset management | [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) |
| `design` | Brand identity, logos, corporate identity programs, presentations, and icons | [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) |
| `design-system` | Token architecture, component specs, and slide generation | [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) |
| `slides` | Strategic HTML presentations with Chart.js and design tokens | [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) |
| `ui-styling` | Accessible interfaces with shadcn/ui and Tailwind | [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) |
| `ui-ux-pro-max` | UI/UX design intelligence: styles, palettes, font pairings, guidelines, stacks | [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) |
| `clonedeps` | Clones project dependencies locally so library internals are inspectable | [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) |
| `codemap` | Generates comprehensive repository codemaps | [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) |
| `deepwork` | Orchestrator workflow for large, high-risk, multi-phase coding efforts | [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) |
| `loop-engineering` | Loop engineering runtime, Grill plus Monitor | [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) |
| `oh-my-opencode-slim` | Configures and tunes agents, models, skills, and MCPs for this setup | [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) |
| `reflect` | Reviews recent sessions and proposes reusable skills, agents, and playbooks | [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) |
| `simplify` | Simplifies code for clarity without changing behavior | [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) |
| `verification-planning` | Builds project-specific verification plans before non-trivial changes | [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) |
| `worktrees` | Manages git worktrees as isolated coding lanes | [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) |
| `ponytail` | Lazy senior dev mode: the smallest change that fully solves the task | [ponytail](https://github.com/DietrichGebert/ponytail) |
| `stop-slop` | Removes AI writing patterns from prose | [stop-slop](https://github.com/hardikpandya/stop-slop) |
| `graphify` | Turns code, docs, papers, images, and videos into a persistent knowledge graph | [graphify](https://github.com/Graphify-Labs/graphify) |

## Notes

- The understand-anything skills pull `node` and `python3` at runtime, mapped through `cliPackages`, so home-manager installs them alongside the skills.
- `understand-figma` needs a Figma API token for the Figma REST API.
- Image-generating styles in `design` use external AI providers and need their own API access.
- The ponytail input also ships `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help`, and `ponytail-review`; this flake exposes only the main skill.

## Usage

```nix
programs.agent-skills = {
  enable = true;
  skills = [ "understand" "ui-ux-pro-max" "ponytail" "worktrees" ];
};
```

Valid names are exactly the entries in the table above.
