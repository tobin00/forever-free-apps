# NATO Alphabet App — Publishing TODO

> **This file is the single source of truth for all remaining work.**
> Work through phases in order. Do not start a phase until the previous one is complete and verified.
> Each phase ends with a clear success condition. Stop, verify, then continue.

---

## Current Status

- ✅ **Phase 1–5 COMPLETE:** App is built, tested, and approved.
- ✅ **Phase 6 COMPLETE:** Code on GitHub (public repo), no secrets committed.
- ✅ **Phase 7 COMPLETE:** Keystore generated, backed up, release build verified.
- 🔄 **Phase 8 IN PROGRESS:** All 5 env vars in Codemagic. App created in Play Console ("NATO Phonetic Alphabet Trainer"). Service account created in Google Cloud, invited in Play Console with testing + production release permissions. Version bumped to 1.1.0+2, push triggered Codemagic build — awaiting build pass + Play Console upload confirmation.
- ✅ **Phase 9 COMPLETE:** Store listing complete. All screenshots (phone, 7", 10"), feature graphic, icon uploaded. Privacy policy live. Data safety and content rating filled in.
- ⬜ Phase 10: First release to internal testing
- ⬜ Phase 11: Promote to production (Android)
- ✅ **Phase 12 COMPLETE:** Ko-fi page live at https://ko-fi.com/foreverfreeapps. Profile photo, cover image, and bio all uploaded. Donation URL live in app.
- ✅ **Phase 13 COMPLETE:** Website live at https://coziahr.com/foreverfree. Auto-deploys via GitHub Actions on push.
- 🔄 **Phase 14 IN PROGRESS:** iOS plan complete. Waiting on Apple Developer enrollment. See Phase 14 for full step-by-step plan.
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
- [x] Go to https://codemagic.io and sign in with GitHub
- [x] Click "Add application"
- [x] Select the `forever-free-apps` repository
- [x] Choose "Flutter App" as project type
- [x] Choose "codemagic.yaml" (not the workflow editor)
- [x] Codemagic detected the `nato-alphabet-android` workflow automatically — no validation errors

### Step 8.3 — Google Play Developer account (USER does this — one-time setup)
- [x] Go to https://play.google.com/console/
- [x] Pay the one-time **$25** registration fee (if not already done)
- [x] Complete identity verification (may take 1-2 days) — **verified ✅**
- [x] Confirm account is active before continuing

### Step 8.4 — Google Cloud service account for automated publishing (USER does this, with AI guidance)
- [x] Create Google Cloud project: `forever-free-publisher`
- [x] Enable Google Play Android Developer API
- [x] Create service account: `codemagic-publisher` (role left blank)
- [x] Download JSON key for the service account
- [x] In Play Console → Users and permissions → Invite service account email
- [x] Grant: Manage testing track releases
- [x] Grant: Manage production releases

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
  - [x] `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` = entire contents of the JSON key file downloaded in Step 8.4
- [x] Verify all 5 variables are in the `android_credentials` group

### Step 8.7 — Create app in Google Play Console (USER does this — requires Play Console access)
This step is needed before the CI pipeline can publish (Play API needs an app to exist first).
- [x] In Play Console: click **Create app**
- [x] App name: `NATO Phonetic Alphabet Trainer`
- [x] Default language: English (United States)
- [x] App or Game: **App**
- [x] Free or Paid: **Free**
- [x] Accept declarations → click **Create app**
- [ ] Note the package name shown — it must match `applicationId` in `build.gradle`

### Step 8.8 — Trigger first CI build (AI pushes trigger commit)
- [x] AI bumped version to `1.1.0+2` and pushed to `main` to trigger Codemagic (2026-04-04)
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
- [x] AI generates privacy policy as `privacy/index.html` in the repo and pushes it (contact: makeitforeverfree@gmail.com)
- [x] USER enabled GitHub Pages: repo made public, Settings → Pages → deploy from `main` branch, root `/` folder
- [ ] Confirm the privacy policy URL is publicly accessible: `https://tobin00.github.io/forever-free-apps/privacy/` (may take a few minutes to propagate after enabling)

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
- [x] USER uploads screenshots from `docs/nato_alphabet/screenshots/` to Play Console

### Step 9.6 — Feature graphic (AI generated)
- [x] AI generated `docs/nato_alphabet/store_assets/feature_graphic_1024x500.png`
  - Deep Ocean Blue gradient, left-to-right dot fade (matching Ko-fi banner style)
  - "NATO Phonetic Alphabet Trainer" in bold white, amber underline + tagline
  - 4x4 colorful rounded letter tiles (A–P) on the right
