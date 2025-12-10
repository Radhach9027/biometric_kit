# 🔐 biometric_kit

`biometric_kit` is a **fully generic, production-ready Flutter package**
that provides **secure biometric authentication** using **Face ID /
Touch ID / Fingerprint** across **iOS and Android**.

It is designed to be: - ✅ Loosely coupled
- ✅ Privacy-first & secure
- ✅ Industry-standard UX flow
- ✅ Plug & play
- ✅ Scalable
- ✅ Clean Architecture friendly

------------------------------------------------------------------------

## ✅ What Problems This Solves

-   Enable Face ID / Fingerprint only after successful login
-   Store per-user biometric preference securely
-   Perform quick biometric login on next app launch
-   Handle device support, permission errors, and fallback login
-   Work seamlessly across iOS & Android

------------------------------------------------------------------------

## 🚀 Typical Industry Flow

1.  User logs in via Password / OTP
2.  App asks: "Enable Face ID?"
3.  User accepts → biometric enabled
4.  Next launch → auto biometric login
5.  If fails → fallback to normal login

------------------------------------------------------------------------

## ✅ Initialization Example

``` dart
import 'package:flutter/widgets.dart';
import 'package:biometric_kit/biometric_kit.dart';
import 'package:biometric_kit/src/platform/secure_storage_biometric_preference_store.dart';

late final BiometricPreferenceStore biometricPrefStore;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BiometricKit.localAuth();
  biometricPrefStore = SecureStorageBiometricPreferenceStore();
  runApp(const MyApp());
}
```

------------------------------------------------------------------------

## ✅ Enable Biometric After Login

``` dart
Future<void> onLoginSuccess(String userId) async {
  final bool shouldEnable = await showEnableBiometricSheet();
  if (!shouldEnable) return;

  final manager = BiometricLoginManager(
    userId: userId,
    preferenceStore: biometricPrefStore,
  );

  await manager.enableBiometricLogin(
    reason: 'Use Face ID to login faster next time.',
    kind: BiometricKind.any,
  );
}
```

------------------------------------------------------------------------

## ✅ Quick Login on App Start

``` dart
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
    // Navigate to home
  }
}
```

------------------------------------------------------------------------

## 🧑‍💻 Author  

**Ch. Radhachandan**  
Mobile Architect | iOS | Flutter | Clean Architecture Enthusiast  
📍 Hyderabad, India.
