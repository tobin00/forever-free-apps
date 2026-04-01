# 04 - CI/CD Pipeline

> Codemagic configuration for automated builds, tests, and Fastlane deployment.

---

## Overview

```
Git Push → Codemagic Detects Push → Analyze → Unit/Widget Tests → Build AAB → Publish to Internal Track
```

### Pipeline Stages

| Stage | What Happens | Failure Behavior |
|-------|-------------|------------------|
| **Analyze** | `flutter analyze` — checks for lint errors | Blocks build |
| **Unit + Widget Tests** | `flutter test` — runs all tests in `test/` | Blocks build |
| **Build Android** | `flutter build appbundle --release` | Blocks publish |
| **Publish Android** | Codemagic built-in → Google Play internal track | Reports failure |
| **Build iOS** | `flutter build ipa --release` | Blocks publish (deferred) |
| **Publish iOS** | Codemagic built-in → App Store Connect | Reports failure (deferred) |

> **Integration tests and CI:** Flutter integration tests (`integration_test/`) require a running
> device or emulator and cannot easily run in standard Codemagic workflows without significant
> setup (Android emulator in CI is slow and flaky). Our strategy:
> - **Unit + widget tests** (`test/`) run on every CI build — these are fast and reliable
> - **Integration tests** run **locally** before pushing to main (developer responsibility)
> - If the team grows, revisit adding emulator-based CI testing via Firebase Test Lab

---

## Codemagic Setup

### Initial Setup (One-Time) — USER MUST DO

Tell the user to complete these steps (they require web UI access to accounts you cannot access):

1. **Create Codemagic account** at https://codemagic.io (sign in with GitHub)
2. **Connect the GitHub repository** for this monorepo
3. **Select "Flutter App"** as the project type
4. **Choose "codemagic.yaml"** for configuration (not the workflow editor)
5. **Add environment variables** for signing (see 05-SIGNING-AND-SECRETS.md)

### Monorepo Configuration

Codemagic supports monorepos. Use path-based triggers so only the changed app builds:

```yaml
# Each app has its own workflow with path-based triggers
workflows:
  nato-alphabet-android:
    triggering:
      events:
        - push
      branch_patterns:
        - pattern: 'main'
          include: true
      # Note: path_patterns is NOT supported by Codemagic and will cause a validation error.
      # Every push to main triggers all workflows. This is acceptable for a small monorepo.
```

This means:
- Changes to `apps/nato_alphabet/` trigger the NATO app build
- Changes to `packages/shared_app_core/` trigger ALL app builds (shared code changed)
- Changes to `docs/` trigger nothing

---

## codemagic.yaml

This file lives in the **repository root**.

```yaml
workflows:
  # ============================
  # NATO Alphabet - Android
  # ============================
  nato-alphabet-android:
    name: NATO Alphabet - Android
    max_build_duration: 30
    instance_type: mac_mini_m2

    environment:
      flutter: stable
      java: 17
      groups:
        - android_credentials    # Keystore + Play Store creds

    triggering:
      events:
        - push
      branch_patterns:
        - pattern: 'main'
          include: true
      # Note: path_patterns is NOT supported by Codemagic and will cause a validation error.
      # Every push to main triggers all workflows. This is acceptable for a small monorepo.

    scripts:
      # Navigate to the app directory
      - name: Set working directory
        script: |
          echo "APP_DIR=$CM_BUILD_DIR/apps/nato_alphabet" >> $CM_ENV

      # Get dependencies for shared package first
      - name: Get shared package dependencies
        script: |
          cd $CM_BUILD_DIR/packages/shared_app_core
          flutter pub get

      # Get app dependencies
      - name: Get app dependencies
        script: |
          cd $APP_DIR
          flutter pub get

      # Static analysis
      - name: Analyze
        script: |
          cd $APP_DIR
          flutter analyze --no-fatal-infos

      # Run unit and widget tests (integration tests run locally, not in CI)
      - name: Run unit and widget tests
        script: |
          cd $APP_DIR
          flutter test --coverage

      # Set up Android signing
      - name: Set up Android signing
        script: |
          cd $APP_DIR
          echo $CM_KEYSTORE | base64 --decode > $CM_BUILD_DIR/keystore.jks
          cat > android/key.properties <<EOF
          storeFile=$CM_BUILD_DIR/keystore.jks
          storePassword=$CM_KEYSTORE_PASSWORD
          keyAlias=$CM_KEY_ALIAS
          keyPassword=$CM_KEY_PASSWORD
          EOF

      # Build release AAB (Android App Bundle)
      - name: Build Android App Bundle
        script: |
          cd $APP_DIR
          flutter build appbundle --release \
            --build-number=$PROJECT_BUILD_NUMBER

    artifacts:
      - apps/nato_alphabet/build/**/outputs/**/*.aab
      - apps/nato_alphabet/build/**/outputs/**/mapping.txt

    publishing:
      google_play:
        credentials: $GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
        track: internal    # Start with internal testing track
        submit_as_draft: true

  # ============================
  # NATO Alphabet - iOS (DEFERRED)
  # ============================
  # Uncomment and configure when ready for iOS
  #
  # nato-alphabet-ios:
  #   name: NATO Alphabet - iOS
  #   max_build_duration: 30
  #   instance_type: mac_mini_m2
  #   environment:
  #     flutter: stable
  #     xcode: latest
  #     cocoapods: default
  #     groups:
  #       - ios_credentials
  #   scripts:
  #     - name: Set up iOS signing
  #       script: |
  #         # iOS signing setup goes here
  #     - name: Build iOS
  #       script: |
  #         cd apps/nato_alphabet
  #         flutter build ipa --release
  #   artifacts:
  #     - apps/nato_alphabet/build/ios/ipa/*.ipa
  #   publishing:
  #     app_store_connect:
  #       auth: integration
```

