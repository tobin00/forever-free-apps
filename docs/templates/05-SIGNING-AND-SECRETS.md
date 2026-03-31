# 05 - Signing & Secrets Management

> **Audience: AI Assistant (Claude).** These are your instructions for setting up app signing.
> Some steps require the user to act (account access, password decisions, web UI). Those are clearly marked.

---

## Critical Warning (Tell the User This)

**THE ANDROID KEYSTORE IS IRREPLACEABLE.**

If it's lost, the app can never be updated on the Play Store. Always warn the user to back it up in multiple secure locations before publishing. Repeat this warning every time you walk through keystore setup.

---

## Android Signing

### Step 1: Generate the Keystore — USER MUST DO

The user develops on **Windows**. Provide the Windows-compatible single-line command.
The `keytool` command is included with Java (Android Studio installs Java).

First, tell the user to open **Android Studio → Terminal** (or Windows Command Prompt) and run:

```
keytool -genkey -v -keystore {app_name}.jks -alias {app_name}_key -keyalg RSA -keysize 2048 -validity 36500
```

> **Note:** Omit `-storepass` and `-keypass` from the command — `keytool` will prompt
> securely for passwords interactively. This avoids passwords appearing in shell history.

If they get "keytool is not recognized", tell them to find it in Android Studio's JDK:
```
"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore {app_name}.jks -alias {app_name}_key -keyalg RSA -keysize 2048 -validity 36500
```

Tell the user:
- "When prompted, choose a strong password for both the keystore and the key. Use the same password for both to keep things simple."
- "You'll be prompted for your name, organization, and location. Use real info — it goes into the certificate."
- "**CRITICAL:** Generate a NEW keystore for each app. Never reuse across apps."
- "The `.jks` file will be created in whichever directory your terminal is currently in. Note that path."

### Step 2: Back Up the Keystore — USER MUST DO

Tell the user:
- "Back up `{app_name}.jks` to at least TWO of these locations:"
  - Encrypted cloud storage (Google Drive, OneDrive)
  - USB drive stored securely
  - Password manager vault (1Password, Bitwarden)
- "Never commit the keystore to git."
- "Save the keystore password in your password manager."

### Step 3: Configure Local Signing — YOU DO (with user's keystore path)

Ask the user: "Where did you save the keystore file? I need the full path."

Then create `apps/{app_name}/android/key.properties` (this file is .gitignored):

```properties
storeFile=C:\\Users\\tcozi\\path\\to\\{app_name}.jks
storePassword=USER_PROVIDED_PASSWORD
keyAlias={app_name}_key
keyPassword=USER_PROVIDED_PASSWORD
```

**Note:** Ask the user for the password. Do not guess or generate passwords.

### Step 4: Configure build.gradle for Signing — YOU DO

Update `apps/{app_name}/android/app/build.gradle` to read from `key.properties`:

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ...existing config...

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### Step 5: Configure Codemagic Signing — USER MUST DO

Tell the user to:

1. **Base64-encode the keystore** (Windows PowerShell command):
   ```powershell
   [Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\path\to\{app_name}.jks")) | Out-File {app_name}_base64.txt
   ```
   *(Open PowerShell, not Command Prompt. Replace the path with the actual keystore location.)*

2. **In Codemagic UI → Teams → Environment Variables**, create group `android_credentials` (or reuse existing group) with:
   | Variable | Value |
   |----------|-------|
   | `CM_KEYSTORE` | Contents of {app_name}_base64.txt |
   | `CM_KEYSTORE_PASSWORD` | Keystore password |
   | `CM_KEY_ALIAS` | `{app_name}_key` |
   | `CM_KEY_PASSWORD` | Key password |

3. **Mark all variables as "Secure"** (encrypted, not shown in logs)

---

## Google Play Store API Access — USER MUST DO (One-Time)

Walk the user through these steps. They require web UI access to Google accounts.

### Create a Google Play Developer Account (if not already done)
1. Go to https://play.google.com/console/
2. Pay the one-time $25 registration fee
3. Complete identity verification