- [x] Upload to Play Console

### Step 9.7 — App icon (AI generated 512x512)
- [x] AI resized `assets/icon/icon.png` → `store_assets/icon_512x512.png`
- [x] USER uploaded to Play Console

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
- [x] Ko-fi account created at https://ko-fi.com/foreverfreeapps
- [ ] Connect a payment method (PayPal or Stripe) for receiving donations — do this when ready to accept donations

### Step 12.2 — Write Ko-fi page content (AI does this)
- [x] AI wrote: page title ("Forever Free Apps"), tagline ("Apps that are always free — no ads, no catch, ever.")
- [x] AI wrote: "About" bio for Forever Free Apps (provided in chat session)
- [x] AI wrote: individual app description for NATO Alphabet Trainer
- [x] All text was provided ready to paste

### Step 12.3 — Fill out Ko-fi profile (USER pastes AI content, uploads images)
- [x] USER pasted bio and about text into Ko-fi profile
- [x] Profile photo generated by AI: `docs/nato_alphabet/kofi_assets/kofi_profile_800x800.png`
  - Deep Ocean Blue gradient, white infinity symbol, amber $0 price tag, "FOREVER FREE APPS" label
- [x] Cover image generated by AI: `docs/nato_alphabet/kofi_assets/kofi_banner_1200x400.png`
  - Nunito Bold font, blue gradient, colorful tile grid (no letters), "Free apps built with care." tagline
- [x] USER uploaded profile photo and cover image to Ko-fi
- [x] No donation goal set — Ko-fi page works great without one

### Step 12.4 — Update donation button URL in the app (AI does this)
- [x] AI updated `packages/shared_app_core/lib/constants/brand.dart`
- [x] `donationUrl` changed from placeholder to `https://ko-fi.com/foreverfreeapps`
- [x] Committed and pushed to GitHub

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

## Phase 14: iOS Setup and Release

**Start this phase ONLY after Android is successfully live and you are ready.**

---

### iOS vs. Android: Key Differences (READ FIRST)

| Topic | Android | iOS |
|-------|---------|-----|
| Developer fee | $25 one-time | $99/year |
| Beta tester requirement before production | **12 testers for 14 days** | **None — can skip straight to production** |
| CI/CD signing | Keystore file + key.properties | App Store Connect API key (3 env vars) |
| Need a physical Mac? | No | **No** — Codemagic handles all signing via API |
| AWS EC2 Mac (if needed) | N/A | 24-hour minimum billing, $15.60+ minimum, no Xcode pre-installed |
| Bundle ID format | `com.foreverfree.nato_alphabet` (underscores OK) | `com.foreverfree.natoalphabet` (no underscores allowed) |
| Screenshot requirement | Phone + 7" + 10" | iPhone 6.9" required; iPad 13" required if iPad supported |
| Age rating | Self-reported (PEGI 3 for this app) | Self-reported (4+ for this app) |
| Review time | 1–3 days | 24–72 hours |

> **Good news:** You do NOT need a Mac to build and ship the iOS app.
> Codemagic's Mac build machines handle everything. A Mac is only needed
> for interactive debugging or running the iOS Simulator — both of which
> are optional until you hit a problem.

---

### Step 14.1 — Apple Developer Program Enrollment (USER does this — one-time)

> ⚠️ This step has a variable wait time. Start it as early as possible — it can take up to 4 weeks.

- [ ] Go to https://developer.apple.com/programs/enroll/
- [ ] Sign in with your Apple ID (create one if needed)
- [ ] Choose: **Individual** (not Organization — much faster, no D-U-N-S number needed)
- [ ] Provide legal name, address, phone number
- [ ] Complete identity verification (takes 1–4 business days)
- [ ] Pay **$99 USD/year** enrollment fee
- [ ] Wait for approval email (typically 24–72 hours after payment)
- [ ] Once approved, confirm access to: https://developer.apple.com — you should see "Certificates, Identifiers & Profiles"
- [ ] Also confirm access to: https://appstoreconnect.apple.com

### Step 14.2 — Add iOS Platform to the Flutter Project (AI does this)

The project was built without an `ios/` directory. This step generates it.

- [ ] AI runs `flutter create --platforms=ios .` in `apps/nato_alphabet/`
- [ ] Verify `ios/` directory was created with expected structure:
  - `ios/Runner/`, `ios/Runner.xcodeproj/`, `ios/Podfile`, `ios/Runner/Info.plist`
