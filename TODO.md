# NATO Alphabet App — Publishing TODO

> **This file is the single source of truth for all remaining work.**
> Work through phases in order. Do not start a phase until the previous one is complete and verified.
> Each phase ends with a clear success condition. Stop, verify, then continue.

---

## Current Status

- ✅ **Phase 1–5 COMPLETE:** App is built, tested, and approved.
- ✅ **Phase 6 COMPLETE:** Code on GitHub, no secrets committed.
- ✅ **Phase 7 COMPLETE:** Keystore generated, backed up, release build verified.
- 🔄 **Phase 8 IN PROGRESS:** codemagic.yaml created and pushed. Awaiting Codemagic account setup.
- ⬜ Phase 9: Store preparation
- ⬜ Phase 10: First release to internal testing
- ⬜ Phase 11: Promote to production (Android)
- ⬜ Phase 12: Ko-fi page setup (do while waiting for Google review)
- ⬜ Phase 13: Landing page on coziahr.com (do while waiting for Google review)
- ⬜ Phase 14: iOS setup and release (deferred — start after Android is live)
- ⬜ Phase 15: Final documentation & cleanup

---

## Phase 6: Git & GitHub Setup

**Goal:** Code is in a private GitHub repository with no secrets committed. App history is clean.

### Step 6.1 — Pre-flight: Verify no secrets in code (AI does this)
- [x] Run `flutter analyze` in `apps/nato_alphabet/` — confirm zero errors
- [x] Run `flutter test` in `apps/nato_alphabet/` — confirm all tests pass
- [x] Run `flutter test integration_test/` locally in `apps/nato_alphabet/` — confirm passes
- [x] Verify no `.jks`, `key.properties`, or JSON credential files exist anywhere in the project

### Step 6.2 — Create `.gitignore` (AI does this)
- [x] Create `.gitignore` at the repo root with all entries from `docs/templates/05-SIGNING-AND-SECRETS.md`
- [x] Confirm the following are covered:
  - `*.jks` and `*.keystore`
  - `**/key.properties`
  - `*.p12` and `*.mobileprovision`
  - `*-service-account.json`
  - Standard Flutter ignores (`build/`, `.dart_tool/`, `.flutter-plugins`, etc.)
  - IDE files (`.idea/`, `*.iml`)

### Step 6.3 — Initialize git (AI walks user through this)
- [x] Run `git init` in the project root
- [x] Run `git add .`
- [x] Run `git status` — review the file list together to confirm no secrets are staged
- [x] Run `git commit -m "Initial commit: Forever Free NATO Alphabet v1.0.0"`

### Step 6.4 — Create GitHub repository (USER does this, with AI guidance)
- [x] Go to https://github.com/new
- [x] Repository name: `forever-free-apps` (this is the monorepo for all apps)
- [x] Visibility: **Private** (very important — keeps keystore setup safe)
- [x] Do NOT check "Initialize with README" — we already have files
- [x] Do NOT add .gitignore or license — we have our own
- [x] Click "Create repository"
- [x] Copy the repository URL (format: `https://github.com/YOUR_USERNAME/forever-free-apps.git`)

### Step 6.5 — Connect local repo to GitHub (AI provides commands, user runs them)
- [x] `git remote add origin https://github.com/YOUR_USERNAME/forever-free-apps.git`
- [x] `git branch -M main`
- [x] `git push -u origin main`
- [x] Verify: visit the GitHub URL in browser — all files should be visible

### ✅ Phase 6 Success Condition
All code is on GitHub. No `.jks`, `key.properties`, or credential files appear in the repo.
The `docs/`, `apps/`, `packages/` directories all show up correctly on GitHub.

---

## Phase 7: Android Signing

**Goal:** A signing keystore exists, is backed up, and the app can be built in release mode locally.

> ⚠️ **THE KEYSTORE IS IRREPLACEABLE.** If lost, you can never update the app on the
> Play Store. Back it up to multiple locations BEFORE doing anything else.

### Step 7.1 — Generate the keystore (USER does this, with AI guidance)
- [x] Open Android Studio Terminal (or Windows PowerShell)
- [x] Run the keytool command from `docs/templates/05-SIGNING-AND-SECRETS.md` (AI provides exact command)
- [x] When prompted, enter a strong password (same for keystore and key is fine)
- [x] When prompted for name/org/location, use real information
- [x] Note the exact path where `nato_alphabet.jks` was created — `C:\Users\tcozi\Dropbox\private\androidkeys\nato_alphabet.jks`

