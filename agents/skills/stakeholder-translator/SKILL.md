---
name: stakeholder-translator
description: Reframe the same information for different stakeholders without changing the facts. Use when asked "how do I explain this to", "translate this for", "make this exec-friendly", "reframe for engineering", "present to leadership", "write an update for [audience]", or otherwise adapt a message to a specific audience.
---

# Stakeholder Translator

Communicate the same substance to the requested audience. Choose the relevant audience profile below and make each version stand alone.

## Audience profiles

### Executives / Leadership

- **Lead with:** Business impact: revenue, competitive positioning, market timing.
- **Format:** Bottom line up front, then 3–5 supporting bullets. Keep it to one page at most.
- **Language:** Strategic and decision-oriented. Explain what this unlocks and the risk of inaction.
- **Include:** A clear ask: the decision, resources, or alignment needed.
- **Avoid:** Implementation details, technical architecture, feature lists.

### Technical Leads / Engineering

- **Lead with:** The problem and constraints before the solution.
- **Format:** Problem → proposed approach → open questions → acceptance criteria.
- **Language:** Precise and technical. Explain why, not only what.
- **Include:** Edge cases, dependencies, scope boundaries, and what is explicitly out of scope.
- **Avoid:** Marketing language, vague timelines, and hand-wavy requirements.

### Field / Solutions Engineers

- **Lead with:** The customer pain point and what changes for them.
- **Format:** What's shipping → how it works → what they can tell customers → known limitations.
- **Language:** Practical and customer-facing; write for field enablement.
- **Include:** Talking points, competitive positioning, and timeline when known.
- **Avoid:** Internal politics, architectural debates, and tentative plans they cannot share.

### Sales / Go-To-Market

- **Lead with:** Customer value and deal impact.
- **Format:** Elevator pitch → key differentiators → objection handling → packaging implications.
- **Language:** Outcome-oriented. Explain what customers can now do and what this replaces, when supported by the facts.
- **Include:** Competitive positioning, which segments benefit most, and what not to promise.
- **Avoid:** Technical depth, internal roadmap details, and speculative timelines.

### External Developers / API Consumers

- **Lead with:** What's new and how it affects their integration.
- **Format:** Changelog style: what changed → migration steps → code examples.
- **Language:** Direct and technical. Show the change concretely.
- **Include:** API changes, breaking changes, deprecation timelines, and documentation links when available.
- **Avoid:** Business rationale and internal context.

## Rules

- Preserve the facts across versions. Change the framing, not the substance.
- Use one audience per section. Make each version understandable on its own.
- Flag conflicts explicitly when what one audience needs to hear conflicts with another.
- Do not invent impact, timelines, positioning, migration steps, or commitments. If essential details are missing, identify them as open questions.
