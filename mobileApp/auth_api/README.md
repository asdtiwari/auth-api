# 📱 Smartphone Application – Password-less Authentication

## Features

### 1. **Account Setup / MFA Setup**
- QR Code scanning (to bind website account → smartphone).
- Secure storage of encrypted credentials (username, salted password/device fingerprint).
- Communication with API Server for validation and setup.
- Receive & display verification PIN for account activation.

### 2. **Password-less Login**
- Receive login requests (push notification from API Server).
- Show authentication request popup: **Login / Deny**.
- Biometric Authentication (Fingerprint / Face ID).
- Fallback authentication using PIN if biometrics unavailable.
- Send authentication response (approve/deny) back to API Server.

### 3. **Security & Device Binding**
- Device fingerprinting (unique smartphone identifiers).
- Secure credential storage (AES-256, secure storage).
- Encrypted communication (TLS 1.3).
- PIN & biometric fallback mechanisms.

### 4. **Session & Token Management**
- Handle authentication tokens (JWT).
- Auto session expiry handling (e.g., inactivity timeout).
- Support session/token revocation (if user/device compromised).

### 5. **Notifications & Alerts**
- Receive instant login approval/denial requests.
- Security alerts (e.g., suspicious login attempt, multiple failures).
- Session expiration/logout notifications.

### 6. **Fallback & Recovery**
- PIN-based login when biometrics unavailable.
- Device re-registration (if app is reinstalled or device is changed).
- Option to revoke sessions from app if user suspects compromise.

---

## ⚙️ Workflow of Smartphone Application

### **1. Account Creation & MFA Setup**
1. User creates an account on Website → QR Code generated.
2. User scans QR Code using Smartphone App.
3. App extracts credentials + device fingerprint → sends securely to API Server.
4. Server validates → stores in hashed/salted form.
5. Server generates PIN → sent to app & website.
6. User enters PIN on Website → account setup completed.

---

### **2. Password-less Login Process**
1. User enters **username** on Website → Login request sent to API Server.
2. API Server pushes **login request notification** to Smartphone App.
3. Smartphone App shows **popup → Login / Deny**.
4. If **Login**:
   - User verifies identity via **biometric/PIN**.
   - App sends approval response → API Server → Website access granted.
5. If **Deny**:
   - App sends denial response → Website redirects to homepage.

---

### **3. Security Management**
- Credentials → **AES-256 encrypted** on device.
- Transmission → **TLS 1.3 secured**.
- Session tokens (JWT) with expiry & revocation.
- Rate limiting + brute-force protection in background.
- Automatic logout if session/token expired or revoked.

---

## Key Components Overview

- **Website**: Handles UI (account creation, login).
- **API Server**: Acts as the bridge between the website and smartphone app.
- **Smartphone App**: Responsible for authentication authority (biometric, PIN, approve/deny).

---

# Project Structure

```
lib/
│
├── main.dart                # Entry point of the app
│
├── core/                    # Core utilities, constants, and shared logic
│   ├── constants/           # App-wide constants (API URLs, keys, etc.)
│   │   ├── api_endpoints.dart
│   │   ├── app_strings.dart
│   │   └── app_colors.dart
│   ├── errors/              # Error handling classes
│   │   └── exceptions.dart
│   ├── utils/               # Common utility functions
│   │   ├── app_theme.dart
│   │   └── app_text_styles.dart
│   └── theme/               # App-wide themes, colors, typography
│       ├── validators.dart
│       ├── encryption_util.dart
│       └── logger.dart
│
├── data/                    # Data layer (API, DB, storage)
│   ├── models/              # Data models (User, Session, DeviceFingerprint, etc.)
│   │   ├── user_model.dart
│   │   ├── session_model.dart
│   │   └── device_fingerprint.dart
│   ├── services/            # API services (REST, notifications, etc.)
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   └── notification_service.dart
│   └── storage/             # Secure storage, shared preferences, etc.
│       ├── secure_storage.dart
│       └── local_storage.dart
│
├── features/                # App features (modular approach)
│   ├── account_setup/       # MFA & QR Code scanning flow
│   │   ├── screens/         # Screens related to account setup
│   │   │   ├── welcome_screen.dart
│   │   │   ├── qr_scan_screen.dart
│   │   │   ├── pin_display_screen.dart
│   │   │   └── setup_success_screen.dart
│   │   ├── widgets/         # UI widgets (QR scanner, forms, etc.)
│   │   │   ├── qr_scanner_widget.dart
│   │   │   └── pin_card_widget.dart
│   │   └── bloc/            # State management (Bloc/Provider/Cubit)
│   │       └── account_setup_cubit.dart
│   │
│   ├── login/               # Password-less login flow
│   │   ├── screens/         # Login approval, biometric prompt, deny option
│   │   │   ├── login_request_screen.dart
│   │   │   ├── biometric_auth_screen.dart
│   │   │   ├── pin_auth_screen.dart
│   │   │   └── login_result_screen.dart
│   │   ├── widgets/         # Login-related widgets (popups, buttons)
│   │   │   ├── approve_deny_buttons.dart
│   │   │   ├── biometric_prompt_widget.dart
│   │   │   └── pin_input_widget.dart
│   │   └── bloc/            
│   │       └── login_cubit.dart
│   │
│   ├── security/            # Security-related modules
│   │   ├── biometrics/      # Biometric auth wrapper (Face ID, Fingerprint)
│   │   │   └── biometric_service.dart
│   │   ├── pin/             # PIN setup and validation
│   │   │   └── pin_service.dart
│   │   └── device/          # Device fingerprinting logic
│   │       └── device_fingerprint_service.dart
│   │
│   └── settings/            # User settings, session revocation, alerts
│       ├── screens/
│       │   ├── settings_screen.dart
│       │   ├── session_management_screen.dart
│       │   └── device_info_screen.dart
│       ├── widgets/
│       │   ├── session_tile_widget.dart
│       │   └── device_info_card.dart
│       └── bloc/
│           └── settings_cubit.dart
│
├── notifications/           # Push notification handling (login requests)
│   ├── fcm_handler.dart     # Firebase/notification setup
│   └── notification_utils.dart
│
├── routes/                  # App navigation (GoRouter or Named routes)
│   └── app_router.dart
│
├── localization/            # Multi-language support (if needed)
|   └── app_localizations.dart
│
└── di/                      # Dependency injection setup (GetIt, Riverpod, etc.)
    └── service_locator.dart
```

