# Release Keystore Setup

**Phase:** 28
**Status:** Ready to execute
**Last updated:** 2026-07-06
**Owner:** Mobile Lead

## Overview

Before uploading the AAB to Play Console, the app must be signed with a release keystore (not the debug keystore). The release keystore is a cryptographic file that proves you are the app's owner. **If you lose the keystore, you cannot update the app on Play Store.**

This document covers creating the keystore, configuring Gradle to use it, and rebuilding the signed AAB.

## Step 1: Create the release keystore

Run this command on your development machine:

```bash
keytool -genkey -v \
    -keystore walktogether.keystore \
    -alias walktogether \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -storepass YOUR_STORE_PASSWORD \
    -keypass YOUR_KEY_PASSWORD \
    -dname "CN=WalkTogether, OU=Mobile, O=WalkTogether, L=City, ST=State, C=IN"
```

**Replace:**
- `YOUR_STORE_PASSWORD` — a strong password for the keystore file
- `YOUR_KEY_PASSWORD` — a strong password for the key alias (can be same as store password)

**Output:** `walktogether.keystore` file in the current directory.

## Step 2: Store the keystore securely

**CRITICAL: Do NOT commit the keystore to the repository.** The `.gitignore` already excludes `*.keystore` and `*.jks`.

**Storage options (pick one):**
1. **Google Play App Signing** (recommended) — Upload your keystore to Play Console once, and Google manages it. Even if you lose your local copy, you can still update the app.
2. **Encrypted cloud storage** — Store in an encrypted folder (e.g. 1Password, Bitwarden, encrypted Google Drive).
3. **Physical backup** — USB drive stored in a safe location.

**Back up the keystore + passwords in at least 2 locations.**

## Step 3: Create `key.properties` file

Create a file at `flutter_app/android/key.properties`:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=walktogether
storeFile=/absolute/path/to/walktogether.keystore
```

**CRITICAL: Do NOT commit `key.properties` to the repository.** The `.gitignore` already excludes `key.properties`.

## Step 4: Configure Gradle signing

Update `flutter_app/android/app/build.gradle` to read `key.properties` and use it for release signing:

```gradle
// Add at the top of the file, before the plugins block:
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

android {
    namespace "com.walktogether.app"
    compileSdk = flutter.compileSdkVersion

    // ... existing config ...

    buildTypes {
        release {
            signingConfig signingConfigs.debug  // ← REPLACE THIS
        }
    }
}
```

**Replace the release build type with:**

```gradle
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
        }
    }
```

## Step 5: Rebuild release APK + AAB

```bash
cd flutter_app

# Rebuild release APK (signed with release keystore)
flutter build apk --release

# Rebuild release AAB (signed with release keystore)
flutter build appbundle --release
```

**Expected output:**
```
✓ Built build/app/outputs/flutter-apk/app-release.apk (23.3MB)
✓ Built build/app/outputs/bundle/release/app-release.aab (23.4MB)
```

## Step 6: Verify the AAB is signed correctly

```bash
# Verify the AAB is signed with your release key
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

**Expected output:** "jar verified."

## Step 7: Upload to Play Console

1. Go to Play Console → Internal Testing → Create new release
2. Upload `app-release.aab`
3. Play Console will accept the AAB if it's signed with a valid release key
4. If you see "App not signed correctly" error, verify the keystore + key.properties are correct

## Step 8: Enroll in Google Play App Signing (recommended)

After your first upload, Play Console will prompt you to enroll in Play App Signing:

1. Go to Play Console → Setup → App integrity
2. Follow the prompts to enroll
3. Google will re-sign your app with their key
4. Your upload key is used to verify you, but Google's key is used for the final APK

**Benefit:** If you lose your keystore, you can request a reset from Google (with identity verification).

## Environment variable documentation

For CI/CD pipelines, store keystore info as environment variables:

```bash
# CI/CD environment variables (NEVER commit these)
WT_KEYSTORE_PATH=/secure/path/to/walktogether.keystore
WT_KEYSTORE_PASSWORD=********
WT_KEY_ALIAS=walktogether
WT_KEY_PASSWORD=********
```

In CI/CD, generate `key.properties` from env vars:

```bash
cat > flutter_app/android/key.properties << EOF
storePassword=$WT_KEYSTORE_PASSWORD
keyPassword=$WT_KEY_PASSWORD
keyAlias=$WT_KEY_ALIAS
storeFile=$WT_KEYSTORE_PATH
EOF
```

## Security checklist

- [ ] Keystore created with strong passwords
- [ ] Keystore file NOT committed to repo (`.gitignore` protects it)
- [ ] `key.properties` NOT committed to repo (`.gitignore` protects it)
- [ ] Keystore backed up in at least 2 secure locations
- [ ] Passwords stored in a password manager (not in plaintext files)
- [ ] Release AAB signed with release keystore (not debug)
- [ ] Play Console accepts the signed AAB
- [ ] Google Play App Signing enrolled (recommended)

## Troubleshooting

### "App not signed correctly" on Play Console

**Cause:** The AAB is signed with a different key than what Play Console expects.

**Fix:**
1. If this is the first upload: make sure you're using a release keystore (not debug)
2. If you've uploaded before: you must use the SAME keystore for all future uploads
3. If you lost the original keystore: you must enroll in Play App Signing and request a key reset

### "Keystore file not found"

**Cause:** The path in `key.properties` doesn't match the actual keystore location.

**Fix:** Use an absolute path in `key.properties`:
```properties
storeFile=/home/username/walktogether.keystore
```

### Build fails with "keystoreProperties is null"

**Cause:** `key.properties` file doesn't exist or can't be read.

**Fix:** Verify the file exists at `flutter_app/android/key.properties` and has correct format.