- [ ] AI commits and pushes the new `ios/` directory to GitHub
- [ ] Note: The bundle ID generated will be `com.foreverfree.nato_alphabet` — we must fix this in the next step (iOS does not allow underscores in bundle IDs)

### Step 14.3 — Configure iOS Bundle ID and Minimum Deployment Target (AI does this)

> The iOS bundle ID must not contain underscores. We use `com.foreverfree.natoalphabet`.

- [ ] AI updates `ios/Runner.xcodeproj/project.pbxproj`: replace all occurrences of `com.foreverfree.nato_alphabet` with `com.foreverfree.natoalphabet`
- [ ] AI updates `ios/Runner/Info.plist`: verify `CFBundleIdentifier` is `$(PRODUCT_BUNDLE_IDENTIFIER)` (uses Xcode variable — should be fine by default)
- [ ] AI updates `ios/Podfile`: set minimum deployment target to `platform :ios, '13.0'`
- [ ] AI updates `pubspec.yaml`: change `ios: false` to `ios: true` in `flutter_launcher_icons` section
- [ ] AI runs `dart run flutter_launcher_icons` to generate iOS app icons
- [ ] AI commits all changes and pushes to GitHub

### Step 14.4 — Create App ID in Apple Developer Portal (USER does this)

> This creates the official "slot" that Apple uses to identify your app.

- [ ] Go to https://developer.apple.com/account/resources/identifiers/list
- [ ] Click the **"+"** button → select **App IDs** → select **App** type
- [ ] Description: `NATO Phonetic Alphabet Trainer`
- [ ] Bundle ID: choose **Explicit** → enter: `com.foreverfree.natoalphabet`
- [ ] Capabilities: enable nothing extra (no Push Notifications, no Sign in with Apple needed)
- [ ] Click **Register**
- [ ] The App ID now appears in your identifiers list — this is all you need from the Developer Portal for a basic app

### Step 14.5 — Create App Record in App Store Connect (USER does this)

> The app record must exist in App Store Connect before Codemagic can publish to it.
> Creating this record is just filling in basic info — it does NOT submit the app for review yet.