---

# 📱 Feature → Workflow → Screens Mapping

## 1️⃣ **Account Setup (MFA & QR Scan Flow)**

### **Workflow**

1. User installs app → sees **Welcome Screen**.
2. User scans **QR Code** shown on website.
3. App extracts credentials + device fingerprint.
4. Securely sends data to API server.
5. Receives **PIN** → shows on app.
6. User enters PIN on website → setup complete.

### **Screens & Widgets**

#### Screens:
* `WelcomeScreen` → simple screen with **Get Started** button.
* `QrScanScreen` → QR Code scanner (using `qr_code_scanner` or `mobile_scanner`).
* `PinDisplayScreen` → shows generated PIN.
* `SetupSuccessScreen` → confirmation that account setup is done.

#### Widgets:
* `QrScannerWidget` → re-usable scanner widget.
* `PinCardWidget` → card to display PIN securely.

---

## 2️⃣ **Password-less Login**

### **Workflow**

1. User enters username on website → API triggers **Push Notification**.
2. App receives notification → opens **Login Request Popup**.
3. App asks for **Biometric (Face/Fingerprint)** or fallback **PIN**.
4. If approved → API validates and website login is successful.
5. If denied → request rejected.

### **Screens & Widgets**

#### Screens:
* `LoginRequestScreen` → shows “Approve / Deny” login popup.
* `BiometricAuthScreen` → fingerprint/face authentication.
* `PinAuthScreen` → fallback PIN entry.
* `LoginResultScreen` → success/failure message.

#### Widgets:
* `ApproveDenyButtons` → for login approval/denial.
* `BiometricPromptWidget` → fingerprint/face prompt.
* `PinInputWidget` → secure PIN input.

---

## 3️⃣ **Security & Device Binding**

### **Workflow**

* Device fingerprinting on setup.
* Store credentials in **secure storage**.
* Encrypt all sensitive data before sending.

### **Screens & Widgets**

* No direct UI → handled in background service.
* `DeviceSecurityService` (under `features/security/device/`).

---

## 4️⃣ **Settings / Account Management**

### **Workflow**

1. User can view current **bound device info**.
2. Revoke sessions (logout all active sessions).
3. Reset/re-register device if lost/reinstalled.

### **Screens & Widgets**

#### Screens:
* `SettingsScreen` → main settings page.
* `SessionManagementScreen` → revoke sessions.
* `DeviceInfoScreen` → show device fingerprint & binding status.

#### Widgets:
* `SessionTileWidget` → list of active sessions.
* `DeviceInfoCard` → device binding info.

---

## 5️⃣ **Notifications (Login Requests)**

### **Workflow**

* API sends push notification → App intercepts.
* Routes user to **LoginRequestScreen**.

### **Files**

* `notifications/fcm_handler.dart` → FCM initialization.
* `notifications/notification_utils.dart` → handling background/foreground notifications.

---

# 🔑 Implementation Roadmap

We’ll build features step by step:

1. **Account Setup (QR Scan Flow)** → starting point.
2. **Login Flow (Approve/Deny with Biometric/PIN)**.
3. **Push Notifications (FCM integration)**.
4. **Settings & Session Management**.
5. **Security Layer (Encryption, Secure Storage, Device Fingerprinting)**.

---
