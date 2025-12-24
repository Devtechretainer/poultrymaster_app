# Student Safety Platform - Setup Guide

## Overview
This is a Flutter-based Student Safety Platform with offline-first architecture for secure student pickup verification.

## Prerequisites
- Flutter SDK (3.8.1+)
- Firebase project configured
- Android Studio / Xcode for mobile development

## Step 1: Install Dependencies

```bash
flutter pub get
```

## Step 2: Add Poppins Font

1. Download Poppins font from [Google Fonts](https://fonts.google.com/specimen/Poppins)
2. Create a `fonts` directory in the project root: `poultry_core/fonts/`
3. Add these font files:
   - `Poppins-Regular.ttf`
   - `Poppins-Medium.ttf`
   - `Poppins-SemiBold.ttf`
   - `Poppins-Bold.ttf`

The font is already configured in `pubspec.yaml`.

## Step 3: Firebase Setup

### 3.1 Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project: "Student Safety Platform"
3. Enable Authentication, Firestore, Storage, and Cloud Functions

### 3.2 Add Firebase Configuration

#### Android:
1. Download `google-services.json` from Firebase Console
2. Place it in: `android/app/google-services.json`
3. Add to `android/build.gradle.kts`:
   ```kotlin
   dependencies {
       classpath("com.google.gms:google-services:4.4.0")
   }
   ```
4. Add to `android/app/build.gradle.kts`:
   ```kotlin
   plugins {
       id("com.google.gms.google-services")
   }
   ```

#### iOS:
1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in: `ios/Runner/GoogleService-Info.plist`
3. Add to `ios/Runner/Info.plist`:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleTypeRole</key>
           <string>Editor</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>YOUR_REVERSED_CLIENT_ID</string>
           </array>
       </dict>
   </array>
   ```

### 3.3 Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Students collection
    match /students/{studentId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      request.auth.token.role == 'admin';
      
      // Guardians subcollection
      match /guardians/{guardianId} {
        allow read: if request.auth != null;
        allow write: if request.auth != null && 
                        request.auth.token.role == 'admin';
      }
    }
    
    // Pickups collection
    match /pickups/{pickupId} {
      allow read: if request.auth != null && 
                     (request.auth.token.role == 'guard' || 
                      request.auth.token.role == 'parent');
      allow create: if request.auth != null && 
                       request.auth.token.role == 'guard';
      allow update, delete: if false; // Immutable records
    }
  }
}
```

### 3.4 Cloud Functions Setup

Create a Cloud Function `verifyGuardPin`:

```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const crypto = require('crypto');

admin.initializeApp();

exports.verifyGuardPin = functions.https.onCall(async (data, context) => {
  const { pin } = data;
  
  // Hash the PIN (use environment variable for salt)
  const hashedPin = crypto
    .createHash('sha256')
    .update(pin + process.env.PIN_SALT)
    .digest('hex');
  
  // Verify against stored hashed PINs in Firestore
  const guardsRef = admin.firestore().collection('guards');
  const snapshot = await guardsRef
    .where('hashedPin', '==', hashedPin)
    .where('isActive', '==', true)
    .limit(1)
    .get();
  
  if (snapshot.empty) {
    return { success: false, error: 'Invalid PIN' };
  }
  
  const guardData = snapshot.docs[0].data();
  
  // Create custom token for authentication
  const customToken = await admin.auth().createCustomToken(snapshot.docs[0].id, {
    role: 'guard',
    name: guardData.name,
  });
  
  return {
    success: true,
    userId: snapshot.docs[0].id,
    userName: guardData.name,
    customToken: customToken,
  };
});
```

### 3.5 Storage Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /pickup_photos/{photoId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      request.auth.token.role == 'guard';
    }
  }
}
```

## Step 4: Initialize Offline Storage

The app automatically initializes Hive and SQLite on first run. No manual setup required.

## Step 5: Run the App

```bash
flutter run
```

## Architecture Overview

### Guard App Flow:
1. **Splash Screen** → Shows School Safeguard logo
2. **Login Screen** → PIN entry (4 digits)
3. **Dashboard** → After successful login, syncs student data
4. **Student Search** → Search/scan student ID
5. **Verification Screen** → Shows student, guardians, camera, verify button

### Offline-First Features:
- All student data cached locally on login
- Pickup events queued when offline
- Auto-sync when network restored
- Network status indicator in UI

### Key Features:
- ✅ PIN-based guard authentication
- ✅ QR code scanning for student lookup
- ✅ Offline-first architecture
- ✅ Photo capture for pickup verification
- ✅ Real-time network status
- ✅ Automatic pending queue sync

## Next Steps

1. **Parent App**: Create the parent-facing app for viewing pickup history
2. **Admin Dashboard**: Web interface for managing students and guards
3. **SMS/WhatsApp Alerts**: Integrate Twilio or similar for notifications
4. **Analytics**: Add Firebase Analytics for usage tracking

## Troubleshooting

### Build Errors:
- Ensure all dependencies are installed: `flutter pub get`
- Clean build: `flutter clean && flutter pub get`
- For Android: Ensure NDK version 27.0.12077973 is set

### Firebase Errors:
- Verify `google-services.json` / `GoogleService-Info.plist` are in correct locations
- Check Firebase project has all services enabled
- Verify Cloud Functions are deployed

### Font Issues:
- Ensure Poppins font files are in `fonts/` directory
- Run `flutter pub get` after adding fonts

## Support

For issues or questions, refer to the project documentation or contact the development team.

