# Skills

Every name below is a valid entry in `programs.agent-skills.skills`. An empty
list installs all of them. Each group comes from one flake input; the input
header gives its upstream repo, license, and what it pulls onto your system.

## understand-anything

Upstream: github.com/Egonex-AI/Understand-Anything · License: unverified,
check before redistributing · Pulls: `node` + `python3` (mapped via
`cliPackages`; the flake also builds `packages/core` with pnpm)

| Skill | What it does |
|---|---|
| `understand` | Analyzes a codebase into a knowledge graph for architecture understanding |
| `understand-chat` | Ask questions about a codebase using its knowledge graph |
| `understand-dashboard` | Web dashboard to visualize the knowledge graph |
| `understand-diff` | Analyzes git diffs and PRs for what changed and the risks |
| `understand-domain` | Extracts business domain knowledge into a domain flow graph |
| `understand-explain` | Deep-dive explanation of a specific file, function, or module |
| `understand-figma` | Turns a Figma file into an interactive design graph (needs a Figma API token) |
| `understand-knowledge` | Builds a knowledge graph from an LLM-trained wiki knowledge base |
| `understand-onboard` | Generates an onboarding guide for new team members |

## ui-ux-pro-max

Upstream: github.com/nextlevelbuilder/ui-ux-pro-max-skill · License: MIT ·
Pulls: nothing extra (bundled data and reference files)

| Skill | What it does |
|---|---|
| `ui-ux-pro-max` | UI/UX design intelligence library: styles, palettes, font pairings, guidelines, stacks |
| `ui-styling` | Accessible interfaces with shadcn/ui and Tailwind |
| `design-system` | Token architecture, component specs, and slide generation |
| `banner-design` | Banners for social, ads, website heroes, and print |
| `brand` | Brand voice, visual identity, messaging, and asset management |
| `design` | Brand identity, logos, corporate identity programs, presentations, icons |
| `slides` | Strategic HTML presentations with Chart.js and design tokens |

## oh-my-opencode-slim

Upstream: github.com/alvinunreal/oh-my-opencode-slim pinned to tag v2.2.6 ·
License: MIT · Pulls: nothing extra (`worktrees` uses `git`)

| Skill | What it does |
|---|---|
| `clonedeps` | Clones project dependencies locally so library internals are inspectable |
| `codemap` | Generates comprehensive repository codemaps (expensive; run on request) |
| `deepwork` | Orchestrator workflow for large, high-risk, multi-phase coding efforts |
| `loop-engineering` | Loop engineering runtime, Grill plus Monitor |
| `oh-my-opencode-slim` | Configures and tunes agents, models, skills, and MCPs for this setup |
| `reflect` | Reviews recent sessions and proposes reusable skills, agents, and playbooks |
| `simplify` | Simplifies code for clarity without changing behavior |
| `verification-planning` | Builds project-specific verification plans before non-trivial changes |
| `worktrees` | Manages git worktrees as isolated coding lanes |

## ponytail

Upstream: github.com/DietrichGebert/ponytail · License: MIT · Pulls: nothing
extra

| Skill | What it does |
|---|---|
| `ponytail` | Lazy senior dev mode: the smallest change that fully solves the task |

Upstream also ships `ponytail-audit`, `ponytail-debt`, `ponytail-gain`,
`ponytail-help`, and `ponytail-review`; this flake packages only the main skill.

## stop-slop

Upstream: github.com/hardikpandya/stop-slop · License: MIT · Pulls: nothing
extra

| Skill | What it does |
|---|---|
| `stop-slop` | Removes AI writing patterns from prose |

## graphify

Upstream: github.com/Graphify-Labs/graphify · License: MIT · Pulls: the
`graphify` CLI, not packaged here; use `pkgs.graphify` from nixpkgs. The
skill's guidance works without it, but its CLI invocations need it.

| Skill | What it does |
|---|---|
| `graphify` | Turns code, docs, papers, images, and videos into a persistent knowledge graph |

## Example

```nix
programs.agent-skills = {
  enable = true;
  skills = [ "understand" "ui-ux-pro-max" "ponytail" "worktrees" ];
};
```
