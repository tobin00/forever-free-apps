# Country Flags App — Master TODO

> **This file is the single source of truth for all work on the Country Flags app.**
> Work through phases in order. Do not start a phase until the previous one is complete and verified.
> Each phase ends with a clear success condition — stop, verify, then continue.
>
> **Who does what:**
> - **AI** — design, code, tests, CI config, store listing text, documentation
> - **USER** — approve design, review app, handle accounts/keys/consoles, confirm live results
>
> **Reference docs:** All template docs are in `docs/templates/`. Read the relevant one before starting each phase.

---

## Current Status

- 🔄 **Phase 1 IN PROGRESS:** Requirements gathering — awaiting user description of app idea.
- ⬜ Phase 2: Project setup
- ⬜ Phase 3: Implementation
- ⬜ Phase 4: Polish & testing
- ⬜ Phase 5: User review
- ⬜ Phase 6: Android signing & CI/CD
- ⬜ Phase 7: Store preparation
- ⬜ Phase 8: Internal testing & first release
- ⬜ Phase 9: Promote to production (Android)
- ⬜ Phase 10: Ko-fi / donation page
- ⬜ Phase 11: Website update
- ⬜ Phase 12: iOS (deferred — start only when user asks)
- ⬜ Phase 13: Final documentation & cleanup

---

## Phase 1: Requirements Gathering & Design

**Goal:** A complete, approved REQUIREMENTS.md that defines every feature, screen, UX flow, and test case.
No code is written until this is approved.

**Read before starting:** `docs/templates/00-PROCESS.md`, `docs/templates/01-REQUIREMENTS-TEMPLATE.md`, `docs/templates/02-DESIGN-LANGUAGE.md`

### Step 1.1 — App description (USER does this)
- [ ] User describes the app: what it does, who it's for, what the main features are
  - Suggested prompt: "Describe what Country Flags should do. Who is it for? What are the main features?"

### Step 1.2 — AI writes REQUIREMENTS.md (AI does this)
- [ ] AI reads `docs/templates/01-REQUIREMENTS-TEMPLATE.md`
- [ ] AI reads `docs/templates/02-DESIGN-LANGUAGE.md` (brand reference)
- [ ] AI reads `docs/templates/03-ARCHITECTURE.md` (code patterns)
- [ ] AI fills in `docs/country_flags/REQUIREMENTS.md` with:
  - [ ] App summary (one-line description, target user, core value)
  - [ ] All user stories with acceptance criteria and priority (Must-have first)
  - [ ] US: Offline functionality (standard, every app)
  - [ ] US: Accessibility (standard, every app)
  - [ ] US: About page (standard, every app)
  - [ ] Screen inventory (all screens with descriptions)
  - [ ] UX flows (every major user journey mapped out)
  - [ ] Test cases (happy path + edge cases + accessibility + offline)
  - [ ] Data requirements (what data, where it comes from, how stored)
  - [ ] Out of scope (explicit list of what the app does NOT do)

### Step 1.3 — User review (USER does this)
- [ ] User reads `docs/country_flags/REQUIREMENTS.md`
- [ ] User approves OR requests changes
- [ ] AI iterates until user explicitly says "approved"

### ✅ Phase 1 Success Condition
`docs/country_flags/REQUIREMENTS.md` is complete and USER has explicitly approved it.
No implementation work starts until this condition is met.

---

## Phase 2: Project Setup

**Goal:** A clean Flutter project that compiles, analyzes with zero errors, and has passing tests.

> Note: The Flutter project scaffold has already been created at `apps/country_flags/`.
> This phase completes the setup: dependencies, code structure, Android config.

**Read before starting:** `docs/templates/03-ARCHITECTURE.md`

### Step 2.1 — Flutter project (AI does this — partially done)
- [x] `flutter create --org com.foreverfree --project-name country_flags apps/country_flags` ✅
- [x] `pubspec.yaml` updated with standard dependencies (riverpod, go_router, shared_app_core, etc.) ✅
- [x] `android/app/build.gradle.kts` updated with signing config template ✅
- [x] `AndroidManifest.xml` label updated to "Country Flags" ✅
- [x] Directory structure created: `lib/screens/`, `lib/widgets/`, `lib/providers/`, `lib/models/`, `lib/data/` ✅
- [x] `lib/main.dart` stubbed with ProviderScope ✅
- [x] `lib/app.dart` stubbed with GoRouter and shared theme ✅
- [x] `lib/screens/home_screen.dart` stub created ✅
- [x] `integration_test/app_test.dart` stub created ✅

