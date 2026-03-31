# 06 - Store Publishing Guide

> **Audience: AI Assistant (Claude).** These are your instructions for the publishing phase.
> This doc covers the PROCESS. For app-specific listing text, see `docs/{app_name}/STORE-LISTING.md`.

---

## Google Play Store

### Account Setup (One-Time) — USER MUST DO

If this is the first app, walk the user through:
1. Go to https://play.google.com/console/
2. Pay the one-time **$25** registration fee
3. Complete identity verification
4. Set up Google Cloud service account (see `05-SIGNING-AND-SECRETS.md`)

If the account already exists, skip this.

### App Creation (Per App) — USER MUST DO

Tell the user to create the app in Play Console with these settings:
- App name: (provide from `docs/{app_name}/STORE-LISTING.md`)
- Default language: English (United States)
- App type: App (not Game)
- Free / Paid: **Free**
- Declarations: Accept all

Then tell them to paste the store listing text you prepared in `docs/{app_name}/STORE-LISTING.md`.

---

### Content Rating — USER MUST DO (with your guidance)

Tell the user step by step:
1. Go to **App content → Content rating**
2. Select **IARC** rating
3. Answer the questionnaire:
   - Violence: None
   - Sexuality: None
   - Language: None
   - Controlled substances: None
   - Misc: No user-generated content, no data sharing
4. Result should be: **Rated for Everyone / PEGI 3**

All of our apps should receive this same rating since they are simple offline utilities.

---

### Privacy Policy — YOU DO (writing) + USER MUST DO (hosting)

**You write** the privacy policy by filling in this template with the app name:

```
Privacy Policy for [App Name]

Last updated: [Date]

[App Name] is a free application built as a public service.

DATA COLLECTION
This app does not collect, store, or transmit any personal data. Period.

• No analytics or tracking
• No advertising identifiers
• No cookies or local tracking
• No network connections
• No access to your contacts, photos, camera, or microphone
• No account creation required

PERMISSIONS
This app requires no special permissions.

DATA STORAGE
All app data exists only in temporary memory while the app is running.
Nothing is saved to your device or sent anywhere.

THIRD-PARTY SERVICES
This app uses no third-party services, SDKs, or APIs.

CHILDREN'S PRIVACY
This app does not collect data from anyone, including children.
It is safe for users of all ages.

CHANGES TO THIS POLICY
If this policy changes, the updated version will be posted at this URL.

CONTACT
If you have questions about this privacy policy, contact:
[User's email address]
```

Ask the user for their contact email if you don't have it. Then **tell the user** to host this at a public URL. Suggest options:
- GitHub Pages (free) — create a `privacy/` directory in the repo
- Any static site host

The same template works for ALL offline apps. Just change the app name and date.

---

### Data Safety Section — USER MUST DO (with your guidance)

Tell the user to fill in the Data Safety questionnaire with these answers:

| Question | Answer |
|----------|--------|
| Does your app collect or share user data? | **No** |
| Is all collected data encrypted in transit? | N/A (no data collected) |
| Can users request data deletion? | N/A (no data stored) |
| Is data collection required or optional? | N/A |

Expected result badge: **No data collected**

These answers are the same for ALL offline, no-data apps.

---

### Screenshots — USER MUST DO (with your guidance)

**You plan** which screenshots to take (this goes in `docs/{app_name}/STORE-LISTING.md`).

**You tell the user** exactly how to capture them:
1. Run the app in release mode: `flutter run --release`
2. Navigate to each screen described in the screenshot plan
3. Take screenshots on a clean emulator (no debug banner)

**Requirements:**
- Minimum 2 screenshots, recommended 4-6
- Phone: 1080x1920 or 1440x2560 (16:9)
- Optional: add framing/text overlays with Figma, Canva, or screenshots.pro

### Feature Graphic — USER MUST DO (with your guidance)

**You describe** what it should look like (in `docs/{app_name}/STORE-LISTING.md`).
**The user creates** the 1024x500 image following the design language (branded background, app name, key visual).

---

## Apple App Store (Deferred)

Do NOT initiate iOS publishing unless the user explicitly asks for it.

### Account Setup — USER MUST DO
- Apple Developer Program: **$99/year**
- App Store Connect account (included with Developer Program)
- Mac access required for initial setup

### Key Differences from Play Store
- **Manual review** — Apple reviews every update (can take 1-3 days)
- **Multiple screenshot sizes** required (iPhone 6.7", 6.5", 5.5", iPad)
- **App preview video** allowed (optional, 15-30 seconds)
- **Privacy Nutrition Labels** — similar to Play Store Data Safety
- **Subtitle** (max 30 chars) instead of short description
- **Promotional text** (max 170 chars) — can be updated without a new build
- **Keywords** (max 100 chars) — comma-separated, important for discovery

**Detailed iOS publishing steps will be added after the first iOS submission.**

---

## Versioning — YOU DO

### Version Format: `MAJOR.MINOR.PATCH`

| Component | When to Increment |
|-----------|-------------------|
| **MAJOR** | Breaking changes or complete redesign |
| **MINOR** | New features |
| **PATCH** | Bug fixes |

First release: `1.0.0`. Set this in `pubspec.yaml`.

### Build Number
Auto-incremented by Codemagic. Must always increase. Both stores use this to determine if a build is newer.

---

## Release Flow

1. **You push to `main`** → Codemagic auto-builds and publishes to **Internal Testing** track
2. **You tell the user** → "Build is on the internal testing track. Please install and verify on your device."
3. **User tests** → installs from internal testing link
4. **User approves** → you tell them to promote to production in Play Console

---

## Instructions for AI

When publishing a new app (Phase 7 of `00-PROCESS.md`):

**You do:**
1. Copy `docs/templates/06-STORE-LISTING-TEMPLATE.md` → `docs/{app_name}/STORE-LISTING.md`
2. Fill in the store listing text based on the app's REQUIREMENTS.md
3. Copy `docs/templates/07-CHECKLIST.md` → `docs/{app_name}/CHECKLIST.md`
4. Write the privacy policy (fill in template above with app name)
5. Plan screenshots (add to STORE-LISTING.md)
6. Set version in `pubspec.yaml`
7. Work through the checklist, marking items done

**You walk the user through (one step at a time, wait for confirmation):**
1. Creating the app in Play Console
2. Pasting the store listing text
3. Completing the content rating questionnaire
4. Completing the Data Safety questionnaire
5. Hosting the privacy policy
6. Taking screenshots
7. Creating the feature graphic
8. Submitting to internal testing
9. Promoting to production after verification
