# Requirements — [APP NAME]

> **AI:** Copy this file to `docs/{app_name}/REQUIREMENTS.md` and fill in every section.
> Ask the user to describe the app idea, then YOU write all user stories, UX flows, and test cases.
> Present the completed document to the user for review before proceeding to implementation.
> Delete all placeholder text in [brackets] as you fill in real content.

---

## App Summary

**One-line description:** [What does this app do in one sentence?]

**Target user:** [Who is this for? Be specific.]

**Core value:** [Why would someone install this instead of doing without?]

---

## User Stories

Write every feature as a user story. Format:

```
As a [type of user], I want to [action] so that [benefit].
```

Each story needs:
- **Acceptance criteria** — specific, testable conditions that must all be true
- **Priority** — Must-have, Should-have, or Nice-to-have

Build Must-haves first. Ship without Nice-to-haves if needed.

### US-1: [Feature Name]
**As a** [user], **I want to** [action] **so that** [benefit].

**Acceptance criteria:**
- [Testable condition 1]
- [Testable condition 2]
- [...]

**Priority:** [Must-have / Should-have / Nice-to-have]

---

### US-N: Use the App Offline
> Include this story in every app — it's a core principle.

**As a** user, **I want** the app to work without internet **so that** I can use it anywhere.

**Acceptance criteria:**
- App launches and functions fully with airplane mode enabled
- No network calls are made at any point
- No error messages or degraded experience offline

**Priority:** Must-have

---

### US-N: Use the App with Accessibility Features
> Include this story in every app — it's a core principle.

**As a** user with a disability, **I want** the app to work with screen readers and large text **so that** I can use it like anyone else.

**Acceptance criteria:**
- All interactive elements have semantic labels for TalkBack / VoiceOver
- App is usable with system font scaled to 200%
- Touch targets are at least 48x48dp
- Color is never the only way information is conveyed
- Animations respect system "reduce motion" setting

**Priority:** Must-have

---

### US-N: View the About Page
> Include this story in every app — uses the shared_app_core About page.

**As a** user, **I want to** learn about the app and its creator **so that** I understand the mission and can support it.

**Acceptance criteria:**
- Accessible from every screen (info icon in app bar)
- Shows shared mission statement, donation link, and app version
- Donation link opens in external browser

**Priority:** Must-have

---

## Screen Inventory

List every screen with a brief description. Keep it minimal — fewer screens = less to build.

| Screen | Description |
|--------|-------------|
| [Screen 1] | [What the user sees and does here] |
| [Screen 2] | [What the user sees and does here] |
| **About** | Shared About page (mission, donation, version) |

---

## UX Flows

Walk through the app as a user. Every major path through the app gets its own flow.

### Flow 1: [Flow Name]
1. [User action] → [what happens]
2. [User action] → [what happens]
3. [...]

### Flow 2: [Flow Name]
1. [...]

---

## Test Cases

Define test cases BEFORE writing code. Test each as if you're a first-time user.

Format:
| ID | Test | Expected Result |
|----|------|-----------------|
| T-XX1 | [What you do] | [What should happen] |

Group by screen or feature. Include:
- **Happy path** — normal usage
- **Edge cases** — empty states, very long inputs, rapid interactions
- **Orientation** — portrait and landscape
- **Accessibility** — TalkBack, large font
- **Offline** — airplane mode

---

## Data Requirements

| Data | Source | Storage |
|------|--------|---------|
| [What data] | [Where it comes from] | [How it's stored: hardcoded, local DB, in-memory, etc.] |

For offline apps: prefer hardcoded constants or bundled assets. No network-fetched data.

---

## Out of Scope

Explicitly list things this app does NOT do (prevents scope creep):

- [Thing people might expect but we're not building]
- [...]
