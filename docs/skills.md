# Skills

The 62 skills this flake can install, sorted by the input that provides them.
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
| `ai-estimates` | Estimates task duration for a human working with AI | [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) |
| `deanchor` | Treats examples as evidence of intent, not templates to copy | [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) |
| `step-back` | Pauses patch-on-patch work and proposes a cleaner direction | [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) |
| `ponytail` | Lazy senior dev mode: the smallest change that fully solves the task | [ponytail](https://github.com/DietrichGebert/ponytail) |
| `stop-slop` | Removes AI writing patterns from prose | [stop-slop](https://github.com/hardikpandya/stop-slop) |
| `graphify` | Turns code, docs, papers, images, and videos into a persistent knowledge graph | [graphify](https://github.com/Graphify-Labs/graphify) |

### Matt Pocock

The 27 skills in the upstream plugin manifest (`skills/engineering` +
`skills/productivity`). `in-progress/` and `misc/` are not shipped.

| Skill | Description |
|---|---|
| `ask-matt` | Router for choosing which skill or flow fits the situation |
| `code-review` | Two-axis review of a diff: repo standards and originating spec |
| `codebase-design` | Vocabulary and discipline for designing deep modules |
| `diagnosing-bugs` | Feedback-loop-first diagnosis for hard bugs and regressions |
| `domain-modeling` | Build and sharpen `GLOSSARY.md` and ADRs |
| `grill-with-docs` | Grilling session that also writes ADRs and glossary entries |
| `implement` | Implement a spec or ticket set, driving TDD at agreed seams |
| `implement-spec` | Implement a whole spec as a ticket task graph |
| `improve-codebase-architecture` | Survey deepening opportunities, then grill one |
| `pr` | Shape a pull request body and merge-danger call |
| `prototype` | Throwaway prototype for a state/logic or UI question |
| `research` | Primary-source research captured as a cited Markdown note |
| `retro` | Session retrospective on the agent environment |
| `setup-matt-pocock-skills` | Configure tracker, triage labels, and domain docs once per repo |
| `tdd` | Red-green-refactor TDD with vertical slices |
| `to-spec` | Synthesize the conversation into a published spec |
| `to-tickets` | Break a plan into tracer-bullet tickets with blocking edges |
| `triage` | Move issues through triage roles and write agent-ready briefs |
| `wayfinder` | Multi-session decision map for work too large for one session |
| `wizard` | Generate an interactive bash wizard for human-only steps |
| `grill-me` | Relentless interview to sharpen a plan or design |
| `grilling` | Shared interview primitive behind the grill flows |
| `handoff` | Compact the conversation into a handoff document |
| `teach` | Teach a concept over multiple sessions in a workspace |
| `to-questionnaire` | Turn a decision into an async questionnaire |
| `wait-what` | Re-pitch a message that did not land |
| `writing-for-agents` | Writing skills, AGENTS.md, and agent-facing docs |

### Context7

| Skill | Description |
|---|---|
| `context7-docs` | Pi-specific: use the Context7 MCP tools for current library docs |
| `context7-mcp` | Generic MCP-tools guidance for library docs and API references |
| `find-docs` | CLI fallback via `npx ctx7@latest library` / `docs` |
| `context7-cli` | `ctx7` setup, login, and documentation commands |

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