---

## Fastlane Configuration

Fastlane is used for store submission automation. For Codemagic's built-in publishing (shown above), Fastlane is optional for basic submissions. Use Fastlane when you need:
- Custom release notes per version
- Screenshot automation
- Metadata management
- More complex submission workflows

### Android Fastlane Setup

Create `apps/nato_alphabet/android/fastlane/Fastfile`:

```ruby
default_platform(:android)

platform :android do
  desc "Deploy to Google Play internal testing"
  lane :internal do
    upload_to_play_store(
      track: 'internal',
      aab: '../build/app/outputs/bundle/release/app-release.aab',
      json_key_data: ENV['GCLOUD_SERVICE_ACCOUNT_CREDENTIALS'],
      package_name: 'com.yourorg.natoalphabet',
      skip_upload_metadata: false,
      skip_upload_changelogs: false,
      skip_upload_images: true,
      skip_upload_screenshots: true,
    )
  end

  desc "Promote internal to production"
  lane :promote_to_production do
    upload_to_play_store(
      track: 'internal',
      track_promote_to: 'production',
      json_key_data: ENV['GCLOUD_SERVICE_ACCOUNT_CREDENTIALS'],
      package_name: 'com.yourorg.natoalphabet',
    )
  end
end
```

### Release Flow

1. **Push to `main`** → Codemagic builds → publishes to **Internal Testing** track
2. **Test internally** — install from Play Store internal link
3. **Promote manually** — when satisfied, promote to production (or use Fastlane lane)

This gives you a safety net: every push to main creates a build, but it doesn't go to production users until you explicitly promote it.

---

## Build Numbering

Both stores require a unique, ever-increasing build number. Codemagic provides
`$PROJECT_BUILD_NUMBER` (auto-increments with each build). Pass it to Flutter at build time:

```yaml
# In codemagic.yaml build script — pass build number as a flag
- name: Build Android App Bundle
  script: |
    cd $APP_DIR
    flutter build appbundle --release \
      --build-number=$PROJECT_BUILD_NUMBER
```

> **Do NOT** put `$BUILD_NUMBER` in `pubspec.yaml` — Flutter won't substitute shell
> variables in that file. Instead, always pass `--build-number` as a CLI flag.
> The version name (e.g. `1.0.0`) stays in `pubspec.yaml`; only the build number
> comes from Codemagic.

---

## Branch Strategy

Keep it simple:

| Branch | Purpose |
|--------|---------|
| `main` | Production-ready code. Every push triggers CI. |
| `feature/{app}/{name}` | Feature development. PR into main when ready. |
| `fix/{app}/{name}` | Bug fixes. PR into main. |

**No develop branch.** No release branches. Main is always deployable. Features are small and merged quickly via PRs.

---

## Environment Variables (Codemagic) — USER MUST DO

Tell the user to set these in Codemagic UI under **Teams → Environment Variables**:

| Variable | Group | Description |
|----------|-------|-------------|
| `CM_KEYSTORE` | `android_credentials` | Base64-encoded Android keystore file |
| `CM_KEYSTORE_PASSWORD` | `android_credentials` | Keystore password |
| `CM_KEY_ALIAS` | `android_credentials` | Key alias name |
| `CM_KEY_PASSWORD` | `android_credentials` | Key password |
| `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` | `android_credentials` | Google Play API JSON key |

See **05-SIGNING-AND-SECRETS.md** for how to generate each of these.

---

## Notifications — USER MUST DO

Tell the user to configure Codemagic notifications:
- **Email** — for all failed builds
- **Slack** (optional) — if they set up a workspace later

---

## Instructions for AI

When adding a new app to the CI/CD pipeline (Phase 6 of `00-PROCESS.md`):

**You do:**
1. Open `codemagic.yaml` at the repo root
2. Copy an existing workflow block (e.g., from the nato-alphabet workflow)
3. Update these values in the new block:
   - `name` → new app's display name
   - `path_patterns` → point to `apps/{new_app_name}/**`
   - Keep `packages/shared_app_core/**` in path triggers (shared code changes should rebuild all apps)
   - Update all `scripts` paths to point to the new app's directory
4. Keep the same stage order: analyze → test → build → publish
5. Commit the updated `codemagic.yaml`

**Ask the user to do:**
1. Verify the Codemagic account is connected to the GitHub repo (first time only)
2. Set up environment variables if using a different keystore (see `05-SIGNING-AND-SECRETS.md`)
3. Push to main and verify the build triggers correctly in the Codemagic dashboard