- [ ] Go to https://appstoreconnect.apple.com
- [ ] Click **"+"** → **New App**
- [ ] Platform: **iOS**
- [ ] Name: `NATO Phonetic Alphabet Trainer` (exactly 30 characters — fits Apple's limit)
- [ ] Primary Language: **English (U.S.)**
- [ ] Bundle ID: select `com.foreverfree.natoalphabet` (from Step 14.4)
- [ ] SKU: `nato-alphabet-ios` (internal identifier — users never see this)
- [ ] User Access: **Full Access**
- [ ] Click **Create**
- [ ] Note the **App ID number** shown in the App Information page (a 10-digit number like `6740123456`) — needed for Codemagic env vars

### Step 14.6 — Generate App Store Connect API Key (USER does this)

> This is the iOS equivalent of the Google Cloud service account. It lets Codemagic
> publish to App Store Connect without you needing to be present.
> ⚠️ The `.p8` key file can only be downloaded ONCE. Save it immediately after download.

- [ ] Go to https://appstoreconnect.apple.com/access/integrations/api
- [ ] Under **App Store Connect API**, click **Generate API Key** (or **"+"** button)
- [ ] Name: `Codemagic Publisher`
- [ ] Access (role): **App Manager**
- [ ] Click **Generate**
- [ ] **Immediately download the `.p8` file** — save to `C:\Users\tcozi\Dropbox\private\ioskeys\`
- [ ] Note the **Key ID** (10-character string like `ABCD123456`)
- [ ] Note the **Issuer ID** (UUID format, shown at the top of the page like `12345678-1234-1234-1234-123456789012`)
- [ ] Save all three values (Key ID, Issuer ID, .p8 contents) in your password manager

### Step 14.7 — Add iOS Environment Variables to Codemagic (USER does this)

- [ ] In Codemagic: **Teams → Environment variables → Add group** named `ios_credentials`
- [ ] Add and mark each as **Secure**:
  - [ ] `APP_STORE_CONNECT_KEY_IDENTIFIER` = Key ID from Step 14.6 (e.g., `ABCD123456`)
  - [ ] `APP_STORE_CONNECT_ISSUER_ID` = Issuer ID from Step 14.6 (UUID format)
  - [ ] `APP_STORE_CONNECT_PRIVATE_KEY` = **Full contents** of the `.p8` file (open in Notepad, copy everything including `-----BEGIN PRIVATE KEY-----` header and footer)
- [ ] Verify all 3 variables are in the `ios_credentials` group

### Step 14.8 — Enable and Configure the iOS Workflow in Codemagic (AI does this)

- [ ] AI uncomments and fully configures the `nato-alphabet-ios` workflow in `codemagic.yaml`:
  - Instance type: `mac_mini_m2`
  - Xcode: latest (Xcode 16+ required by Apple as of April 2025)
  - Environment groups: `ios_credentials`
  - Scripts: `flutter pub get`, `flutter analyze`, `flutter test`, `flutter build ipa --release`
  - Signing: `ios_signing` block with `distribution_type: app_store` and `bundle_identifier: com.foreverfree.natoalphabet`
  - Publishing: `app_store_connect` with `auth: integration`, `submit_to_testflight: true`
  - Artifacts: `apps/nato_alphabet/build/ios/ipa/*.ipa`
- [ ] AI commits and pushes updated `codemagic.yaml` to GitHub

### Step 14.9 — Connect Apple Developer Account to Codemagic (USER does this)

> This is the "integration" that the `auth: integration` line in codemagic.yaml refers to.

- [ ] In Codemagic: **Teams → Integrations → Developer Portal**
- [ ] Click **Connect Apple Developer Portal**
- [ ] Enter the three API key values from Step 14.6:
  - Key ID, Issuer ID, and upload the `.p8` file
- [ ] Give the integration a name: `foreverfree_apple`
- [ ] Click **Save**
- [ ] Update `codemagic.yaml` if needed: the `integrations: app_store_connect:` field should match the name you chose (AI updates this if needed)

### Step 14.10 — Prepare App Store Listing Text (AI does this)

Apple's limits are different from Google Play — AI adapts existing copy:

- [ ] AI prepares all text for App Store Connect:
  - **Name**: `NATO Phonetic Alphabet Trainer` (30 chars)
  - **Subtitle** (30 chars max): `Learn & quiz the NATO alphabet`
  - **Description** (4,000 chars max): adapted from Play Store description
  - **Keywords** (100 chars max): `nato,phonetic,alphabet,quiz,flashcard,military,aviation,communication,learn,free`
  - **Support URL**: `https://coziahr.com/foreverfree`
  - **Privacy Policy URL**: (existing URL from Phase 9)
  - **What's New** (first release): `Initial release — free, offline, no ads.`
- [ ] AI saves this to `docs/nato_alphabet/IOS-STORE-LISTING.md`

### Step 14.11 — Complete App Store Connect Listing (USER does this)

- [ ] In App Store Connect: navigate to your app → **App Store** tab
- [ ] Paste Name, Subtitle, Description from `docs/nato_alphabet/IOS-STORE-LISTING.md`
- [ ] Set **Category**: Education
- [ ] Enter Keywords
- [ ] Enter Support URL and Privacy Policy URL
- [ ] Age Rating: click **Set Age Rating** → fill out questionnaire
  - All violence/sexual/drug content: None/Rare
  - Expected rating: **4+**
- [ ] Privacy Nutrition Labels: **App Privacy → Get Started**
  - Does your app collect data? → **No**
  - Expected result: "No Data Collected" badge

### Step 14.12 — iOS Screenshots (USER captures with iPad OR AI sets up EC2 Mac)

Apple's required screenshot sizes:
- **iPhone 6.9"** (1320×2868 px): Required — this is the only mandatory iPhone size
- **iPad 13"** (2064×2752 px): Required IF the app declares iPad support

**Option A (Recommended — easiest): Capture on your iPad after TestFlight build is ready**
- [ ] Wait for Step 14.13 (first TestFlight build) before doing this step
- [ ] Install the TestFlight build on your iPad
- [ ] On iPad: press Power + Volume Up to screenshot (saves to Photos)
- [ ] Take screenshots of: Reference screen, Letter Quiz, Letter Quiz revealed, Word Quiz, Word Quiz revealed, About page
- [ ] Transfer to computer (AirDrop or USB) and upload to App Store Connect

**Option B (AI does this via AWS EC2 Mac — takes ~2 hours, costs ~$20):**
- [ ] USER allocates an EC2 Mac Dedicated Host (mac2.metal) in AWS Console
  - Region: us-east-1 or us-west-2
  - Note: 24-hour minimum billing applies the moment you allocate
- [ ] USER launches macOS Sonoma or Sequoia instance on the host with a 200 GB EBS volume
- [ ] USER creates a key pair and opens port 22 in the Security Group
- [ ] AI SSHes in and installs: Flutter, Xcode Command Line Tools, CocoaPods
- [ ] AI runs `xcrun simctl` to create an iPhone 6.9" and iPad 13" simulator
- [ ] AI runs the app on simulator and captures screenshots via `xcrun simctl io booted screenshot`
- [ ] AI downloads screenshots and saves to `docs/nato_alphabet/screenshots/`
- [ ] USER releases the Dedicated Host (billing stops after the 24-hour minimum)

### Step 14.13 — Trigger First iOS Build via Codemagic (AI does this)

- [ ] AI commits a trigger commit (version bump or documentation update) and pushes to `main`
- [ ] USER watches the `nato-alphabet-ios` workflow in the Codemagic dashboard
- [ ] Verify each stage passes:
  - Get dependencies ✅ → Analyze ✅ → Tests ✅ → Build IPA ✅ → Upload to TestFlight ✅
- [ ] If build fails, AI diagnoses and fixes based on build log output
- [ ] Once successful: the build appears in App Store Connect → TestFlight → iOS Builds

### Step 14.14 — TestFlight Internal Testing (USER tests on iPad)

> There is NO minimum beta testing period for iOS — unlike Android's 12-tester/14-day requirement.
> Internal TestFlight testing is just for YOUR OWN confidence before submitting.

- [ ] In App Store Connect: TestFlight → Internal Testing → add your Apple ID as tester
- [ ] On your iPad: install the **TestFlight** app from the App Store (if not already installed)
- [ ] Open TestFlight → find "NATO Phonetic Alphabet Trainer" → Install
- [ ] Run the full test checklist:
  - [ ] Reference screen: all 26 NATO entries show correctly
  - [ ] Letter Quiz: all 26 letters cycle, Reveal and Next work, progress indicator updates
  - [ ] Letter Quiz: "Done!" state appears, "Go Again" restarts cleanly
  - [ ] Word Quiz: words show, Show Me reveals each letter, Next gives new word
  - [ ] About page: opens, donation button works, back button returns
  - [ ] Dark mode: switch iPad to dark mode, verify all screens look correct
  - [ ] Airplane mode: enable airplane mode, confirm app still fully works
  - [ ] Portrait and landscape: test both orientations (iPad supports both by default)
  - [ ] No crashes, no freezes, no broken layouts

### Step 14.15 — Upload Screenshots and Finalize Listing (USER does this)

- [ ] Upload iPhone 6.9" screenshots to App Store Connect → App Store → iPhone 6.9" Display
- [ ] Upload iPad 13" screenshots (from Option A or B in Step 14.12)
- [ ] Review all listing text one more time for typos
- [ ] Confirm Privacy Nutrition Labels are saved
- [ ] Confirm Age Rating is 4+
- [ ] Confirm Privacy Policy URL resolves to your actual policy

### Step 14.16 — Submit for App Store Review (USER does this)

- [ ] In App Store Connect: navigate to your app → **App Store** tab
- [ ] Click **"+" next to iOS App** to add the version being released
- [ ] Select the build uploaded by Codemagic in Step 14.13
- [ ] Enter "What's New": `First release — free, offline, no ads ever.`
- [ ] App Review Information:
  - Sign-in required: **No**
  - Notes to reviewer: `This app teaches the NATO phonetic alphabet through a reference card, letter quizzes, and word quizzes. No login, no network access required, no data collection.`
  - Demo account: leave blank
  - Contact info: your email and phone (Apple reviewer may contact you)
- [ ] Version Release: select **Manually release this version** (so you control when it goes live)
- [ ] Click **Submit for Review**
- [ ] Apple review typically takes **24–72 hours** for new apps
- [ ] You'll receive an email when approved, rejected, or if Apple has questions

### Step 14.17 — Release and Verify (USER does this)

- [ ] Once approved email arrives, go to App Store Connect
- [ ] Click **Release This Version** (since we chose manual release)
- [ ] Wait ~30 minutes for propagation to App Store CDN
- [ ] Search "NATO Phonetic Alphabet Trainer" on the App Store from your iPad (not signed in as developer)
- [ ] Install from the public listing and verify everything looks correct
- [ ] Check the store page: icon, screenshots, description, rating all correct

### ✅ Phase 14 Success Condition
"NATO Phonetic Alphabet Trainer" is live on the Apple App Store. Anyone with an iPhone
or iPad can find and install it. Verified with a public install from the App Store listing
(not TestFlight). Codemagic automatically pushes future updates to both Google Play and
the App Store on every push to `main`.

---

### Optional: AWS EC2 Mac Instance Reference

> Only needed if: you want to run Xcode interactively, debug a build issue the Codemagic
> logs don't explain clearly, or capture iOS Simulator screenshots without a physical iPad.

**Cost:** Minimum $15.60 per session (24h × $0.65/hr for mac2.metal). Billing starts when you allocate the Dedicated Host, not when the instance launches.

**Steps to provision (USER does in AWS Console):**
1. EC2 → Dedicated Hosts → Allocate Dedicated Host
   - Instance family: `mac2` (Apple M1) or `mac2-m2` (Apple M2 — faster, costs more)
   - Region/AZ: pick any
2. EC2 → Launch Instance → choose macOS AMI (Sonoma or Sequoia)
   - Host: select the Dedicated Host you just allocated
   - Volume: **200 GB minimum** (Xcode needs ~50 GB alone)
   - Key pair: create or use existing
3. Security Group: open port 22 (SSH) from your IP
4. Wait 10–15 minutes for the instance to become accessible
5. SSH: `ssh -i your-key.pem ec2-user@<public-ip>`

**What AI can do over SSH once connected:**
- Install Flutter, Dart, CocoaPods
- Run `flutter pub get`, `flutter analyze`, `flutter test`
- Run `flutter build ipa` (command-line build, no GUI needed)
- Run iOS Simulator headlessly: `xcrun simctl boot "iPhone 16 Pro"`
- Capture simulator screenshots: `xcrun simctl io booted screenshot screenshot.png`
- Run `xcodebuild archive` and `xcodebuild -exportArchive`

**What AI CANNOT do over SSH:**
- Interact with Xcode GUI (Accept license dialogs, visual debugging)
- Respond to Keychain password prompts (GUI popups)
- Use the iOS Simulator visually (headless only)

**When done:** Terminate the instance AND release the Dedicated Host in AWS Console to stop billing.

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
| Capture screenshots via emulator + adb | **AI** (done — 6 screenshots in docs/nato_alphabet/screenshots/) |
| Create feature graphic | **User** (design tool, creative judgment) |
| Promote builds to production | **User** (requires Play Console access) |
| Install and QA test on real device | **User** (requires physical Android phone) |
| Write Ko-fi page copy and app descriptions | **AI** |
| Update donation button URL in app code | **AI** |
| Write all landing page copy and build HTML/CSS | **AI** |
| Build GitHub Actions auto-update workflow for landing page | **AI** |
| Create Ko-fi account and connect payment | **User** (their identity + payment account) |
| Upload images to Ko-fi (profile photo, cover) | **User** ✅ done |
| Deploy landing page to coziahr.com | **User** (requires domain/hosting access) |
| Generate Ko-fi profile photo + cover image | **AI** (done — files in docs/nato_alphabet/kofi_assets/) |
| Generate iOS platform files (`flutter create --platforms=ios`) | **AI** |
| Configure iOS bundle ID (no underscores allowed) | **AI** |
| Enable iOS icons in pubspec.yaml | **AI** |
| Configure iOS Codemagic workflow (codemagic.yaml) | **AI** |
| Prepare App Store listing text (IOS-STORE-LISTING.md) | **AI** |
| SSH into EC2 Mac and run headless iOS builds/screenshots | **AI** (if EC2 Mac is provisioned) |
| Apple Developer Program enrollment ($99/year) | **User** (identity + payment required) |
| Create App ID in Apple Developer Portal | **User** (requires account) |
| Create app record in App Store Connect | **User** (requires account) |
| Generate App Store Connect API key (.p8 file) | **User** (one-time download — save immediately) |
| Add iOS env vars to Codemagic (KEY_IDENTIFIER, ISSUER_ID, PRIVATE_KEY) | **User** (contains secrets) |
| Connect Apple Developer account to Codemagic integration | **User** (requires account) |
| Fill in App Store Connect listing, age rating, privacy labels | **User** (requires App Store Connect access) |
| Capture screenshots from physical iPad (TestFlight build) | **User** (physical device) |
| OR: provision AWS EC2 Mac for AI-driven screenshot capture | **User** (AWS account + $15.60+ minimum) |
| Install TestFlight app, test on iPad | **User** (physical iPad) |
| Submit for App Store review | **User** (requires App Store Connect access) |
| Release approved build to App Store | **User** (manual release step) |

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

*Last updated: 2026-04-04*
*App version at time of writing: 1.1.1+3*
