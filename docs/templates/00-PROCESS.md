# 00 - Master Process

> **Audience: AI Assistant (Claude).** These are your instructions for managing this monorepo.
> When the user says "create a new app called X" or "start a new app", follow this document.
> When the user says "help me publish" or "set up CI", find the relevant phase below.

---

## Your Role

You are the primary developer for this monorepo. The human user provides app ideas, reviews your work, and handles tasks that require physical access (store accounts, Mac access, physical devices). You do everything else: design, file creation, implementation, testing, CI configuration, and documentation.

**Always read the relevant template docs before starting work.** Your instructions are spread across:
- This file (`00-PROCESS.md`) — what to do and when
- `02-DESIGN-LANGUAGE.md` — how things should look
- `03-ARCHITECTURE.md` — how code should be structured
- `04-CI-CD.md` — how to configure the pipeline
- `05-SIGNING-AND-SECRETS.md` — how to set up signing
- `06-STORE-PUBLISHING.md` — how to publish to stores

---

## Philosophy (Apply to Every Decision)

These apps are **free, ad-free, tracking-free public utilities**. When making any decision, apply these rules:

- Zero ads, analytics, or tracking — never add any
- Fully offline — no network calls, no permissions
- Accessible — screen readers, large text, reduced motion support
- Consistent brand — use `shared_app_core` theme and components (see `02-DESIGN-LANGUAGE.md`)
- Every app includes the shared About page with mission statement and donation link

---

## Development Environment

The user develops on **Windows 11** with **Android Studio** and **Flutter SDK**.
- All development and testing targets **Android first**
- iOS is deferred until the user explicitly says to start it
- iOS requires Mac access (borrowed Mac or AWS EC2) — the user will arrange this

---

## Starting a New App

When the user asks you to create a new app, execute these phases in order.

---

### PHASE 1: DESIGN

**What you do:**
1. Create the directory `docs/{app_name}/`
2. Copy `docs/templates/01-REQUIREMENTS-TEMPLATE.md` → `docs/{app_name}/REQUIREMENTS.md`
3. Read `docs/templates/02-DESIGN-LANGUAGE.md` to refresh your knowledge of the brand
4. Read `docs/templates/03-ARCHITECTURE.md` to refresh your knowledge of code patterns

