# AuthAPI: Passwordless Authenticator

## Index

- [Index](#index)
- [Project Overview](#project-overview)
- [Motivation and Objectives](#motivation-and-objectives)
- [Methodology/Approach](#methodologyapproach)
- [Installation and Setup](#installation-and-setup)
- [How to Run/Usage](#how-to-runusage)
- [Future Scope](#future-scope)
- [Contributors](#contributors)
- [Conclusion](#conclusion)

---

## Project Overview

**Title**: AuthAPI  
**Type**: Passwordless Authenticator  
**Abstract**: AuthAPI is designed to simplify the integration of passwordless authentication for developers. By utilizing just two API endpoints and making minimal UI adjustments, developers can seamlessly implement a secure and modern authentication flow.  
**Keywords**: Flutter, Spring Boot, REST APIs, Duck DNS, Git, GitHub  

---

## Motivation and Objectives

### Problem Statement
“Platforms like Google, Microsoft, and GitHub employ in-app verification codes to enable Multi-Factor Authentication (MFA) for enhanced user security. However, developers who wish to implement similar functionality must typically build it from scratch. AuthAPI offers a ready-to-use solution that allows developers to achieve this by simply calling two API endpoints and making slight modifications to their user interface.”

### Motivation/Background
- A single password is often vulnerable to risks such as breaches and brute-force attacks.  
- Multi-Factor Authentication (MFA) adds an extra security layer to strengthen the authentication process.  
- Current MFA methods and their drawbacks include:  
  - **Multiple password layers**: Strengthen authentication but are inconvenient since users must remember multiple passwords.  
  - **OTP-based SMS/Email systems**: Eliminate the need for multiple passwords but are often costly and prone to delays.  
  - **Authenticator apps**: Overcome cost and delay issues by generating OTPs locally, but since these apps rely on login-based systems, they can be accessed from multiple devices—introducing potential security risks.  
  - **Password with biometrics**: Ensures that only the legitimate user can authenticate, but requires storing sensitive biometric data, which not all users are comfortable sharing.  

Since each existing model has its pros and cons, there is a need for a unified system that can mitigate these challenges effectively.

### Goals
- Develop a system that leverages user fingerprinting without storing or transmitting any personal or sensitive information.  
- Create a solution that enhances authentication trust while remaining simple and user-friendly.  
- Design a system that requires minimal coding effort and is easy to integrate.  
- Ensure accessibility for developers, enabling quick and seamless implementation.  

---

## Methodology/Approach

### Overview of Approach
- We propose an **integrated authentication system** that verifies not the user directly, but one of their **primary devices — the smartphone**.  
- The system leverages the **UDID (Unique Device Identifier)** concept from Flutter along with **device fingerprinting** to generate a unique **hash code**. This hash is then used for secure transmission and storage. By relying on this approach, all sensitive information remains on the user’s device, ensuring that no critical data is transmitted externally.
- The **Flutter UDID** provides a safe and reliable way to identify a specific instance of an application on a device. While it does not guarantee device-level uniqueness, it ensures **application-level uniqueness** — meaning the UDID remains consistent unless the device is rooted. Even if the app is uninstalled and reinstalled, the UDID remains the same. Additionally, cloned applications receive a different UDID, maintaining the integrity of the identification process.
- Using the generated hash code, the system securely binds user data (such as **username** and **platform URL**) to the server. Users of the client platform first **register** their device through this process. Once registered, they can **log in without requiring a password**, leveraging their device’s identity instead.
- A detailed explanation of the flow of exectution can be found in the section [How to Run/Usage](#how-to-runusage).

### Tools & Technologies
- Flutter
- Dart
- Spring Boot
- Java
- Git
- GitHub
- Postman
- VS Code
- Android Studio

### Assumptions/Constraints
State any limitations or assumptions

### Folder Structure
```
AuthAPI/
├── app/                                # Flutter mobile client application
│   └── auth_api/
│       ├── android/                    # Android-specific project configuration (build.gradle, manifest, etc.)
│       ├── ios/                        # iOS-specific project configuration (Xcode project, Info.plist)
│       ├── linux/                      # Linux build configuration
│       ├── macos/                      # macOS build configuration
│       ├── web/                        # Web target for Flutter app
│       ├── windows/                    # Windows build configuration
│       |
│       ├── assets/
│       │   └── images/
│       │       └── logo.png            # App logo displayed on splash and login screens
│       |
│       ├── lib/                        # Core Dart source code
│       │   ├── core/                   # Core reusable parts shared across app features
│       │   │   ├── constants/          # Global constants and configurations
│       │   │   │   ├── api_endpoints.dart   # Centralized API endpoint definitions
│       │   │   │   ├── app_config.dart      # App-wide environment configurations (e.g., base URLs)
│       │   │   │   └── secure_keys.dart     # Sensitive key constants (e.g., encryption secrets)
│       │   │   │
│       │   │   ├── theme/              # App-wide theming
│       │   │   │   ├── app_colors.dart       # Defines the color palette
│       │   │   │   ├── app_text_styles.dart  # Defines text style constants
│       │   │   │   ├── app_theme.dart        # Combines color and text into the Material theme
│       │   │   │   └── theme_manager.dart    # Handles light/dark theme switching
│       │   │   │
│       │   │   └── utils/              # Helper utility classes
│       │   │       ├── encryption_utils.dart # Data encryption/decryption helpers
│       │   │       └── network_utils.dart    # Network connectivity and request helpers
│       │   │
│       │   ├── data/                   # Data layer (models, services, and storage)
│       │   │   ├── models/             # Data models for API requests/responses
│       │   │   │   ├── login_request_model.dart  # Model for login request payload
│       │   │   │   └── registration_payload.dart # Model for registration data
│       │   │   │
│       │   │   ├── services/           # Handles data fetching, device access, and API integration
│       │   │   │   ├── auth_service.dart          # Authentication logic and token handling
│       │   │   │   ├── biometric_services.dart    # Biometric authentication (fingerprint/face)
│       │   │   │   ├── device_service.dart        # Device info and security checks
│       │   │   │   └── login_request_service.dart # Handles server-side login request actions
│       │   │   │
│       │   │   └── storage/
│       │   │       └── secure_storage.dart        # Secure local storage for data
│       │   │
│       │   ├── features/               # Modularized app features
│       │   │   ├── about/
│       │   │   │   └── screens/
│       │   │   │       ├── about_screen.dart      # Displays app info and version
│       │   │   │       └── privacy_screen.dart    # Displays privacy policy
│       │   │   │
│       │   │   ├── common/
│       │   │   │   └── widgets/
│       │   │   │       ├── app_button.dart        # Reusable custom button widget
│       │   │   │       ├── info_dialog.dart       # Standard info dialog box
│       │   │   │       └── pin_pad_widget.dart    # Reusable numeric keypad for PIN input
│       │   │   │
│       │   │   ├── home/
│       │   │   │   ├── screens/
│       │   │   │   │   └── home_screen.dart       # Main dashboard after login
│       │   │   │   └── widget/
│       │   │   │       └── home_menu_tile.dart    # Widget for home screen menu items
│       │   │   │
│       │   │   ├── login_request/
│       │   │   │   ├── screens/
│       │   │   │   │   └── login_request_screen.dart # Displays pending login requests
│       │   │   │   └── widgets/
│       │   │   │       ├── approve_deny_buttons.dart # Approve/Deny action buttons
│       │   │   │       └── request_card.dart          # Card widget displaying login request details
│       │   │   │
│       │   │   ├── pin_change/
│       │   │   │   └── screens/
│       │   │   │       ├── pin_change_screen.dart     # UI to change existing PIN
│       │   │   │       └── pin_verify_screen.dart     # PIN verification screen before change
│       │   │   │
│       │   │   ├── registration/
│       │   │   │   ├── screens/
│       │   │   │   │   ├── qr_scan_screen.dart        # QR scanning for device registration
│       │   │   │   │   ├── registration_progress_screen.dart # Shows registration progress
│       │   │   │   │   └── registration_result_screen.dart   # Displays registration success/failure
│       │   │   │   └── widgets/
│       │   │   │       └── qr_scanner_widget.dart     # QR code scanner reusable widget
│       │   │   │
│       │   │   ├── setup/
│       │   │   │   └── screen/
│       │   │   │       ├── app_lock_screen.dart       # Lock screen UI after app inactivity
│       │   │   │       ├── biometric_setup_screen.dart# Biometric setup during onboarding
│       │   │   │       └── pin_setup_screen.dart      # Screen for setting up a new PIN
│       │   │   │
│       │   │   └── unregister/
│       │   │       └── screen/
│       │   │           ├── unregister_confirm_screen.dart # Confirmation screen for unregister action
│       │   │           └── unregister_result_screen.dart  # Displays unregister success/failure
│       │   │
│       │   └── main.dart                  # App entry point
│       |
│       ├── test/
│       │   └── widget_test.dart           # Unit and widget testing
│       |
│       ├── .gitattributes                 # Git file attribute settings
│       ├── .gitignore                     # Ignore unnecessary files in version control
│       ├── .metadata                      # Flutter project metadata
│       ├── analysis_options.yaml          # Linting and static analysis rules
│       ├── pubspec.lock                   # Locked dependency versions
│       └── pubspec.yaml                   # Flutter project dependencies and assets
│
└── server/                               # Spring Boot backend API
    └── server/
        ├── .mvn/wrapper/                 # Maven wrapper files for consistent build
        │   └── (Maven wrapper binaries)
        │
        ├── src/
        │   ├── main/java/com/authapi/server/
        │   │   ├── controllers/           # REST controllers to handle API requests
        │   │   │   ├── ApiController.java     # Handles authentication and registration endpoints
        │   │   │   └── ViewController.java    # Serves static HTML views (for testing or registration)
        │   │   │
        │   │   ├── entities/              # JPA entity classes representing database tables
        │   │   │   ├── LoginRequest.java
        │   │   │   └── Registration.java
        │   │   │
        │   │   ├── repositories/          # Database repositories (DAO interfaces)
        │   │   │   ├── LoginRequestRepository.java
        │   │   │   └── RegistrationRepository.java
        │   │   │
        │   │   ├── security/
        │   │   │   └── SecurityConfig.java # Spring Security configuration
        │   │   │
        │   │   ├── services/
        │   │   │   ├── AppServices.java                # App Service Interface
        │   │   │   ├── AppServicesImplementation.java  # Codes for serving mobile application
        │   │   │   ├── ServerServices.java             # Server Service Interface
        │   │   │   └── ServerServicesImplementation.java # Codes for serving server
        │   │   │
        │   │   ├── utils/                 # Helper utilities for server logic
        │   │   │   ├── CryptoUtils.java         # General cryptographic helper functions
        │   │   │   ├── EncryptionUtils.java     # Data encryption/decryption logic
        │   │   │   ├── QrCodeGenerator.java     # QR code creation for registration
        │   │   │   └── TempDatabase.java        # Temporary in-memory data storage
        │   │   │
        │   │   └── ServerApplication.java       # Spring Boot main application entry point
        │   │
        │   ├── resources/
        │   │   ├── META-INF/
        │   │   │   └── additional-spring-configuration-metadata.json # Additional Spring config metadata
        │   │   │
        │   │   ├── static/                # Static web assets (HTML, CSS, JS)
        │   │   │   ├── images/
        │   │   │   ├── error.html
        │   │   │   ├── index.html
        │   │   │   ├── registration.html
        │   │   │   └── test.html
        │   │   │
        │   │   └── application.properties # Main Spring Boot configuration file
        │   │
        │   └── test/java/com/authapi/server/
        │       └── ServerApplicationTests.java # Unit tests for backend
        │
        ├── .gitignore                     # Git ignore file for backend
        ├── mvnw                           # Unix Maven wrapper
        ├── mvnw.cmd                       # Windows Maven wrapper
        └── pom.xml                        # Maven project configuration (dependencies/build)
```

### Dependencies

This project consists of two main parts:

1. **Backend:** A Spring Boot application serving the authentication API.  
2. **Frontend:** A Flutter application providing the user interface for passwordless login.

Below is a breakdown of the dependencies used in each module.

---

### ⚙️ Backend — Spring Boot (Maven)

**Java Version:** `17`  
**Parent:** `spring-boot-starter-parent:3.5.7`

#### Core Dependencies

| Dependency | Description |
|-------------|--------------|
| **spring-boot-starter-data-jpa** | Provides Spring Data JPA for database access and ORM integration. |
| **spring-boot-starter-validation** | Adds validation support for request and entity data using JSR-303/JSR-380 annotations. |
| **spring-boot-starter-web** | Enables building RESTful web services and includes Spring MVC. |
| **spring-boot-starter-security** | Provides authentication and authorization features for securing the API. |
| **spring-boot-devtools** | Offers automatic restarts and enhanced development experience. *(Runtime, optional)* |
| **mysql-connector-j** | MySQL database driver for connecting to a MySQL instance. *(Runtime)* |
| **lombok** | Reduces boilerplate code with annotations like `@Getter`, `@Setter`, etc. *(Optional)* |
| **jackson-datatype-jsr310** | Adds support for Java 8+ date/time types during JSON serialization/deserialization. |
| **zxing-core** | Core library for QR code and barcode generation/scanning. *(Version 3.5.3)* |
| **zxing-javase** | Java SE extension of ZXing for working with images and streams. *(Version 3.5.3)* |
| **spring-boot-starter-test** | Includes JUnit, Mockito, and Spring Test for unit and integration testing. *(Test scope)* |

#### Build Plugins

| Plugin | Purpose |
|---------|----------|
| **maven-compiler-plugin** | Configures Java compilation and Lombok annotation processing. |
| **spring-boot-maven-plugin** | Provides Spring Boot packaging, running, and repackage capabilities. |

---

### 💡 Frontend — Flutter (pubspec.yaml)

**Flutter SDK Version:** `^3.9.2`  
**App Name:** `auth_api`  
**Description:** Application supporting passwordless login.

#### Main Dependencies

| Package | Version | Purpose |
|----------|----------|----------|
| **flutter** | — | Core Flutter SDK for UI development. |
| **cupertino_icons** | ^1.0.8 | iOS-style icons for the app. |
| **flutter_secure_storage** | ^9.2.4 | Secure storage for tokens and sensitive data. |
| **device_info_plus** | ^12.1.0 | Retrieves device-specific information. |
| **flutter_udid** | ^4.0.0 | Generates unique device identifiers. |
| **encrypt** | ^5.0.3 | Encryption/decryption utilities for secure communication. |
| **crypto** | ^3.0.6 | Cryptographic hashing and encoding functions. |
| **google_fonts** | ^6.3.2 | Integrates Google Fonts for custom typography. |
| **connectivity_plus** | ^7.0.0 | Checks network connectivity status. |
| **get_ip_address** | ^0.0.7 | Retrieves the device’s IP address. |
| **local_auth** | ^2.3.0 | Enables biometric authentication (Face ID, Touch ID, etc.). |
| **mobile_scanner** | ^7.1.2 | Provides barcode/QR code scanning capabilities. |
| **http** | ^1.5.0 | Handles HTTP requests and API calls. |

#### Development Dependencies

| Package | Version | Purpose |
|----------|----------|----------|
| **flutter_launcher_icons** | ^0.14.4 | Generates launcher icons for Android and iOS. |
| **flutter_native_splash** | ^2.4.6 | Configures and generates splash screens. |
| **flutter_test** | — | Testing framework provided by Flutter SDK. |
| **flutter_lints** | ^5.0.0 | Provides recommended lint rules for Dart/Flutter code style. |

#### Additional Configurations

- **Launcher Icons:** Automatically generated using `flutter_launcher_icons`.
- **Splash Screen:** Custom splash screen configured via `flutter_native_splash`.
- **Assets:**  
  - `assets/images/logo.png`
  
---

## Installations and Setup

### Requirements
Dependencies, Python version, libraries, etc.

### Installation Steps
How to clone, set up environment, and run the project.

### Configuration
Any config files, paths, or environment variables needed

---

## How to Run/Usage

---

## Future Scope

---

## Contributors
- List your name and any collaborators
- Mention supervisor/advisor if it's a research project

---

## Conclusion

---