### Step 2.2 — Complete setup after requirements approval (AI does this)
- [ ] Replace stub screens with real screens per approved REQUIREMENTS.md
- [ ] Add all routes to `app.dart` GoRouter
- [ ] Add app icon placeholder to `assets/icon/` (placeholder or designed icon)
- [ ] Add country data asset to `assets/data/` (JSON file with country names + flag info)
- [ ] Run `flutter pub get` — confirm clean
- [ ] Run `flutter analyze` — confirm zero errors
- [ ] Run `flutter test` — confirm test runner works (even with no real tests yet)

### Step 2.3 — Verify Android config (AI does this)
- [ ] Confirm `applicationId = "com.foreverfree.country_flags"` in `build.gradle.kts`
- [ ] Confirm `minSdk` is 21 or higher
- [ ] Confirm `android:label="Country Flags"` in `AndroidManifest.xml`

### ✅ Phase 2 Success Condition
`flutter pub get`, `flutter analyze`, and `flutter test` all pass with zero errors.
The directory structure matches the architecture template.

---

## Phase 3: Implementation

**Goal:** All Must-have user stories are implemented, tested, and self-verified.

**Read before starting:** `docs/templates/02-DESIGN-LANGUAGE.md`, `docs/templates/03-ARCHITECTURE.md`

> Work through user stories one at a time, in Must-have → Should-have order.
> For each story: build → write tests → self-test in emulator → fix → move on.
> Do NOT ask the user to review until ALL stories are done.

### Step 3.1 — Data layer (AI does this first)
- [ ] Design country data model in `lib/models/`
  - [ ] Define `Country` class: name, ISO code, flag emoji (or SVG path), region, capital (if applicable)
- [ ] Create country data in `lib/data/` (bundled JSON or Dart constants)
  - [ ] Include all ~195 sovereign nations
  - [ ] Include flag representation (emoji Unicode and/or bundled SVG assets)
  - [ ] Verify data is complete and accurate
- [ ] Write unit tests for data loading and model parsing
- [ ] Run tests: `flutter test test/` — confirm pass

### Step 3.2 — Implement each user story (AI does this)
> Stories to be filled in after REQUIREMENTS.md is approved.
> Template for each story below:

**Story [US-X]: [Feature Name]**
- [ ] Implement screen in `lib/screens/`
- [ ] Implement provider in `lib/providers/` (if stateful)
- [ ] Implement widgets in `lib/widgets/` (if reusable)
- [ ] Write unit tests for provider logic in `test/providers/`
- [ ] Write widget tests for screen behavior in `test/screens/`
- [ ] Self-test in Android emulator:
  - [ ] Feature works as described in acceptance criteria
  - [ ] Try to break it (wrong inputs, rapid taps, back button, rotation)
  - [ ] Text is readable, no overflow or clipping
  - [ ] Animations are smooth
- [ ] Tell user: "[Story name] is done. Starting [next story]."

### Step 3.3 — Standard stories (AI does these in every app)

**About page (shared_app_core)**
- [ ] Info icon in app bar on every screen navigates to About page
- [ ] About page uses `shared_app_core` AboutPage widget
- [ ] Donation link opens Ko-fi in external browser
- [ ] App version shown correctly
- [ ] Write widget test for About page navigation
- [ ] Self-test: About page opens, closes, link taps correctly

**Offline functionality**
- [ ] Enable airplane mode in emulator, verify full functionality
- [ ] Verify no network calls (no internet permission in manifest)
- [ ] Document in test cases

**Accessibility**
- [ ] All interactive elements have Semantics labels
- [ ] Test with emulator font scale set to largest
- [ ] Test TalkBack navigation (at minimum: can reach all interactive elements)
- [ ] All touch targets ≥ 48x48dp

### ✅ Phase 3 Success Condition
All Must-have user stories are implemented.
`flutter test` passes with meaningful test coverage for all providers and key screens.
Self-testing in emulator reveals no issues.

---

## Phase 4: Polish & Pre-Release Testing

**Goal:** App is polished, fully tested, and ready for human review.

**Read before starting:** `docs/country_flags/CHECKLIST.md`

### Step 4.1 — Automated tests (AI does this)
- [ ] `flutter analyze` — zero errors, zero warnings
- [ ] `flutter test test/` — all unit and widget tests pass
- [ ] `flutter test integration_test/` — all integration tests pass (run locally with emulator)
- [ ] No `TODO`, `FIXME`, `print()`, or `debugPrint()` left in code