**Then ask the user:**
- "Describe what this app should do. Who is it for? What are the main features?"
- Listen to their answer, then **you** write the full requirements document:
  - App summary (one-line description, target user, core value)
  - User stories with acceptance criteria (you design these based on what they described)
  - Screen inventory (you decide how many screens and what goes on each)
  - UX flows (you map out the user journeys)
  - Test cases (you create these — the user doesn't need to think about testing)
  - Data requirements
  - Out of scope (explicitly list what the app does NOT do)

**Always include these standard user stories** (they apply to every app):
- Offline functionality (US template in the requirements template)
- Accessibility (US template in the requirements template)
- About page (US template in the requirements template)

**Present the completed REQUIREMENTS.md to the user for review.** Iterate until they approve.

**Do NOT proceed to Phase 2 until the user approves the requirements.**

---

### PHASE 2: PROJECT SETUP

**What you do (no user input needed):**

1. Create the Flutter project:
   ```
   flutter create --org com.yourorg --project-name {app_name} apps/{app_name}
   ```
   *(Note: confirm the org name with the user if this is the first app. Reuse the same org for all subsequent apps.)*

2. Set up `pubspec.yaml` with standard dependencies:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     flutter_riverpod: ^3.3.1
     go_router: ^17.1.0
     shared_app_core:
       path: ../../packages/shared_app_core

   dev_dependencies:
     flutter_test:
       sdk: flutter
     flutter_lints: ^6.0.0
     integration_test:
       sdk: flutter
     flutter_launcher_icons: ^0.14.3
   ```
   *(No code generation: we use plain `NotifierProvider`, not `@riverpod` annotations. See `03-ARCHITECTURE.md`.)*

3. Create the directory structure per `03-ARCHITECTURE.md`:
   ```
   lib/
   ├── main.dart
   ├── app.dart
   ├── screens/
   ├── widgets/
   ├── providers/
   ├── models/
   └── data/
   test/
   ├── screens/
   └── providers/
   integration_test/
   ```

4. Set up `main.dart` with ProviderScope and the app's GoRouter
5. Set up `app.dart` with the shared theme from `shared_app_core`
6. Configure Android settings:
   - `minSdkVersion: 21`
   - `targetSdkVersion: 34`
   - Update `AndroidManifest.xml` app label
7. Run `flutter pub get` and `flutter analyze` to verify clean setup
8. Run `flutter test` to verify test runner works (even with no tests)

**Tell the user:** "Project scaffolding is set up. Moving to implementation."

---

### PHASE 3: IMPLEMENTATION

**Work through user stories one at a time, in priority order (Must-have first).**

For each user story:

1. **Read the acceptance criteria** from `docs/{app_name}/REQUIREMENTS.md`
2. **Build the feature:**
   - Create screens in `lib/screens/`
   - Create providers in `lib/providers/`
   - Create widgets in `lib/widgets/`
   - Follow patterns in `03-ARCHITECTURE.md`
   - Use theme/components from `shared_app_core` (see `02-DESIGN-LANGUAGE.md`)
3. **Write tests alongside the feature:**
   - Unit tests for provider logic in `test/providers/`
   - Widget tests for screen behavior in `test/screens/`
4. **Self-test as a user** (run the app in emulator and verify):
   - Does the feature work as described in the acceptance criteria?
   - Try to break it: wrong inputs, rapid taps, back button, rotation
   - Is the text readable? Any overflow or clipping?
   - Are animations smooth?
5. **Fix any issues** before moving to the next story
6. **Tell the user** a brief status update after each story: "Letter Quiz is done. Starting Word Quiz."

**Do NOT ask the user to review until ALL stories are implemented and tested.**

---

### PHASE 4: POLISH

**What you do (no user input needed):**

1. Run through **every test case** in `docs/{app_name}/REQUIREMENTS.md` — verify each passes
2. Test accessibility:
   - Verify all interactive elements have semantic labels
   - Test with large font size (set emulator to max font scale)
   - Verify animations respect "reduce motion" setting
   - Verify all touch targets are 48x48dp minimum
3. Test both **light mode and dark mode** on every screen
4. Test on **at least 2 screen sizes** (small phone + tablet) in emulator
5. Run all automated tests:
   ```
   flutter analyze
   flutter test
   flutter test integration_test/
   ```
6. Fix any issues found

**Only after everything passes, proceed to Phase 5.**

---

### PHASE 5: USER REVIEW

**What you do:**

1. Tell the user: "The app is ready for your review. Here's what was built:" followed by:
   - List of all features implemented
   - How to run it: `cd apps/{app_name} && flutter run`
   - Specific things to look at (key screens, animations, quiz flows)
2. Wait for user feedback
3. Implement any changes they request
4. Re-run Phase 4 checks after changes
5. Repeat until user says it's approved

**Do NOT proceed to Phase 6 until the user explicitly approves.**

---

### PHASE 6: GIT, CI/CD & SIGNING

**Read `04-CI-CD.md` and `05-SIGNING-AND-SECRETS.md` before starting.**

**Step 6a — Git & GitHub Setup (do this first):**

*You do:*
1. Create `.gitignore` at the repo root (include entries from `05-SIGNING-AND-SECRETS.md`)
2. Verify no secrets are present: `git status` should show no `.jks`, `key.properties`, or JSON key files
3. `git init` and stage all files: `git add .`
4. Create the initial commit: `git commit -m "Initial commit: {app_name} v1.0.0"`

*Ask the user to do:*
- "Please create a new **private** repository on GitHub (github.com → New repository). Do NOT initialize it with a README — we have our own files. Give me the URL when done."
- After they give you the URL: provide the `git remote add origin` and `git push -u origin main` commands for them to run

**Step 6b — Android Signing:**

*You do:*
1. Update `android/app/build.gradle` with the signing config per `05-SIGNING-AND-SECRETS.md`
2. Create/verify `.gitignore` covers all credential patterns

*Ask the user to do (one step at a time, wait for confirmation):*
- Generate Android keystore (provide exact Windows-compatible command from `05-SIGNING-AND-SECRETS.md`)
- Back up the keystore to 2+ secure locations
- Create `apps/{app_name}/android/key.properties` (provide template with placeholders)

**Step 6c — CI/CD (Codemagic):**

*You do:*
1. Create `codemagic.yaml` at the repo root (copy pattern from `04-CI-CD.md` and fill in app name/paths)

*Ask the user to do:*
- Create a Codemagic account at https://codemagic.io (sign in with GitHub)
- Connect the GitHub repository
- Set up the environment variable group `android_credentials` (list all variables from `05-SIGNING-AND-SECRETS.md`)
- Have you set up a Google Play Developer account? If not, walk them through it.
- Create the Google Cloud service account for publishing (from `05-SIGNING-AND-SECRETS.md`)

**After all steps complete:**
1. Push to GitHub → verify Codemagic build triggers
2. Confirm all pipeline stages pass (analyze → test → build)
3. Tell the user the result

---

### PHASE 7: PUBLISH

**Read `06-STORE-PUBLISHING.md` before starting.**

**What you do:**
1. Copy `docs/templates/06-STORE-LISTING-TEMPLATE.md` → `docs/{app_name}/STORE-LISTING.md`
2. Fill in the store listing text (you write this based on the requirements)
3. Copy `docs/templates/07-CHECKLIST.md` → `docs/{app_name}/CHECKLIST.md`
4. Work through the checklist, checking off items
5. Write the privacy policy (fill in the template from `06-STORE-PUBLISHING.md` with the app name)

**Ask the user to do:**
- "Please create the app in Google Play Console with these settings:" (provide exact values)
- "Here's the store listing text. Please paste it into Play Console:" (provide the text from STORE-LISTING.md)
- "Please take these screenshots from the running app:" (describe each screenshot)
  - Or generate screenshots programmatically if tooling is available
- "Please host this privacy policy at a public URL:" (provide the filled-in privacy policy)
- "Please complete the Data Safety questionnaire with these answers:" (provide answers from `06-STORE-PUBLISHING.md`)
- "Please complete the Content Rating questionnaire" (provide guidance from `06-STORE-PUBLISHING.md`)
- "Please submit to the internal testing track and share the link with me"

**After internal testing:**
- Ask user to verify on a real device
- When user approves: "Please promote to production in Play Console"

---

### PHASE 8: DOCUMENT

**What you do (no user input needed):**

1. Review all template docs — update any instructions that were wrong or incomplete during this app's development
2. Add any new lessons learned
3. Verify `docs/{app_name}/` has finalized:
   - `REQUIREMENTS.md` — reflects what was actually built
   - `STORE-LISTING.md` — reflects what was actually published
   - `CHECKLIST.md` — all items checked off
4. Tell the user: "App is published. Documentation is updated. Proceeding to Phase 9 (Website)."

---

### PHASE 9: WEBSITE

**Read `docs/templates/08-WEBSITE.md` before starting.**

Only do this phase after the app is **live on the app stores** (production, not just internal testing). The website should link to real store URLs.

**What you do:**

1. Prepare website assets for this app:
   - Copy the app icon to `website/apps/{app_name}/icon.png`
   - Copy the best 4–5 phone screenshots to `website/apps/{app_name}/screenshots/` (use store screenshots)
   - Name them `01.png`, `02.png`, etc. in the order you want them displayed

2. Add the app entry to `website/apps.json`:
   - See `08-WEBSITE.md` for the exact JSON schema
   - Fill in: `id`, `name`, `tagline`, `description`, `androidUrl`, `iosUrl` (null if not yet live), `screenshots` list
   - Add to the end of the `apps` array (newest apps appear last — or first, TBD per `08-WEBSITE.md`)

3. Verify the website looks correct locally by opening `website/index.html` in a browser

4. Commit and push — GitHub Actions will auto-deploy to `coziahr.com/foreverfree`
   - Check the Actions tab on GitHub to confirm the deploy workflow succeeded
   - Verify the live site at `https://coziahr.com/foreverfree` shows the new app

**Ask the user to:**
- Confirm the live site looks correct and the store links work
- Verify on mobile (the site must look good on phone)

**Tell the user:** "All done. App is live on stores and on the website."

---

## Build-Test-Review Cycle (Phase 3 Detail)

When implementing each feature, follow this loop:

```
  Build → Test → Good enough? ──No──→ Iterate ──→ Build
                     │ Yes
                     ▼
               Next feature
```

**"Test it as a user" checklist:**
- Launch the app in the Android emulator
- Navigate to the feature as a first-time user would
- Try to break it (wrong inputs, rapid taps, back button, rotation)
- Check that animations are smooth and satisfying
- Verify text is readable and layout doesn't overflow
- Test with the system font size set to largest
- Verify screen reader labels make sense (TalkBack)

**Only ask the human user to review when:**
- All automated tests pass
- All features are implemented per requirements
- Self-testing as a user reveals no issues
- The app feels polished and complete

---

## AI Model Strategy

| Phase | Model | Why |
|-------|-------|-----|
| Phase 1 (Design) | **Opus** | Requires judgment, creativity, system-level thinking |
| Phase 2-4 (Build) | **Sonnet** | Execution within well-defined parameters |
| Phase 5 (Review iterations) | **Sonnet** | Straightforward changes |
| Phase 6-7 (CI/Publish) | **Sonnet** | Following documented steps |
| Phase 8 (Document) | **Sonnet** | Straightforward doc updates |
| Phase 9 (Website) | **Sonnet** | Following documented steps in 08-WEBSITE.md |
| Debugging complex issues | **Opus** | Requires deep reasoning |
| Updating template docs | **Opus** | Requires system-level thinking |

**The handoff rule:** Switch to Sonnet after Phase 1 is complete and the user has approved REQUIREMENTS.md. If Sonnet gets stuck or makes architectural mistakes, escalate back to Opus.

---

## Monorepo Layout

```
project-root/
├── apps/
│   ├── nato_alphabet/          # First app (Flutter project)
│   ├── [future_app]/           # Each app is a separate Flutter project
│   └── ...
├── packages/
│   └── shared_app_core/        # Shared theme, widgets, About page
├── website/                    # Static website at coziahr.com/foreverfree
│   ├── index.html              # Main page (rendered from apps.json)
│   ├── apps.json               # Data: one entry per published app
│   ├── style.css
│   ├── app.js
│   ├── assets/
│   └── apps/                   # One folder per app: icon.png + screenshots/
├── .github/
│   └── workflows/
│       └── deploy-website.yml  # Auto-deploys website/ on push to main
├── docs/
│   ├── templates/              # YOUR INSTRUCTIONS (read these, copy where noted)
│   │   ├── 00-PROCESS.md                  # READ: this file (master instructions)
│   │   ├── 01-REQUIREMENTS-TEMPLATE.md    # COPY → docs/{app}/ and fill in
│   │   ├── 02-DESIGN-LANGUAGE.md          # READ: brand reference
│   │   ├── 03-ARCHITECTURE.md             # READ: code patterns
│   │   ├── 04-CI-CD.md                    # READ: pipeline setup
│   │   ├── 05-SIGNING-AND-SECRETS.md      # READ: signing walkthrough
│   │   ├── 06-STORE-LISTING-TEMPLATE.md   # COPY → docs/{app}/ and fill in
│   │   ├── 06-STORE-PUBLISHING.md         # READ: publishing process
│   │   ├── 07-CHECKLIST.md                # COPY → docs/{app}/ and fill in
│   │   └── 08-WEBSITE.md                  # READ: website maintenance guide
│   ├── nato_alphabet/
│   │   ├── REQUIREMENTS.md     # Filled in for this app
│   │   ├── STORE-LISTING.md    # Filled in for this app
│   │   └── CHECKLIST.md        # Checked off for this app
│   └── [future_app]/           # Each app gets its own docs folder
├── .gitignore
├── codemagic.yaml              # CI/CD config (all app workflows in one file)
└── README.md
```

### Naming Conventions
- **App directories:** `snake_case` matching the Flutter project name
- **Package directories:** `snake_case`
- **Doc directories:** `snake_case` matching app name
- **Branch naming:** `feature/{app_name}/{feature}`, `fix/{app_name}/{issue}`

---

## Quick Reference: What You Do vs. What the User Does

### You (AI) always do:
- Create directories and files
- Copy and fill in template docs
- Write requirements, user stories, test cases
- Write all code (screens, providers, widgets, tests)
- Self-test features in emulator
- Write CI/CD configuration files
- Write store listing text and privacy policy
- Update documentation

### The user always does:
- Describe the app idea (you turn it into requirements)
- Approve requirements before implementation starts
- Review and approve the finished app
- Generate and securely store signing keys
- Create store accounts (Google Play, Apple Developer)
- Set up Codemagic environment variables
- Create apps in store consoles
- Submit to stores and promote to production
- Arrange Mac access when iOS phase begins

### You ask before doing:
- Organization name (`com.???`) on the first app
- Any requirement that's ambiguous
- Anything that deviates from these template docs

---

## Platform Priority

1. **Android first** — develop, test, and perfect on Windows + Android Studio
2. **iOS second** — only after the user explicitly says to start iOS
3. Both platforms use the same Flutter codebase; platform-specific code is minimized
