# <Project> — Implementation Plan

| | |
|---|---|
| Project | <name — one line> |
| Repository | <url> |
| Source design | <SDD path / link> |
| Plan version | v1.0 — <date> |
| Owner | <name> |

## 1. Implementation Overview
### 1.1 Objective
<What the finished increment does for users, and the real starting point (what is already built).>
Status vocabulary: Done · Done — verification pending · Partial · Not started.

### 1.2 Source Design Artifacts
| Artifact | Location | Used for |
|---|---|---|

### 1.3 Planning Assumptions & Scope Guardrails
Assumptions A-xx (each needs owner confirmation) · scope guardrails (the design's non-goals).

## 2. Phase Summary
| Phase | Name | Demonstrable increment | Design scope (IDs) | Status |
|---|---|---|---|---|

## 3. Detailed Implementation Phases
### Phase N — <Name> (<status>)
- **Goal:**
- **Design references:**
- **Deliverables:**
- **Acceptance criteria:**
- **Dependencies:**
- **UI/UX artifacts:**
- **Evidence / gap:** (for built work)
- **Candidate Issues:**

## 4. Cross-Phase Dependencies
| Dependency | Why it matters | Affects |
|---|---|---|
### 4.1 Implementation Sequence
<Ordered steps; which Issues can run in parallel and why.>

## 5. GitHub Issue Decomposition Guidance
Each Issue = one agent feature cycle with: Context · Traceability · Acceptance criteria · Design
references · Dependencies / constraints · Verification · Out of scope.
### 5.1 Candidate Issue Inventory
| ID | GitHub | Title | Phase | Design trace | Status |
|---|---|---|---|---|---|

## 6. Risks, Open Decisions & Agent Guardrails
### 6.1 Open decisions (owner decides; agents must not guess)
| ID | Decision | Default until decided | Blocks |
|---|---|---|---|
### 6.2 Risks
| ID | Risk | Mitigation |
|---|---|---|
### 6.3 Agent guardrails
<Never-do rules and escalation triggers specific to this project.>

## 7. Handoff to GitHub Project
Fields: Status · Phase · Human Review (Pending → Reviewed) · Sequence · Priority · Area.
AI-created Issues enter at Backlog + Pending; the owner reviews, sets Reviewed, then Ready.
Rule: agents start an Issue only when Human Review = Reviewed and Status = Ready.
### 7.1 Final Readiness Checklist
- [ ] Every design story/constraint ID maps to at least one Issue
- [ ] Every Issue has all seven sections
- [ ] All Issues are in the Project with fields set
- [ ] Every Issue personally reviewed (Pending → Reviewed)
- [ ] Open decisions recorded, none silently assumed
- [ ] docs/ARCHITECTURE.md, POLICY.md, ROADMAP.md exist and agree with this plan
- [ ] At least one Reviewed + Ready Issue with satisfied prerequisites exists