### Step 4.2 — Manual testing on emulator (AI does this)
- [ ] Test every test case from `docs/country_flags/REQUIREMENTS.md`
- [ ] Test on small phone emulator (e.g., Pixel 4a — 5.8" screen)
- [ ] Test on 7-inch tablet emulator
- [ ] Test on 10-inch tablet emulator
- [ ] Test in portrait AND landscape on each device
- [ ] Test with airplane mode enabled — full functionality confirmed

### Step 4.3 — Accessibility audit (AI does this)
- [ ] Enable TalkBack on emulator → navigate entire app
- [ ] Set system font to maximum → verify all text is readable and no overflow
- [ ] Verify all touch targets are ≥ 48×48dp
- [ ] Verify no information is conveyed by color alone
- [ ] Verify all interactive elements have semantic labels

### Step 4.4 — Visual audit (AI does this)
- [ ] Light mode: every screen looks correct
- [ ] Dark mode: every screen looks correct
- [ ] No text clipping or overflow on any screen
- [ ] Back button behavior is correct everywhere
- [ ] App icon displays correctly at all sizes

### Step 4.5 — Performance check (AI does this)
- [ ] App launches in under 2 seconds
- [ ] Screen transitions are smooth
- [ ] Scrolling is smooth (no jank)
- [ ] Flag images (if any) load without perceptible delay

### Step 4.6 — Build check (AI does this)
- [ ] Version number in `pubspec.yaml` is correct (start with `1.0.0+1`)
- [ ] `flutter build appbundle --release` succeeds (using debug keystore for now)
- [ ] AAB file exists at expected path

### ✅ Phase 4 Success Condition
All automated tests pass. All manual test cases pass. No lint errors.
Both light and dark mode look correct. Accessibility audit passes.
The app feels polished and complete.

---

## Phase 5: User Review

**Goal:** User approves the app before publishing workflow begins.

### Step 5.1 — AI presents the app
- [ ] AI tells user: "The app is ready for your review. Here's what was built:" + feature list
- [ ] AI provides run instructions: `cd apps/country_flags && flutter run`
- [ ] AI highlights specific things to check (key screens, any tricky interactions)

### Step 5.2 — User tests the app (USER does this)
- [ ] User runs the app on emulator or physical device
- [ ] User checks all main features
- [ ] User checks dark mode
- [ ] User checks airplane mode
- [ ] User provides feedback or says "approved"

### Step 5.3 — Iterate (AI does this)
- [ ] AI implements any changes the user requests
- [ ] AI re-runs Phase 4 checks after every change
- [ ] Repeat until user explicitly says "approved"

### ✅ Phase 5 Success Condition
User has explicitly approved the app. No further feature changes planned.

---

## Phase 6: Android Signing & CI/CD

**Goal:** A release keystore exists, is backed up, and the CI/CD pipeline builds + publishes automatically.

**Read before starting:** `docs/templates/04-CI-CD.md`, `docs/templates/05-SIGNING-AND-SECRETS.md`

### Step 6.1 — Pre-flight checks (AI does this)
- [ ] `flutter analyze` — zero errors
- [ ] `flutter test` — all tests pass
- [ ] `flutter test integration_test/` — passes locally
- [ ] `git status` — no `.jks`, `key.properties`, or credential files staged
- [ ] `.gitignore` has all credential patterns from `05-SIGNING-AND-SECRETS.md`

### Step 6.2 — Generate Android keystore (USER does this — with AI guidance)
> ⚠️ THE KEYSTORE IS IRREPLACEABLE. If lost, you can never update the app. Back it up FIRST.

- [ ] Open Android Studio Terminal or Windows PowerShell
- [ ] Run (AI provides the exact command):
  ```
  keytool -genkey -v -keystore country_flags.jks -alias country_flags_key -keyalg RSA -keysize 2048 -validity 36500
  ```
- [ ] Note the path where `country_flags.jks` was saved

### Step 6.3 — Back up the keystore (USER does this)
- [ ] Copy `country_flags.jks` to Dropbox (`C:\Users\tcozi\Dropbox\private\androidkeys\`)
- [ ] Copy to password manager vault (1Password, Bitwarden, etc.)
- [ ] Save the keystore password in password manager
- [ ] Confirm 2+ backups exist before continuing

### Step 6.4 — Create `key.properties` (AI does this — after user provides path + password)
- [ ] User tells AI: full path to `country_flags.jks` and keystore password
- [ ] AI creates `apps/country_flags/android/key.properties`:
  ```
  storeFile=C:\\Users\\tcozi\\path\\to\\country_flags.jks
  storePassword=USER_PROVIDED
  keyAlias=country_flags_key
  keyPassword=USER_PROVIDED
  ```
- [ ] Verify `key.properties` is NOT tracked by git (`git status` check)

### Step 6.5 — Verify release build locally (AI does this)
- [ ] `flutter build appbundle --release` in `apps/country_flags/`
- [ ] Confirm build succeeds with no errors
- [ ] Confirm `build/app/outputs/bundle/release/app-release.aab` exists
- [ ] Note AAB size

### Step 6.6 — CI/CD: Codemagic (AI + USER)
> First time: Codemagic account already exists (set up for nato_alphabet). Skip account creation.

**AI does:**
- [x] `codemagic.yaml` already updated with `country-flags-android` workflow ✅
- [x] Note: Uses separate env var group variables (`CM_KEYSTORE_COUNTRY_FLAGS` etc.) to keep keystores separate

**USER does:**
- [ ] Base64-encode keystore (AI provides PowerShell command):
  ```powershell
  [Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\path\to\country_flags.jks")) | Out-File country_flags_base64.txt
  ```
- [ ] Save base64 output to `C:\Users\tcozi\Dropbox\private\androidkeys\country_flags_base64.txt`
- [ ] In Codemagic UI → Teams → Environment Variables → `android_credentials` group, add:
  - [ ] `CM_KEYSTORE_COUNTRY_FLAGS` = contents of `country_flags_base64.txt` (mark Secure)
  - [ ] `CM_KEYSTORE_PASSWORD_COUNTRY_FLAGS` = keystore password (mark Secure)
  - [ ] `CM_KEY_ALIAS_COUNTRY_FLAGS` = `country_flags_key` (mark Secure)
  - [ ] `CM_KEY_PASSWORD_COUNTRY_FLAGS` = key password (mark Secure)
  - Note: `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` already exists — reuse it (same Google Cloud service account works for all apps)
- [ ] Verify all 4 new variables are in `android_credentials` group and marked Secure

### Step 6.7 — Create app in Google Play Console (USER does this)
> The Google Play developer account already exists (set up for nato_alphabet). Skip account creation.

- [ ] In Play Console: click **Create app**
- [ ] App name: `Country Flags` (or final name from STORE-LISTING.md)
- [ ] Default language: English (United States)
- [ ] App or Game: **App**
- [ ] Free or Paid: **Free**
- [ ] Accept declarations → click **Create app**
- [ ] Note the package name shown — must match `com.foreverfree.country_flags`

### Step 6.8 — Trigger first CI build (AI pushes trigger commit)
- [ ] AI bumps version in `pubspec.yaml` (e.g., `1.0.0+1` → `1.0.1+2`) and pushes to `main`
- [ ] USER watches build in Codemagic dashboard → `country-flags-android` workflow
- [ ] Verify each stage passes: Analyze ✅ → Tests ✅ → Build ✅ → Publish ✅
- [ ] Confirm the `.aab` build artifact is downloadable from Codemagic

### ✅ Phase 6 Success Condition
Keystore backed up in 2+ locations. `key.properties` is NOT in git.
A push to `main` triggers the `country-flags-android` Codemagic workflow.
All pipeline stages pass. AAB uploaded to Google Play internal testing track.

---

## Phase 7: Store Preparation

**Goal:** The Play Store listing is complete, polished, and ready for users to see.

**Read before starting:** `docs/templates/06-STORE-PUBLISHING.md`, `docs/templates/06-STORE-LISTING-TEMPLATE.md`

### Step 7.1 — Privacy policy (AI writes; USER hosts)
- [ ] AI generates privacy policy for Country Flags app
  - Contact email: `makeitforeverfree@gmail.com`
  - Update `privacy/index.html` in the repo to include Country Flags section (or create a separate page)
- [ ] AI commits and pushes `privacy/` update
- [ ] USER confirms privacy policy URL is publicly accessible:
  `https://tobin00.github.io/forever-free-apps/privacy/`

### Step 7.2 — Complete STORE-LISTING.md (AI does this)
- [ ] AI opens `docs/country_flags/STORE-LISTING.md`
- [ ] AI fills in all sections:
  - [ ] App name (max 30 chars)
  - [ ] Short description (max 80 chars) — mention "free" and "no ads"
  - [ ] Full description (max 4000 chars) — feature list, mission statement
  - [ ] Category: Education
  - [ ] Tags/Keywords for discovery
  - [ ] Screenshots plan (which screens, what state to capture)
  - [ ] Feature graphic description
  - [ ] Apple App Store section (subtitle, promotional text, keywords)

### Step 7.3 — Data Safety questionnaire (USER does this)
- [ ] In Play Console: **App content → Data safety**
- [ ] Answer: Does your app collect or share user data? → **No**
- [ ] Complete and save
- [ ] Expected badge: **No data collected**

### Step 7.4 — Content rating (USER does this)
- [ ] In Play Console: **App content → Content rating**
- [ ] Select IARC questionnaire
- [ ] Answer: Violence → None, Sexuality → None, Language → None, Controlled Substances → None
- [ ] Expected rating: **Everyone (PEGI 3)**

### Step 7.5 — Store listing text (USER pastes; AI prepares)
- [ ] AI confirms all text ready in `docs/country_flags/STORE-LISTING.md`
- [ ] In Play Console: **Store presence → Main store listing**
- [ ] USER pastes: App name, short description, full description
- [ ] Set Category: **Education**
- [ ] Add tags from STORE-LISTING.md

### Step 7.6 — Screenshots (AI captures via emulator + adb)
All screenshots taken on clean emulator with no debug banner (`flutter run --profile`).

**Phone screenshots (required — 1080x1920 or 1440x2560):**
- [ ] Screenshot 1: [Main screen — per requirements, TBD]
- [ ] Screenshot 2: [Second key screen — TBD]
- [ ] Screenshot 3: [Third key screen — TBD]
- [ ] Screenshot 4: [Fourth key screen — TBD]
- [ ] Screenshot 5: [About page — mission statement, Support button]
- [ ] Save to `docs/country_flags/screenshots/01_*.png` through `05_*.png`

**7-inch tablet screenshots (required by Play Store):**
- [ ] Same screens as phone, captured on 7" tablet emulator
- [ ] Save to `docs/country_flags/screenshots/tablet_7inch/`

**10-inch tablet screenshots:**
- [ ] Same screens captured on 10" tablet emulator
- [ ] Save to `docs/country_flags/screenshots/tablet_10inch/`

**USER uploads all screenshots to Play Console.**

### Step 7.7 — Feature graphic (AI generates — 1024x500)
- [ ] AI generates `docs/country_flags/store_assets/feature_graphic_1024x500.png`
  - Deep Ocean Blue gradient (brand color from `02-DESIGN-LANGUAGE.md`)
  - App name in bold white, tagline below
  - Key visual: grid of country flags or representative flags
- [ ] USER uploads to Play Console

### Step 7.8 — App icon (AI generates — 512x512)
- [ ] Design icon for Country Flags (globe + flag motif, brand colors)
- [ ] Save as `docs/country_flags/store_assets/icon_512x512.png`
- [ ] Save working copy to `apps/country_flags/assets/icon/icon.png`
- [ ] Run `flutter pub run flutter_launcher_icons` to generate Android/iOS icon sizes
- [ ] USER uploads 512x512 to Play Console

### ✅ Phase 7 Success Condition
Play Console shows no warnings or incomplete sections on the store listing.
All metadata, screenshots, feature graphic, privacy policy, data safety, and content
rating are complete. The app is ready to publish.

---

## Phase 8: Internal Testing & First Release

**Goal:** App is installable from the Play Store internal testing track on a real device and passes full UAT.

### Step 8.1 — Promote to internal testing (USER does this)
- [ ] In Play Console: **Testing → Internal testing**
- [ ] The build from Phase 6 should already be here (uploaded by Codemagic)
  - If not: manually upload the `.aab` from Codemagic build artifacts
- [ ] Click **Promote release** → **Internal testing**
- [ ] Add Google account as tester (Testers tab → add email)
- [ ] Copy the internal testing opt-in link

### Step 8.2 — Install from Play Store (USER does this)
- [ ] On Android phone, open the opt-in link
- [ ] Install "Country Flags" from the Play Store
- [ ] This is a full Play Store install — not a debug build

### Step 8.3 — Full user acceptance test (USER does this)
Test as a real user, with fresh eyes:
- [ ] [Core feature 1 — per requirements, TBD]: verify works correctly
- [ ] [Core feature 2 — per requirements, TBD]: verify works correctly
- [ ] [Core feature 3 — per requirements, TBD]: verify works correctly
- [ ] About page: opens, donation button works, back button returns correctly
- [ ] Dark mode: switch phone to dark mode, all screens look correct
- [ ] Airplane mode: turn on, verify app still works fully
- [ ] TalkBack (optional): navigate the app with screen reader
- [ ] No crashes, no visual issues, no unexpected behavior

### ✅ Phase 8 Success Condition
App is installed from the real Play Store on a real device.
All features work correctly. No crashes. You are satisfied this is ready for real users.

---

## Phase 9: Promote to Production (Android)

**Goal:** App is live on Google Play Store, publicly available to anyone.

### Step 9.1 — Final checklist review (AI reads; USER confirms)
- [ ] AI reads `docs/country_flags/CHECKLIST.md` and checks off everything completed
- [ ] AI reports any unchecked items
- [ ] No unchecked items in Code Quality, Testing, Accessibility, or Visual & UX sections

### Step 9.2 — Promote to open testing (optional — recommended)
- [ ] In Play Console: **Testing → Open testing**
- [ ] Promote the internal testing release to open testing
- [ ] Leave for 1–2 days for a small buffer before full production
- [ ] (Skip and go straight to production if confident from Phase 8)

### Step 9.3 — Promote to production (USER does this)
- [ ] In Play Console: **Production → Releases**
- [ ] Click **Promote release** → **Production**
- [ ] Set rollout to 100%
- [ ] Review: confirm app name, version, description are correct
- [ ] Click **Send changes for review**

### Step 9.4 — Wait for Google review
- [ ] Google typically reviews new apps within 1–3 days
- [ ] Watch Play Console for approval or rejection
- [ ] If rejected: read the rejection reason carefully, fix the issue, resubmit
- [ ] If approved: verify the public listing is visible and accurate

### Step 9.5 — Verify live listing (USER does this)
- [ ] Search "Country Flags" in Google Play — confirm the app appears
- [ ] Install from the public listing on a real device
- [ ] Verify app installs and works correctly from a cold start
- [ ] Confirm the screenshots and store listing look correct in the store UI

### ✅ Phase 9 Success Condition
App is publicly available on Google Play. Store listing is accurate.
App installs and works correctly from the public listing.

---

## Phase 10: Ko-fi / Donation Page

**Goal:** Ko-fi page is set up or updated for Country Flags, and the donation link in the app is correct.

> Note: Ko-fi page at `https://ko-fi.com/foreverfreeapps` already exists (set up for nato_alphabet).
> This phase ensures the About page links to it correctly and the Ko-fi page reflects all apps.

### Step 10.1 — Verify Ko-fi link in app (AI does this)
- [ ] Check `shared_app_core` About page — confirm Ko-fi URL is `https://ko-fi.com/foreverfreeapps`
- [ ] Tap donation link in running app — confirm it opens correctly
- [ ] No changes needed if the existing link is correct

### Step 10.2 — Update Ko-fi profile (USER does this — optional)
- [ ] Consider updating the Ko-fi profile bio to mention Country Flags
- [ ] Consider adding Country Flags to the Ko-fi shop/goals if relevant
- [ ] Not required for launch

### ✅ Phase 10 Success Condition
The Ko-fi donation link in the About page works correctly and points to the right page.

---

## Phase 11: Website Update

**Goal:** The ForeverFree website shows Country Flags with correct links, screenshots, and description.

**Read before starting:** `docs/templates/08-WEBSITE.md`

> Only do this phase after the app is **live on the Play Store** (production, not just internal testing).
> The website should link to real store URLs.

### Step 11.1 — Prepare website assets (AI does this)
- [ ] Copy app icon to `website/apps/country_flags/icon.png`
  - Use the 512x512 store icon
- [ ] Copy the 5 best phone screenshots to `website/apps/country_flags/screenshots/`
  - Rename to `01.png`, `02.png`, `03.png`, `04.png`, `05.png`
  - Use the store screenshots from `docs/country_flags/screenshots/`

### Step 11.2 — Add entry to `website/apps-data.js` (AI does this)
- [ ] Open `website/apps-data.js`
- [ ] Append new object to `APPS_DATA.apps` array:
  ```js
  {
    id: "country_flags",
    name: "Country Flags",
    tagline: "[One-line description — free, offline, ad-free]",
    description: "[First paragraph]\n\n[Second paragraph]\n\n[Third paragraph]",
    androidUrl: "https://play.google.com/store/apps/details?id=com.foreverfree.country_flags",
    iosUrl: null,
    screenshots: [
      { src: "apps/country_flags/screenshots/01.png", w: 1080, h: 2400, alt: "[Description]" },
      { src: "apps/country_flags/screenshots/02.png", w: 1080, h: 2400, alt: "[Description]" },
      { src: "apps/country_flags/screenshots/03.png", w: 1080, h: 2400, alt: "[Description]" },
      { src: "apps/country_flags/screenshots/04.png", w: 1080, h: 2400, alt: "[Description]" },
      { src: "apps/country_flags/screenshots/05.png", w: 1080, h: 2400, alt: "[Description]" }
    ]
  }
  ```

### Step 11.3 — Verify locally (AI does this)
- [ ] Open `website/index.html` in browser
- [ ] Confirm Country Flags card appears
- [ ] Confirm screenshots load and lightbox opens on click
- [ ] Confirm Android badge shows, iOS badge is hidden (iosUrl is null)
- [ ] Confirm layout looks correct on narrow window (mobile simulation)

### Step 11.4 — Deploy (AI does this)
- [ ] `git add website/`
- [ ] `git commit -m "Website: add Country Flags"`
- [ ] `git push`
- [ ] Check GitHub Actions tab — confirm deploy workflow succeeded
- [ ] Verify live site at `https://coziahr.com/foreverfree` shows Country Flags

### Step 11.5 — User confirmation (USER does this)
- [ ] Visit `https://coziahr.com/foreverfree` on desktop — confirm it looks correct
- [ ] Visit on mobile — confirm it looks correct
- [ ] Tap the Play Store badge — confirm it goes to the correct listing
- [ ] Tap a screenshot — confirm lightbox works

### ✅ Phase 11 Success Condition
Country Flags appears on the live website with working store links and screenshots.
User has confirmed it looks correct on both desktop and mobile.

---

## Phase 12: iOS (DEFERRED)

**Goal:** App is live on the Apple App Store.

> **Do NOT start this phase until the user explicitly asks.**
> iOS requires Mac access (borrowed Mac or AWS EC2) and Apple Developer Program membership ($99/year).

**Read before starting:** `docs/templates/05-SIGNING-AND-SECRETS.md` (iOS section)

### Step 12.1 — Prerequisites (USER arranges)
- [ ] Apple Developer Program membership active ($99/year at developer.apple.com)
- [ ] Mac access arranged (borrowed Mac or AWS Mac EC2 instance)
- [ ] Xcode installed on the Mac

### Step 12.2 — iOS signing (USER does on Mac)
- [ ] Generate iOS signing certificate (.p12) in Keychain Access
- [ ] Create App ID in Apple Developer portal: `com.foreverfree.country_flags`
- [ ] Create provisioning profile (App Store distribution) for the App ID
- [ ] Create App Store Connect API key (for automated uploads)

### Step 12.3 — Configure Codemagic for iOS (AI does this)
- [ ] Uncomment and complete the `country-flags-ios` workflow in `codemagic.yaml`
- [ ] Set `bundle_identifier: com.foreverfree.country_flags`
- [ ] Confirm `integrations.app_store_connect: foreverfree_apple` is correct

### Step 12.4 — Add Codemagic iOS credentials (USER does this)
- [ ] In Codemagic: upload .p12 certificate and provisioning profile
  - OR use Codemagic's automatic code signing feature
- [ ] Add to `ios_credentials` environment group if needed

### Step 12.5 — Create app in App Store Connect (USER does this)
- [ ] In App Store Connect: create new app
  - Bundle ID: `com.foreverfree.country_flags`
  - App name: Country Flags (or final name)
  - Primary language: English
  - Platform: iOS

### Step 12.6 — iOS store listing (AI prepares; USER pastes)
- [ ] AI completes Apple App Store section in `docs/country_flags/STORE-LISTING.md`
  - [ ] Subtitle (max 30 chars)
  - [ ] Promotional text (max 170 chars)
  - [ ] Keywords (max 100 chars)
  - [ ] Description (same as Play Store or adapted)
- [ ] AI creates `docs/country_flags/IOS-STORE-LISTING.md` with full App Store details

### Step 12.7 — iOS screenshots (AI captures)
- [ ] Run app on iOS Simulator (requires Mac)
- [ ] Capture screenshots for required sizes:
  - [ ] 6.7" display (iPhone 16 Plus or similar)
  - [ ] 6.1" display (iPhone 16 or similar)
  - [ ] 12.9" iPad Pro (if supporting iPad)
- [ ] Save to `docs/country_flags/screenshots/ios/`
- [ ] USER uploads to App Store Connect

### Step 12.8 — TestFlight (USER does this)
- [ ] Trigger iOS build in Codemagic (or wait for push to main to trigger)
- [ ] Verify build appears in TestFlight
- [ ] Install from TestFlight on physical iPhone
- [ ] Full UAT — same checklist as Android Phase 8

### Step 12.9 — Submit to App Store review (USER does this)
- [ ] In App Store Connect: **Distribute App → App Store Connect**
- [ ] Complete all required metadata (content rating, export compliance, etc.)
- [ ] Submit for review
- [ ] Wait for Apple review (typically 24–48 hours)

### Step 12.10 — Post-iOS website update (AI does this)
- [ ] Update `website/apps-data.js` — set `iosUrl` to real App Store URL
- [ ] Push update — GitHub Actions deploys automatically
- [ ] Verify iOS badge now appears on the website card

### ✅ Phase 12 Success Condition
App is live on the Apple App Store. Website shows both Android and iOS badges.
User has confirmed the app works correctly from a real App Store install.

---

## Phase 13: Final Documentation & Cleanup

**Goal:** All docs are accurate, all checklist items are checked, and the project is clean.

### Step 13.1 — Final checklist (AI does this)
- [ ] Read `docs/country_flags/CHECKLIST.md` — check off every completed item
- [ ] Report any unchecked items to user

### Step 13.2 — Update REQUIREMENTS.md (AI does this)
- [ ] Verify `docs/country_flags/REQUIREMENTS.md` reflects what was actually built
- [ ] Update any user stories that changed during implementation
- [ ] Add any out-of-scope decisions that were made

### Step 13.3 — Update STORE-LISTING.md (AI does this)
- [ ] Verify `docs/country_flags/STORE-LISTING.md` reflects what was actually published
- [ ] Update with final store URLs (Android + iOS when live)

### Step 13.4 — Update template docs (AI does this if needed)
- [ ] Review `docs/templates/` — update any instructions that were wrong or incomplete
- [ ] Add lessons learned from this app's development
- [ ] Update this TODO template with any missing steps discovered

### Step 13.5 — Code cleanup (AI does this)
- [ ] Remove any remaining `TODO` comments from shipping code
- [ ] Final `flutter analyze` — confirm zero errors
- [ ] Final `flutter test` — all pass

### Step 13.6 — Final commit and push (AI does this)
- [ ] Commit any remaining documentation updates
- [ ] Push to GitHub
- [ ] Confirm GitHub Actions (website deploy, etc.) all succeed

### ✅ Phase 13 Success Condition
All checklist items are checked. All docs are accurate.
`flutter analyze` and `flutter test` pass clean. Everything is committed and pushed.

---

## Appendix: Quick Reference

### Commands (run from `apps/country_flags/`)

```bash
# Get dependencies
flutter pub get

# Analyze
flutter analyze

# Run tests
flutter test

# Run integration tests (requires running emulator)
flutter test integration_test/

# Run app in debug mode
flutter run

# Build release AAB (requires key.properties)
flutter build appbundle --release

# Generate app icons (requires flutter_launcher_icons)
flutter pub run flutter_launcher_icons
```

### Key Files

| File | Purpose |
|------|---------|
| `apps/country_flags/pubspec.yaml` | Version, dependencies |
| `apps/country_flags/android/app/build.gradle.kts` | Android build config, signing |
| `apps/country_flags/android/key.properties` | Signing credentials (gitignored, local only) |
| `codemagic.yaml` | CI/CD pipeline (all apps) |
| `docs/country_flags/REQUIREMENTS.md` | Feature spec (approve before building) |
| `docs/country_flags/STORE-LISTING.md` | Store listing text and screenshots plan |
| `docs/country_flags/CHECKLIST.md` | Pre-release checklist |

### Codemagic Env Variables (add to `android_credentials` group)

| Variable | Description |
|----------|-------------|
| `CM_KEYSTORE_COUNTRY_FLAGS` | Base64-encoded keystore |
| `CM_KEYSTORE_PASSWORD_COUNTRY_FLAGS` | Keystore password |
| `CM_KEY_ALIAS_COUNTRY_FLAGS` | `country_flags_key` |
| `CM_KEY_PASSWORD_COUNTRY_FLAGS` | Key password |
| `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` | Already set — reuse from nato_alphabet |

### Package Name
`com.foreverfree.country_flags`