### Create a Google Cloud Service Account
1. Go to **Google Play Console → Setup → API access**
2. Click **Link a Google Cloud project** (or create one)
3. Click **Create new service account**
4. Follow the link to Google Cloud Console
5. Create a service account:
   - Name: `codemagic-publisher`
   - Role: None (permissions are set in Play Console)
6. Create a JSON key → Download it

### Grant Permissions in Play Console
1. Back in Play Console → **Setup → API access**
2. Find the service account → click **Manage permissions**
3. Grant:
   - **Releases** → Manage production and testing track releases
   - **App information** → Edit and manage
4. Apply to **all apps** (so it works for future apps too)

### Add to Codemagic
Tell the user to add to the `android_credentials` environment group:
| Variable | Value |
|----------|-------|
| `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` | Entire contents of the JSON key file |

**Note:** This service account is reusable across all apps. Only set it up once.

---

## Google Play App Signing (Reference)

Google Play has its own layer called **Play App Signing**:
- Your keystore becomes the "upload key" (proves you uploaded it)
- Google generates a separate distribution key (used to sign the APK users download)
- Play App Signing is required for AAB uploads and is opt-in when creating the app

This is transparent to you (the AI). The codemagic.yaml build signs with the upload key, and Google handles the rest.

---

## iOS Signing (Deferred)

Do NOT set up iOS signing until the user explicitly asks for it.

### When the user is ready, they'll need:
- **Apple Developer Program membership** ($99/year)
- **Access to a Mac** (borrowed or AWS EC2)

### Credentials needed:
| Credential | What It Is | How to Get It |
|------------|-----------|---------------|
| **Signing Certificate (.p12)** | Proves identity | Generated in Keychain Access on Mac |
| **Provisioning Profile** | Links cert to app + devices | Created in Apple Developer portal |
| **App Store Connect API Key** | For automated uploads | Created in App Store Connect → Users → Keys |

### Codemagic iOS Setup
Codemagic can manage iOS signing automatically:
1. Upload .p12 certificate and provisioning profile to Codemagic
2. Or use Codemagic's automatic code signing feature

**Detailed iOS steps will be added after the first iOS submission.**

---

## .gitignore Entries — YOU DO

Ensure these entries exist in the repo root `.gitignore` (add them during Phase 6):

```gitignore
# Signing credentials - NEVER commit these
*.jks
*.keystore
**/key.properties
*.p12
*.mobileprovision
**/fastlane/report.xml
**/fastlane/README.md

# Service account keys
*-service-account.json
```

---

## Instructions for AI

When setting up signing for a new app (Phase 6 of `00-PROCESS.md`):

**You do:**
1. Update `android/app/build.gradle` with the signing config (Step 4 above)
2. Ensure `.gitignore` has all credential patterns (see above)
3. Verify no credentials are committed: run `git grep` for password patterns
4. Create the `key.properties` file after the user provides the keystore path and password

**You ask the user to do:**
1. Generate a NEW keystore for this app (provide the command with app name filled in)
2. Back up the keystore to 2+ secure locations
3. Save passwords in their password manager
4. Base64-encode the keystore and upload to Codemagic
5. Set up Google Play Developer account (first time only)
6. Create Google Cloud service account (first time only)
7. Add all environment variables to Codemagic

**Walk them through each step one at a time.** Don't dump all instructions at once — ask them to confirm each step is done before moving to the next.

### Secrets Checklist (Verify Before Publishing)

- [ ] Keystore generated and backed up in 2+ locations
- [ ] Keystore password saved in password manager
- [ ] `key.properties` created locally and gitignored
- [ ] Keystore base64-encoded and uploaded to Codemagic
- [ ] Codemagic environment variables set (all 4 keystore vars)
- [ ] Google Cloud service account JSON uploaded to Codemagic (first time only)
- [ ] All Codemagic variables marked as "Secure"
- [ ] `.gitignore` includes all credential file patterns
- [ ] No credentials in any committed file (`git grep` check passes)
