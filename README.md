# Family Shopping List (React Native + Firebase)

This repository now contains a **React Native (Expo + TypeScript)** mobile app for Android.

The app supports:
- Google Sign-In for the main user (and invited members)
- Family group creation/join by invitation email
- Shared real-time shopping list for one family
- Shopping item add/edit/delete
- Item fields: **Label**, **Amount**, optional **Description**
- Item status: **NEEDED** (default), **BOUGHT**, **NOT_AVAILABLE**
- Hard delete of items (no archive/history)

---

## 1) Tech Stack

- React Native via Expo SDK 52
- TypeScript
- Firebase Authentication (Google provider)
- Firebase Cloud Firestore

---

## 2) Project Structure

```text
.
├── App.tsx                       # Main app UI and screen logic
├── src
│   ├── config
│   │   └── firebase.ts           # Firebase bootstrap
│   ├── hooks
│   │   └── useFamilyShopping.ts  # Auth + data orchestration
│   ├── services
│   │   └── firestoreService.ts   # Firestore CRUD and subscriptions
│   ├── components
│   │   └── ItemCard.tsx          # Shopping item UI
│   └── types
│       └── models.ts             # App domain types
├── __tests__
│   └── smoke.test.tsx
└── firestore.rules               # Security rules (adjust as needed)
```

---

## 3) Prerequisites

Install the following tools:

1. **Node.js 20+**
2. **npm 10+** (or use pnpm/yarn if you adapt scripts)
3. **Android Studio** with Android SDK and emulator
4. **Java 17** (recommended for modern Android builds)
5. **Expo CLI** (optional globally, you can use `npx expo`):
   ```bash
   npm install -g expo
   ```

Verify local tooling:
```bash
node -v
npm -v
npx expo --version
```

---

## 4) Firebase Setup (Required)

### 4.1 Create Firebase project
1. Open Firebase Console.
2. Create a project.
3. Add an Android app (package name in `app.json`):
   - `com.example.familyshoppinglist`

### 4.2 Enable Authentication
1. In Firebase Console → Authentication → Sign-in method.
2. Enable **Google** sign-in provider.

### 4.3 Create Firestore
1. Create a Firestore database in production mode.
2. Deploy or paste appropriate security rules (starting from `firestore.rules`).

### 4.4 Get Firebase Web config
From project settings, collect:
- apiKey
- authDomain
- projectId
- storageBucket
- messagingSenderId
- appId

### 4.5 Google OAuth client IDs
For Expo Auth Session (Google sign-in), configure:
- Web client ID
- Android client ID

---

## 5) Environment Variables

Create a `.env` file in repository root:

```env
EXPO_PUBLIC_FIREBASE_API_KEY=...
EXPO_PUBLIC_FIREBASE_AUTH_DOMAIN=...
EXPO_PUBLIC_FIREBASE_PROJECT_ID=...
EXPO_PUBLIC_FIREBASE_STORAGE_BUCKET=...
EXPO_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=...
EXPO_PUBLIC_FIREBASE_APP_ID=...

EXPO_PUBLIC_GOOGLE_WEB_CLIENT_ID=...
EXPO_PUBLIC_GOOGLE_ANDROID_CLIENT_ID=...
```

> `EXPO_PUBLIC_*` variables are injected at build/runtime by Expo.

---

## 6) Install, Run, Compile

### 6.1 Install dependencies
```bash
npm install
```

### 6.2 Start Metro / Expo dev server
```bash
npm run start
```

### 6.3 Run on Android emulator/device
```bash
npm run android
```

If this is your first run, ensure an emulator is running or a USB device is connected with debugging enabled.

### 6.4 Build APK/AAB (recommended using EAS)
Install EAS CLI:
```bash
npm install -g eas-cli
```

Login and configure:
```bash
eas login
eas build:configure
```

Build Android artifact:
```bash
eas build --platform android
```

For local native builds without EAS:
```bash
npx expo prebuild
npx expo run:android
```

---

## 7) How the App Works

### Authentication and Family Group Logic
- User signs in with Google.
- App checks for a family group where:
  - user is owner (`ownerUid == user.uid`), or
  - user email exists in `memberEmails`.
- If not found, a new group is created with that user as owner.

### Invitations
- Owner invites members by adding their email to `memberEmails`.
- Invited member signs in with Google using same email.
- On login, app detects membership and joins that family group.

### Shared List
- Shopping items are stored in `shoppingItems` with `familyGroupId`.
- Clients subscribe in real time using Firestore snapshot listeners.

---

## 8) Firestore Data Model

### `familyGroups/{groupId}`
```json
{
  "ownerUid": "string",
  "ownerEmail": "string",
  "memberEmails": ["string"],
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### `shoppingItems/{itemId}`
```json
{
  "familyGroupId": "string",
  "label": "string",
  "amount": "string",
  "description": "string",
  "status": "NEEDED | BOUGHT | NOT_AVAILABLE",
  "createdByUid": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

---

## 9) Testing and Quality Checks

### Unit tests
```bash
npm run test
```

### Lint
```bash
npm run lint
```

### Type-check
```bash
npx tsc --noEmit
```

---

## 10) Troubleshooting

### Google sign-in fails
- Verify OAuth client IDs in `.env`.
- Confirm provider enabled in Firebase Auth.
- Confirm app signature / SHA values registered for Android client in Firebase/Google Cloud.

### Firestore permission denied
- Check `firestore.rules` logic.
- Verify signed-in account is owner/member of requested family group.

### Android build issues
- Run:
  ```bash
  npx expo doctor
  ```
- Ensure Android SDK path and Java version are correct.

---

## 11) Notes for Developers

- Existing Flutter implementation was removed in favor of this React Native codebase.
- The code currently emphasizes a clear, minimal architecture to make feature extension easier.
- Suggested next enhancements:
  - navigation stack (Auth screen / Home / Members)
  - form validation layer (e.g. zod)
  - optimistic UI updates
  - e2e tests (Detox)
  - push notifications for invites/item changes