### Step 7.2 — Back up the keystore immediately (USER does this)
- [x] Copy `nato_alphabet.jks` to at least TWO of these locations:
  - [x] Dropbox (`C:\Users\tcozi\Dropbox\private\androidkeys\`) ✅
  - [ ] USB drive stored somewhere safe
  - [x] Password manager vault (1Password, Bitwarden, etc.) ✅
- [x] Save the keystore password in your password manager
- [x] Confirm backups exist before continuing

### Step 7.3 — Create `key.properties` (AI does this, with user's path/password)
- [x] User provides: full path to `nato_alphabet.jks` and their chosen password
- [x] AI creates `apps/nato_alphabet/android/key.properties` with correct values
- [x] Verify `key.properties` is listed in `.gitignore` (it must NEVER be committed)
- [x] Run `git status` — confirm `key.properties` does NOT appear as a tracked file

### Step 7.4 — Update `build.gradle` for release signing (AI does this)
- [x] AI updates `apps/nato_alphabet/android/app/build.gradle.kts` with signing config (Kotlin DSL — file uses .kts not .gradle)

### Step 7.5 — Verify release build works locally (AI runs this)
- [x] Run `flutter build appbundle --release` in `apps/nato_alphabet/`
- [x] Confirm: build succeeds with no errors
- [x] Confirm: `build/app/outputs/bundle/release/app-release.aab` exists
- [x] Check AAB size: 39.4MB (under 150MB Play Store limit; note: larger than 25MB estimate in TODO — app includes Google Fonts)

### ✅ Phase 7 Success Condition
`flutter build appbundle --release` succeeds locally. The `.aab` file exists.
Keystore is backed up. `key.properties` is NOT in git.

---

## Phase 8: CI/CD Pipeline (Codemagic)

**Goal:** Every push to `main` automatically runs tests, builds the app, and uploads it to the Google Play internal testing track.

### Step 8.1 — Create `codemagic.yaml` (AI does this)
- [x] AI creates `codemagic.yaml` at the repo root based on `docs/templates/04-CI-CD.md`
- [x] Verify path triggers cover `apps/nato_alphabet/**` and `packages/shared_app_core/**`
- [x] Verify pipeline stages: analyze → unit/widget tests → build AAB → publish to internal track
- [x] Commit and push `codemagic.yaml` to GitHub

### Step 8.2 — Set up Codemagic account (USER does this, with AI guidance)
- [ ] Go to https://codemagic.io and sign in with GitHub
- [ ] Click "Add application"
- [ ] Select the `forever-free-apps` repository
- [ ] Choose "Flutter App" as project type
- [ ] Choose "codemagic.yaml" (not the workflow editor)
- [ ] Codemagic should detect the `nato-alphabet-android` workflow automatically

### Step 8.3 — Google Play Developer account (USER does this — one-time setup)
- [x] Go to https://play.google.com/console/
- [x] Pay the one-time **$25** registration fee (if not already done)
- [x] Complete identity verification (may take 1-2 days) — **submitted, awaiting verification**
- [ ] Confirm account is active before continuing

### Step 8.4 — Google Cloud service account for automated publishing (USER does this, with AI guidance)
- [ ] Go to **Google Play Console → Setup → API access**
- [ ] Link a Google Cloud project (or create a new one — name it `forever-free-publisher`)
- [ ] Click **Create new service account** → follow the link to Google Cloud Console
- [ ] Create service account:
  - Name: `codemagic-publisher`
  - Role: leave blank (permissions set in Play Console)
- [ ] In Google Cloud: Create a JSON key for this service account → download it
- [ ] Back in Play Console → Setup → API access: find the new service account → click **Manage permissions**
- [ ] Grant permissions: **Releases** → "Manage production and testing track releases"
- [ ] Grant permissions: **App information** → "Edit and manage"
- [ ] Apply to **All apps** (so future apps work too)

### Step 8.5 — Base64-encode keystore for Codemagic (AI does this)
- [x] AI runs PowerShell to base64-encode `nato_alphabet.jks` and outputs the result
- [x] Encoded string saved to `C:\Users\tcozi\Dropbox\private\androidkeys\nato_alphabet_base64.txt`
- [x] Treat the encoded string like the keystore — don't share it publicly

### Step 8.6 — Add environment variables to Codemagic (USER does this — requires Codemagic account)
- [x] In Codemagic: **Teams → Environment variables → Add group** named `android_credentials`
- [x] Add and mark each as **Secure** (so they never appear in build logs):
  - [x] `CM_KEYSTORE` = base64 string from Step 8.5
  - [x] `CM_KEYSTORE_PASSWORD` = `Vc*rU2qtWervX7ZU`
  - [x] `CM_KEY_ALIAS` = `nato_alphabet_key`
  - [x] `CM_KEY_PASSWORD` = `Vc*rU2qtWervX7ZU`
  - [ ] `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` = entire contents of the JSON key file downloaded in Step 8.4 — **waiting on Play Console access**
- [ ] Verify all 5 variables are in the `android_credentials` group

### Step 8.7 — Create app in Google Play Console (USER does this — requires Play Console access)
This step is needed before the CI pipeline can publish (Play API needs an app to exist first).
- [ ] In Play Console: click **Create app**
- [ ] App name: `NATO Alphabet Trainer`
- [ ] Default language: English (United States)
- [ ] App or Game: **App**
- [ ] Free or Paid: **Free**
- [ ] Accept declarations → click **Create app**
- [ ] Note the package name shown — it must match `applicationId` in `build.gradle`

### Step 8.8 — Trigger first CI build (AI pushes trigger commit)
- [ ] AI pushes a small change to `main` to trigger Codemagic
- [ ] USER watches the build in the Codemagic dashboard
- [ ] Verify each stage passes: Analyze ✅ → Tests ✅ → Build ✅ → Publish ✅
- [ ] Confirm the build artifact (`.aab`) is downloadable from Codemagic

### ✅ Phase 8 Success Condition
A push to `main` triggers a full build in Codemagic that passes all stages and uploads
the AAB to the Google Play internal testing track without errors.

---

## Phase 9: Store Preparation

**Goal:** The Play Store listing is complete, polished, and ready for users to see.

### Step 9.1 — Privacy policy (AI writes and commits; USER enables GitHub Pages)
- [x] AI generates privacy policy as `privacy/index.html` in the repo and pushes it
- [ ] USER enables GitHub Pages: repo Settings → Pages → deploy from `main` branch, root `/` folder
- [ ] Confirm the privacy policy URL is publicly accessible (e.g. `https://tobin00.github.io/forever-free-apps/privacy/`)

### Step 9.2 — Data Safety questionnaire (USER does this — requires Play Console access)
- [ ] In Play Console: **App content → Data safety**
- [ ] Answer: Does your app collect or share user data? → **No**
- [ ] Complete and save
- [ ] Expected badge: **No data collected**

### Step 9.3 — Content rating (USER does this — requires Play Console access)
- [ ] In Play Console: **App content → Content rating**
- [ ] Select IARC questionnaire
- [ ] Answer: Violence → None, Sexuality → None, Language → None, Controlled Substances → None
- [ ] Expected rating: **Everyone (PEGI 3)**

### Step 9.4 — Store listing text (USER pastes from AI-prepared file)
- [ ] AI confirms all text is ready in `docs/nato_alphabet/STORE-LISTING.md`
- [ ] In Play Console: **Store presence → Main store listing**
- [ ] USER pastes: App name, short description, full description from STORE-LISTING.md
- [ ] Set Category: **Education**
- [ ] Add tags: nato, phonetic, alphabet, flashcard, quiz, free, offline

### Step 9.5 — Screenshots (AI captured via emulator + adb)
- [x] AI ran app on Android emulator in profile mode (no debug banner)
- [x] Screenshot 1: Reference screen — A through H visible
- [x] Screenshot 2: Letter Quiz — "E" shown, Reveal + Next buttons visible
- [x] Screenshot 3: Letter Quiz — "Echo" revealed, Reveal button grayed out
- [x] Screenshot 4: Word Quiz — "GRAND", Show Me + Next buttons visible
- [x] Screenshot 5: Word Quiz revealed — G/R/A/N/D spelled out with NATO names
- [x] Screenshot 6: About page — mission statement, Support button
- [ ] USER uploads screenshots from `docs/nato_alphabet/screenshots/` to Play Console

### Step 9.6 — Feature graphic (USER creates — requires design tool)
- [ ] Create a 1024x500 image per spec in `docs/nato_alphabet/STORE-LISTING.md`:
  - Deep Ocean Blue (#1B5E7B) gradient background
  - App name "NATO Alphabet Trainer" in Nunito Bold, white
  - Faded alphabet letters (A — Alpha, B — Bravo, etc.) in background
  - Warm Amber (#F4A726) accent line or detail
- [ ] Suggested tools: Canva (free), Figma (free), or Adobe Express
- [ ] Upload to Play Console

### Step 9.7 — App icon (AI runs, USER verifies in Play Console)
- [x] AI confirmed `assets/icon/icon.png` exists
- [x] AI ran `dart run flutter_launcher_icons` — icons already generated and committed
- [ ] USER verifies icon looks correct when uploaded to Play Console

### ✅ Phase 9 Success Condition
Play Console shows no warnings or incomplete sections on the store listing.
All metadata, screenshots, feature graphic, privacy policy, data safety, and content
rating are complete. The app is ready to publish.

---

## Phase 10: First Release — Internal Testing

**Goal:** The app is installable from the Play Store internal testing track on a real device. You verify it works exactly as expected before releasing to anyone else.

### Step 10.1 — Promote the build to internal testing (USER does this)
- [ ] In Play Console: **Testing → Internal testing**
- [ ] The build from Phase 8 should already be here (uploaded by Codemagic)
- [ ] If not: manually upload the `.aab` from Codemagic's build artifacts
- [ ] Click **Promote release** → **Internal testing**
- [ ] Add your Google account as a tester (Testers tab → add email)
- [ ] Copy the internal testing opt-in link

### Step 10.2 — Install from the Play Store on a real device (USER does this)
- [ ] On your Android phone, open the opt-in link
- [ ] Install "NATO Alphabet Trainer" from the Play Store
- [ ] This is a full Play Store install — not a debug build — this is what users get

### Step 10.3 — Full user acceptance test (USER does this)
Test exactly as a real user would, with fresh eyes:
- [ ] Reference screen: all 26 NATO entries show correctly (A=Alpha through Z=Zulu)
- [ ] Letter Quiz: all 26 letters cycle, Reveal and Next always visible, progress indicator works
- [ ] Letter Quiz: "Done!" state appears after all 26, "Go Again" restarts cleanly
- [ ] Word Quiz: words display correctly, Show Me reveals each letter, Next gives a new word
- [ ] Word Quiz: no word repeats within a reasonable session
- [ ] About page: opens from info icon, donation button works, back button returns correctly
- [ ] Dark mode: switch phone to dark mode, verify all screens look correct
- [ ] Airplane mode: turn on airplane mode, verify app still works fully
- [ ] TalkBack (optional but recommended): enable Android TalkBack, navigate the app

### ✅ Phase 10 Success Condition
App is installed from the real Play Store on a real device. All features work correctly.
No crashes. No visual issues. You are satisfied that this is ready for real users.

---

## Phase 11: Promote to Production (Android)

**Goal:** The app is live on the Google Play Store, publicly available to anyone.

### Step 11.1 — Final checklist review (AI reads and reports; USER confirms)
- [ ] AI reads `docs/nato_alphabet/CHECKLIST.md` and checks off everything completed
- [ ] AI reports any unchecked items for USER to investigate
- [ ] No unchecked items in Code Quality, Testing, Accessibility, or Visual & UX sections

### Step 11.2 — Promote to open testing (optional — recommended for first-time)
- [ ] In Play Console: **Testing → Open testing**
- [ ] Promote the internal testing release to open testing
- [ ] Leave it here for 1-2 days if you want a small buffer before full production
- [ ] (Skip this and go straight to production if you're confident from Phase 10)

### Step 11.3 — Promote to production (USER does this)
- [ ] In Play Console: **Production → Releases**
- [ ] Click **Promote release** → **Production**
- [ ] Set rollout to 100% (this is a new app, no existing users to protect)
- [ ] Review the release summary — confirm app name, version, and description are correct
- [ ] Click **Send changes for review**

### Step 11.4 — Wait for Google review
- [ ] Google typically reviews new apps within **1–3 days** (sometimes faster)
- [ ] You'll receive an email when approved or if there are issues
- [ ] Check Play Console for review status
- [ ] **While waiting: work through Phases 12 and 13 (Ko-fi + landing page)**

### Step 11.5 — Verify it's live (USER does this)
- [ ] Search "NATO Alphabet Trainer" on Google Play from a phone (not signed in as developer)
- [ ] Install from the public listing
- [ ] Verify everything looks correct in the store: title, description, screenshots, rating
- [ ] Test the installed app one more time

### ✅ Phase 11 Success Condition
"NATO Alphabet Trainer" is publicly available on the Google Play Store. Anyone with
an Android phone can find and install it. You have verified this with a public install.

---

## Phase 12: Ko-fi Page Setup

**Goal:** Forever Free Apps has a polished Ko-fi presence where supporters can donate, and the
donation button in every app links directly to it.

> **When to do this:** While waiting for Google's review in Step 11.4. Takes about 30–60 minutes.

### Step 12.1 — Create Ko-fi account (USER does this — requires their identity/payment info)
- [ ] Go to https://ko-fi.com and sign up
- [ ] Choose a handle — suggestion: `foreverFreeApps` or `foreverfreeapps`
- [ ] Connect a payment method (PayPal or Stripe) for receiving donations
- [ ] Note your Ko-fi page URL (e.g. `https://ko-fi.com/foreverFreeApps`)

### Step 12.2 — Write Ko-fi page content (AI does this)
- [ ] AI writes: page title, tagline, "About" bio for Forever Free Apps
- [ ] AI writes: goal description (e.g. "Keep the apps free and ad-free forever")
- [ ] AI writes: individual app descriptions for the Ko-fi page
- [ ] All text will be provided ready to paste

### Step 12.3 — Fill out Ko-fi profile (USER pastes AI content, uploads images)
- [ ] Paste bio and about text from Step 12.2
- [ ] Profile photo: use the app icon or a simple Forever Free logo
- [ ] Cover image: AI will describe the recommended spec (1200x400px); USER creates or sources image
- [ ] Set a donation goal amount (suggestion: $50/month to cover hosting + dev tools)

### Step 12.4 — Update donation button URL in the app (AI does this)
- [ ] AI finds the donation button URL in the NATO Alphabet app source code
- [ ] AI updates it to point to the new Ko-fi page URL
- [ ] AI commits and pushes — Codemagic will auto-build the updated app

### ✅ Phase 12 Success Condition
Ko-fi page is live and public. The donation button inside the app opens the Ko-fi page correctly.
The page looks professional and clearly explains the Forever Free mission.

---

## Phase 13: Landing Page on coziahr.com

**Goal:** A public-facing website at coziahr.com (or a subdomain) that showcases all Forever Free
apps, provides download links, explains the mission, and lets visitors donate or contact you.
The page auto-updates whenever a new app ships.

> **When to do this:** While waiting for Google's review in Step 11.4, in parallel with Phase 12.

### Step 13.1 — Discover hosting setup (USER answers, AI plans)
- [ ] USER answers: How is coziahr.com currently hosted? (WordPress, Squarespace, GitHub Pages,
  raw cPanel/FTP, Cloudflare Pages, Netlify, other?)
- [ ] USER answers: Do you want the Forever Free section at `coziahr.com/apps`, a subdomain
  like `apps.coziahr.com`, or a full page takeover?
- [ ] AI reviews answers and recommends the build approach (static HTML, or CMS integration)

### Step 13.2 — Design and content plan (AI does this)
- [ ] AI drafts the full page structure:
  - Hero section: "Forever Free Apps" — mission statement, tagline
  - App grid: one card per app (icon, name, description, Play Store link, App Store link)
  - About section: who makes these apps and why
  - Donate section: Ko-fi embed or link
  - Contact section: email form or mailto link
- [ ] AI writes all copy for every section
- [ ] AI specifies color palette and font choices consistent with the app brand

### Step 13.3 — Build the landing page (AI does this)
- [ ] AI builds the page as static HTML/CSS (works with any host)
  - OR integrates with whatever CMS coziahr.com uses (determined in Step 13.1)
- [ ] Mobile-responsive layout
- [ ] Play Store badge for NATO Alphabet (and placeholders for future apps)
- [ ] Ko-fi donate button embedded
- [ ] Contact form (using Formspree or mailto — no server required)

### Step 13.4 — Auto-update when a new app ships (AI does this)
- [ ] AI creates a GitHub Actions workflow that:
  - Triggers on a new GitHub Release tag (e.g. `v1.0.0-word-game`)
  - Reads app metadata from a config file in the repo (`apps/APP_NAME/metadata.yaml`)
  - Regenerates the app grid on the landing page with the new app included
  - Deploys the updated page to the host automatically
- [ ] AI creates `apps/nato_alphabet/metadata.yaml` as the first example
- [ ] Adding a new app in the future = add its `metadata.yaml`, tag a release, site updates itself

### Step 13.5 — Deploy and verify (USER deploys, AI verifies content)
- [ ] USER uploads or deploys the built page to coziahr.com (exact steps depend on host)
- [ ] AI checks: all links work, Play Store badge links to correct app, Ko-fi link works
- [ ] USER confirms it looks correct on mobile and desktop

### ✅ Phase 13 Success Condition
`coziahr.com` (or subdomain) shows a live, polished Forever Free Apps landing page.
Play Store download link works. Ko-fi donate button works. Contact option works.
A future app can be added by dropping in a `metadata.yaml` and tagging a release.

---

## Phase 14: iOS Setup and Release (Deferred)

**Start this phase ONLY after Android is successfully live and you are ready.**

> iOS requires a Mac (or Mac cloud instance) for building and submitting.
> It also requires an Apple Developer account ($99/year).

### Step 14.1 — Prerequisites (USER arranges)
- [ ] Apple Developer Program enrollment: https://developer.apple.com/programs/
  - $99/year fee
  - Identity verification required (may take a few days)
- [ ] Access to a Mac: borrow one, or use a cloud Mac service (e.g., MacStadium, AWS EC2 Mac)
- [ ] Xcode installed on the Mac (free from Mac App Store)

### Step 14.2 — iOS Flutter configuration (AI does this)
- [ ] Update `pubspec.yaml`: set `ios: true` in `flutter_launcher_icons`
- [ ] Update `codemagic.yaml`: uncomment and configure the iOS workflow
- [ ] Set minimum iOS deployment target in `ios/Podfile` and Xcode project: **iOS 13.0**
- [ ] Verify no Android-specific code exists that would break iOS

### Step 14.3 — iOS signing setup (USER does this on a Mac, with AI guidance)
- [ ] Create App ID in Apple Developer portal
- [ ] Create Distribution Certificate in Keychain Access on Mac
- [ ] Create App Store Provisioning Profile
- [ ] Upload `.p12` certificate and provisioning profile to Codemagic
  - OR use Codemagic's automatic code signing (simpler, recommended)

### Step 14.4 — Create app in App Store Connect (USER does this)
- [ ] Go to https://appstoreconnect.apple.com
- [ ] Create a new App with bundle ID matching `android/app/build.gradle` applicationId
- [ ] Fill in App Store listing (use `docs/nato_alphabet/STORE-LISTING.md` — Apple section)
- [ ] Complete Privacy Nutrition Labels (same answers as Play Store data safety)

### Step 14.5 — iOS screenshots (USER captures)
Apple requires multiple screenshot sizes:
- [ ] iPhone 6.7" (1290x2796 or 1320x2868)
- [ ] iPhone 6.5" (1242x2688) — required if supporting older devices
- [ ] iPad 12.9" (2048x2732) — required if app supports iPad
- [ ] Use the same clean emulator approach as Android

### Step 14.6 — First iOS build and TestFlight (AI triggers, USER tests)
- [ ] Push to `main` with iOS workflow active
- [ ] Codemagic builds `.ipa` and uploads to TestFlight
- [ ] Install from TestFlight on your iPad for testing
- [ ] Verify all screens, both light/dark mode, accessibility

### Step 14.7 — Submit for App Store review (USER does this)
- [ ] In App Store Connect: select the TestFlight build for production
- [ ] Submit for review
- [ ] Apple review typically takes **1–3 days** for new apps
- [ ] Respond promptly if Apple requests changes

### ✅ Phase 14 Success Condition
App is live on the Apple App Store. Anyone with an iPhone or iPad can find and install
"Forever Free: NATO Alphabet." Verified with a public install.

---

## Phase 15: Final Documentation & Cleanup

**Goal:** Templates are updated, documentation is complete, and the project is ready for the next app.

### Step 15.1 — Complete the checklist (AI + USER)
- [ ] Go through every item in `docs/nato_alphabet/CHECKLIST.md`
- [ ] Check off all remaining items (CI/CD, store readiness, post-launch)
- [ ] Note any items that don't apply or needed adjustment for future reference

### Step 15.2 — Verify templates are current (AI does this)
- [ ] Confirm all changes made during this project are reflected in `docs/templates/`
- [ ] The templates were updated in Phase 5 (document audit) — verify nothing was missed
- [ ] Add any new lessons learned from Phases 6–14

### Step 15.3 — Update project memory (AI does this)
- [ ] Update `memory/MEMORY.md`:
  - Current Phase: Complete
  - App status: Live on Google Play (and App Store if Phase 14 done)
  - Next Steps: Ready for next app idea

### Step 15.4 — Celebrate 🎉 (USER does this)
- [ ] The first app is live. The pipeline works. The next app will be much faster.

### ✅ Phase 15 Success Condition
All documentation is accurate and complete. The project is in a clean state.
Templates reflect everything learned from the first app.

---

## Quick Reference: Who Does What

| Task | Who |
|------|-----|
| Run tests, verify code, write config files | **AI** |
| Run git commands, commit, push | **AI** |
| Base64-encode keystore for Codemagic | **AI** |
| Write and commit privacy policy | **AI** |
| Run `flutter_launcher_icons` | **AI** |
| Read and check off checklist | **AI** |
| Generate keystore (`keytool` — interactive prompts) | **User** (interactive password entry) |
| Back up keystore to USB | **User** (physical storage) |
| Create GitHub repository | **User** (requires GitHub account) |
| Create Codemagic account and connect repo | **User** (requires web signup + GitHub OAuth) |
| Enter environment variables in Codemagic UI | **User** (contains secrets, requires their account) |
| Create Google Play Developer account | **User** (requires $25 + identity verification) |
| Create Google Cloud service account | **User** (requires their Google account) |
| Create app in Play Console | **User** (requires Play Console access) |
| Enable GitHub Pages | **User** (one toggle in GitHub Settings) |
| Complete store questionnaires (data safety, rating) | **User** (requires Play Console access) |
| Take screenshots | **User** (requires running app + phone/emulator) |
| Create feature graphic | **User** (design tool, creative judgment) |
| Promote builds to production | **User** (requires Play Console access) |
| Install and QA test on real device | **User** (requires physical Android phone) |
| Write Ko-fi page copy and app descriptions | **AI** |
| Update donation button URL in app code | **AI** |
| Write all landing page copy and build HTML/CSS | **AI** |
| Build GitHub Actions auto-update workflow for landing page | **AI** |
| Create Ko-fi account and connect payment | **User** (their identity + payment account) |
| Upload images to Ko-fi (profile photo, cover) | **User** (design + their account) |
| Deploy landing page to coziahr.com | **User** (requires domain/hosting access) |
| Create Ko-fi cover image (1200x400px) | **User** (design tool) |
| Apple Developer account + signing | **User** (requires $99/year + Mac) |

---

## Notes on Secrets Safety

**Never commit these files to git:**
- `*.jks` — Android keystore
- `**/key.properties` — keystore path + password
- `*-service-account.json` — Google Cloud credentials
- Any file containing passwords or API keys

**Safe to commit:**
- `codemagic.yaml` — references environment variables by name, no actual values
- `android/app/build.gradle` — reads from `key.properties`, no hardcoded values
- All Dart source files — no credentials

**If you accidentally commit a secret:**
1. Do NOT just delete it in the next commit — git history retains it
2. Use `git filter-branch` or BFG Repo Cleaner to rewrite history
3. Rotate the credential immediately (generate new keystore or service account key)
4. Force-push the cleaned history

---

*Last updated: 2026-03-31*
*App version at time of writing: 1.0.0*
