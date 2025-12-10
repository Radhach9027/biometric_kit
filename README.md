# 🔐 biometric_kit

`biometric_kit` is a **fully generic, production-ready Flutter package**
that provides **secure biometric authentication** using **Face ID /
Touch ID / Fingerprint** across **iOS and Android**.

It is designed to be:

- ✅ Loosely coupled  
- ✅ Privacy-first & secure  
- ✅ Industry-standard UX flow  
- ✅ Plug & play  
- ✅ Scalable  
- ✅ Clean Architecture friendly  

---

## ✅ What Problems This Solves

- Enable Face ID / Fingerprint **only after successful login**
- Store **per-user biometric preference** securely
- Perform **quick biometric login** on next app launch
- Handle **device support, permission, and error cases**
- Work seamlessly across **iOS & Android**

---

## 🚀 Typical Industry Flow

1. User logs in via **Password / OTP**
2. App asks: **“Enable Face ID / fingerprint?”**
3. User accepts → biometric login **enabled**
4. Next launch → app tries **biometric quick login**
5. If it fails → fallback to **normal login screen**

---

## ✅ Initialization Example

> Call this once in `main()`.

```dart
import 'package:flutter/widgets.dart';
import 'package:biometric_kit/biometric_kit.dart';

late final BiometricPreferenceStore biometricPrefStore;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use local_auth implementation under the hood (iOS + Android)
  BiometricKit.localAuth();

  // Store user preference securely using flutter_secure_storage
  biometricPrefStore = SecureStorageBiometricPreferenceStore();

  runApp(const MyApp());
}
```

---

## ✅ Enable Biometric After Login

Call this **right after** a successful password / OTP login:

```dart
Future<void> onLoginSuccess(String userId) async {
  // Optional: read capabilities for better copy like "Face ID" vs "fingerprint"
  final caps = await BiometricKit.I.getCapabilities();
  final label = caps.preferredLabel(); // "Face ID" / "fingerprint" / "biometrics"

  final bool shouldEnable = await showEnableBiometricSheet(
    title: 'Use $label for quicker login?',
    message: 'Next time you can log in using $label instead of OTP.',
  );

  if (!shouldEnable) return;

  final manager = BiometricLoginManager(
    userId: userId,
    preferenceStore: biometricPrefStore,
  );

  await manager.enableBiometricLogin(
    reason: 'Use $label to login faster next time.',
    kind: BiometricKind.any,
  );
}
```

---

## ✅ Quick Login on App Start

At app startup (e.g. in splash / auth gate), try biometric login:

```dart
Future<void> tryQuickLogin(String userId) async {
  final manager = BiometricLoginManager(
    userId: userId,
    preferenceStore: biometricPrefStore,
  );

  final bool success = await manager.tryBiometricLogin(
    reason: 'Confirm it’s you',
    kind: BiometricKind.any,
  );

  if (success) {
    // ✅ Biometric auth passed → navigate to home
    // navigator.pushReplacementNamed('/home');
  } else {
    // ❌ Fallback → show normal login (password / OTP)
    // navigator.pushReplacementNamed('/login');
  }
}
```

---

## 🔒 Security Notes

- `biometric_kit` does **not** store passwords or tokens by itself.
- The `SecureStorageBiometricPreferenceStore` uses `flutter_secure_storage`
  under the hood, which relies on:
  - **iOS** → Keychain (encrypted, hardware-backed when available)  
  - **Android** → EncryptedSharedPreferences + Keystore  
- You decide **what** to store (e.g. “biometrics enabled” flag, user id,
  or an app-level token indirection).

---

## 🧑‍💻 Author

**Ch. Radhachandan**  
Mobile Architect | iOS | Flutter | Clean Architecture Enthusiast  
📍 Hyderabad, India.
