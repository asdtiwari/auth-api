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

The development of **AuthAPI** integrates a combination of modern frameworks, programming languages, and developer tools to ensure a seamless, secure, and efficient implementation of passwordless authentication. Each tool was carefully selected to address a specific component of the system—ranging from backend security and database management to frontend usability and testing.


#### **Core Technologies**

##### **Frontend**
- **Flutter & Dart** — Flutter serves as the primary framework for building the cross-platform mobile client. It provides a reactive UI and native-like performance, while Dart offers efficient asynchronous programming for handling network operations and local device processing.
- **Android Studio & VS Code** — Used for development, debugging, and testing of the Flutter mobile application.  
- **Flutter Packages** —  
  - `flutter_secure_storage`: Manages secure local data storage such as encrypted tokens.  
  - `flutter_udid`: Generates a unique device identifier for user-device binding.  
  - `local_auth`: Provides biometric and device-based authentication (e.g., fingerprint, Face ID).  
  - `http` and `encrypt`: Enable secure data transmission and cryptographic operations between the client and server.  


##### **Backend**
- **Spring Boot (Java 17)** — Powers the RESTful API responsible for user registration, device verification, and authentication logic. The framework offers modularity, security, and fast development cycles.
- **Spring Security** — Implements token-based security and user verification layers to ensure API protection.
- **Spring Data JPA (Hibernate)** — Facilitates database management, ORM mapping, and streamlined access to persistent storage.
- **MySQL** — Used as the primary relational database for storing user and device authentication data.
- **ZXing Library** — Generates and scans QR codes for device registration and authentication binding.


##### **Development and Version Control**
- **Git & GitHub** — Used for version control, collaborative development, and repository management.  
- **Postman** — Assists in testing and validating the REST API endpoints during development.  


#### **Additional Development Tools**
- **Lombok** — Simplifies Java backend development by reducing boilerplate code for data classes.  
- **Google Fonts & Cupertino Icons** — Enhance the frontend interface with polished typography and consistent icons.  
- **Connectivity Plus** — Ensures real-time network checks for authentication-related actions.  
- **Mobile Scanner** — Enables scanning of QR codes during device verification flow.  

Collectively, these technologies ensure that **AuthAPI** remains lightweight, maintainable, and easily extensible while adhering to modern development practices for secure authentication systems.


### Assumptions and Constraints  

While designing and implementing **AuthAPI**, several foundational assumptions and constraints were established to ensure the system’s functionality, reliability, and security. These assumptions define the expected environment in which the solution will operate effectively and the boundaries that govern its implementation.  


#### **Assumptions**  

1. **Smartphone Ownership and Reliability**  
   - It is assumed that each user possesses at least one **smartphone** that is both personal and securely maintained.  
   - Smartphones are considered one of the most **trustworthy and secure personal devices**, as they are typically protected by built-in security mechanisms such as PINs, patterns, biometrics, or face recognition.  

2. **Device as a Primary Identity Source**  
   - The system assumes that a user’s **mobile device** can reliably represent their digital identity.  
   - Device-based identification, combined with a unique **application-level UDID**, ensures that authentication remains consistent across sessions unless the device undergoes critical modifications (e.g., rooting or factory reset).  

3. **User Consent and Data Privacy**  
   - Any data required for registration or authentication is collected **only with the user’s explicit consent**.  
   - The system assumes that users are informed about what information is being utilized and agree to share only non-sensitive identifiers.  
   - **No personally identifiable information (PII)** or biometric data is stored or transmitted externally; all sensitive operations occur locally on the device.  

4. **App Lock and Local Security**  
   - Users are responsible for maintaining the confidentiality of their **in-app lock password** or equivalent local security mechanism.  
   - It is assumed that users will not share access credentials or leave their devices unsecured, as this could compromise authentication integrity.  

5. **Network Availability**  
   - Since registration and verification involve communication with a remote API server, a **stable internet connection** is assumed during both setup and authentication processes.  

6. **Developer Compliance**  
   - Developers integrating AuthAPI are assumed to follow the **recommended implementation practices** and not modify the security-related configurations that ensure passwordless authentication works as intended.  


#### **Constraints**  

1. **Profile Deletion Policy**  
   - The current system design does not support the deletion of individual login bindings.  
   - Instead, users can only delete their **entire profile** from the server, which simultaneously removes all associated device bindings.  

2. **UDID Limitations**  
   - The UDID used for device identification ensures **application-level uniqueness**, not absolute device-level uniqueness.  
   - This constraint is acceptable within the scope of the project, as the risk of duplication is minimal for standard app installations.  

3. **Rooted or Cloned Devices**  
   - Devices that are **rooted**, **cloned**, or modified at the system level may produce inconsistent UDIDs or security vulnerabilities.  
   - AuthAPI assumes that users operate on **standard, non-rooted devices** for accurate and secure authentication.  

4. **Limited Offline Functionality**  
   - While certain security validations occur locally, the overall authentication process requires **server interaction** and thus cannot function fully offline.  

These assumptions and constraints collectively ensure that **AuthAPI** remains secure, efficient, and easy to implement, providing a dependable passwordless authentication mechanism while upholding user privacy and developer convenience.


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


### Backend — Spring Boot (Maven)

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


### Frontend — Flutter (pubspec.yaml)

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


## Installation and Setup

This section outlines the step-by-step process to install, configure, and run the **AuthAPI** system—covering both backend (Spring Boot) and frontend (Flutter) components.

### **System Requirements**

Before proceeding, ensure that your system meets the following prerequisites:

| Component | Requirement |
|------------|-------------|
| **Operating System** | Windows 10/11, macOS, or Linux |
| **Java Development Kit (JDK)** | Version 17 or above |
| **Flutter SDK** | Version 3.9.2 or above |
| **Android Studio or VS Code** | For running and debugging the Flutter app |
| **MySQL Server** | Version 8.0 or above |
| **Postman** | For API testing (optional) |
| **Git** | For repository cloning and version control |

### **Backend Installation (Spring Boot)**

1. **Clone the Repository**
    ```
    git clone https://github.com/asdtiwari/auth-api.git
    ```

2. **Navigate to server folder**
    ```
    cd server/server
    ```

3. **Set Up MySQL Database**

   Open your MySQL terminal or GUI tool and create a new database:
    ```
    CREATE DATABASE authapi_db;
    ```
   Note down your database credentials (username, password, host).

4. **Configure Application Properties**

   Navigate to `src/main/resources/application.properties` and update the following values:
    ```
    spring.datasource.url=jdbc:mysql://localhost:3306/authapi_db
    spring.datasource.username=your_mysql_username
    spring.datasource.password=your_mysql_password
    spring.jpa.hibernate.ddl-auto=update
    spring.jpa.show-sql=true
    server.port=8080
    ```
5. **Build and Run the Application**

    ```
    .\mvnw clean install
    .\mvnw spring-boot:run
    ```
   The backend server will start at:  
   http://localhost:8080


### **Frontend Installation (Flutter App)**

1. **Navigate to the Frontend Directory**
    ```
    cd ../..
    cd app/auth_api
    ```

2. **Install Flutter Dependencies**
    ```
    dart clean
    dart pub get
    ```

3. **Configure API Base URL**

   Locate the configuration file (e.g., lib/core/constants/api_endpoints.dart) and update the base URL to point to your backend server:
    ```
    const String baseUrl = "http://<your-local-ip>:8080";
    ```
   Use your machine’s local IP address instead of localhost if running on a real device.

4. **Run the Application**

   Connect a physical or virtual Android device and execute:
    ```
    flutter run
    ```
   The app will launch and allow device registration and passwordless authentication.  

   **OR**  
   Use the following command to get a release which can manually install on any device.  
   For android 
   ```
   flutter build apk --split-per-abi
   ```
   
   For ios
   ```
   flutter build ipa --release \
    --export-options-plist=$HOME/export_options.plist
   ```

### **Optional: Using DuckDNS for Persistent Base URL**

If you don't want change the ip again and again on both places (in app and server) you can use DuckDNS and there you have to make changes:

- Register a free subdomain at DuckDNS.org.
- Map it to your local server’s IP.
- Update the backend configuration (application.properties) and Flutter base URL with your DuckDNS domain.


### **Verification and Testing**

Once both the backend and frontend are running:
1. We have already provided a testing page which will available on hitting the backend server on any browser.
2. Open the Flutter app and register a new device.
3. Scan the QR code generated by the backend for authentication binding.
4. Attempt login without entering any password — the app should authenticate using the device identity.

### **Environment Variables Summary**

| Variable | Description |
|-----------|-------------|
| **DB_USER** | MySQL database username |
| **DB_PASS** | MySQL database password |
| **DB_NAME** | MySQL database name |
| **SERVER_PORT** | Backend server port (default: 8080) |
| **BASE_URL** | API base URL for Flutter frontend |

With this setup completed, AuthAPI should be fully operational, enabling seamless passwordless authentication through a secure, device-based identity verification process.

---

## How to Run/Usage

The **AuthAPI** system enables any client platform to adopt **passwordless authentication** using device-based registration and login.  
Integration involves two core steps: **Registration** and **Login**.  

A **test page** (linked from the server index page) demonstrates both flows using the live API endpoints.



### 1. Registration Flow

When a user clicks the **Register** button (from your platform or the test page), the system redirects to AuthAPI’s registration screen.

**Registration Page Endpoint:**  
`GET /registration-screen`  
**Base URL:** `http://project-auth-api.duckdns.org:9080/registration-screen`

#### Query Parameters (Data Delivered)

| Parameter | Type | Description |
|------------|------|-------------|
| `platformUrl` | String | The base URL of the platform integrating AuthAPI. |
| `username` | String | The unique username of the user on the client platform. |

**Example Request:**  
`http://project-auth-api.duckdns.org:9080/registration-screen?username=john_doe&platformUrl=https://myclientapp.com`



### 2. Server and Frontend Behavior

When the link is hit, the following sequence occurs:

1. **Session Initialization**  
   - The server captures `username` and `platformUrl` from the query parameters.  
   - It stores them in the user’s HTTP session and forwards the request internally to the registration page.

2. **Registration Page Execution**  
   - The page fetches session details through `/api/session-info`.  
   - It checks registration status using `/api/registration-status`.

3. **Registration Status Check**  
   - Endpoint: `GET /api/registration-status?username=<username>&platformUrl=<platformUrl>`  
   - **Response Values:**

     | Value | Meaning |
     |--------|----------|
     | `registered` | The user already has a registered device. |
     | `ERROR` | Server-side or session issue. |
     | `unregistered` | The user needs to register (default case). |

   - If the user is already registered, a warning message appears.  
   - If not, the page proceeds to the QR registration process.



### 3. QR Code Registration Process

If the user is not registered, the page displays a QR code that must be scanned by the user’s AuthAPI-compatible device.

1. **QR Generation Request**  
   - Endpoint: `POST /api/qr-code`  
   - **Request Body (Data Delivered):**

     | Field | Type | Description |
     |--------|------|-------------|
     | `username` | String | Username to register. |
     | `platformUrl` | String | The client platform’s URL. |

   - **Response (Data Received):**  
     A Base64-encoded PNG string representing the QR code.

2. **Polling for Registration Status**  
   - The page polls the endpoint `/api/registration-status` every 2 seconds.  
   - It continues until the response returns `registered`, indicating successful registration.

3. **Completion**  
   - Once registration is complete, the UI updates to show **✅ Login successful!**  
   - The device’s UDID and fingerprint are securely stored on the server for future passwordless logins.



### 4. Registration API (Triggered by Device)

When the QR code is scanned by the user’s device, it triggers the backend registration API.

**Endpoint:** `POST /api/register`

#### Request Body (Data Delivered)

| Field | Type | Description |
|--------|------|-------------|
| `ciphertext` | String | Encrypted JSON containing device and user details. |

After decryption, the JSON includes:

| Key | Description |
|------|--------------|
| `udid` | Unique device identifier. |
| `deviceFingerprint` | Device-specific fingerprint hash. |
| `platformUrl` | URL of the platform integrating AuthAPI. |
| `username` | Username of the user being registered. |

#### Response (Data Received)

| Message | Meaning |
|----------|----------|
| `success` | Registration completed successfully. |
| `Alert: Already Registered` | Device already linked to this user. |
| `Exception: <details>` | Registration error occurred. |



### 5. Login Flow

Once registered, the user can log in without passwords through their device or the test page.

**Login Endpoint:** `POST /api/login`

#### Request Body (Data Delivered)

| Field | Type | Description |
|--------|------|-------------|
| `username` | String | Username used during registration. |
| `platformUrl` | String | The same platform URL used during registration. |

#### Server Behavior

1. Validates whether a registration exists for the given username and platform.  
2. If found, a temporary login request is created and waits for device confirmation.  
3. The request remains valid until approval or session timeout.

#### Response (Data Received)

| Example Response | Meaning |
|------------------|----------|
| `approved` | Device verified successfully; login granted. |
| `Exception: Session Timeout.` | Login request expired before confirmation. |
| `Exception: Unregistered Yet. Please do registration for passwordless login.` | User is not registered yet. |



### 6. Data Flow Summary

| Step | Direction | Endpoint | Data Sent | Data Received |
|------|------------|-----------|------------|----------------|
| 1️⃣ Registration Screen | Client → Server | `/registration-screen` | Query: `username`, `platformUrl` | Redirects to registration page |
| 2️⃣ Check Registration Status | Client → Server | `/api/registration-status` | Query: `username`, `platformUrl` | `registered` / `unregistered` / `ERROR` |
| 3️⃣ Generate QR Code | Client → Server | `/api/qr-code` | JSON: `username`, `platformUrl` | Base64-encoded QR string |
| 4️⃣ Device Registration | Device → Server | `/api/register` | JSON: `ciphertext` | `success` / `Alert: Already Registered` |
| 5️⃣ Login | Client → Server | `/api/login` | JSON: `username`, `platformUrl` | `approved` / `Exception: Timeout` / `Unregistered Yet` |



### 7. Using the Test Page

The **test page link** (available in the Index page) allows you to test both flows directly:

- **Registration:** Opens `/registration-screen` and walks through QR-based registration.  
- **Login:** Sends a request to `/api/login` for passwordless access.

All interactions use the live server at:  
`http://project-auth-api.duckdns.org:9080`

This provides a ready-to-use demonstration of the authentication process.



### 8. Key Notes

- The combination of `platformUrl + username` uniquely identifies each user registration.  
- UDID and device fingerprint values are securely managed by AuthAPI — never exposed to clients.  
- Login requests are temporary and expire automatically after the configured duration.  
- The **test page link** is the simplest way to explore and validate the full passwordless flow in real time.

---

## Future Scope

The current implementation of **AuthAPI** establishes a robust foundation for secure, passwordless authentication using device-based identity verification.  
However, the project envisions several future enhancements to expand its functionality, scalability, and adaptability across diverse use cases.

### Planned Enhancements

1. **Integration with Biometric Authentication APIs**
   - Extend support for direct fingerprint or face recognition verification during login.
   - Allow seamless biometric-based revalidation without external QR code scanning.

2. **Cross-Platform SDK and Library Development**
   - Build lightweight SDKs for Android, iOS, and Web clients to simplify integration.
   - Offer plug-and-play packages for popular frameworks such as **React**, **Angular**, and **Flutter Web**.

3. **End-to-End Encryption Improvements**
   - Implement asymmetric key cryptography (RSA/ECC) for improved security during device registration.
   - Introduce dynamic session-based encryption to prevent replay attacks and ensure confidentiality.

4. **Scalable Cloud Deployment**
   - Containerize the backend using **Docker** and **Kubernetes** for scalable cloud hosting.
   - Provide deployment-ready templates for **AWS**, **Azure**, and **Google Cloud Platform (GCP)**.

5. **Role-Based Access Control (RBAC) and API Gateway**
   - Introduce fine-grained authorization control for enterprise-level integrations.
   - Employ API Gateway mechanisms for centralized authentication, throttling, and monitoring.

6. **Enhanced Developer Dashboard**
   - Develop a web-based dashboard where client developers can manage registrations, view logs, and monitor device bindings.
   - Include analytics and usage tracking to observe authentication activity trends.

7. **Integration with OAuth 2.0 and OpenID Connect**
   - Offer backward compatibility with standard authentication protocols.
   - Allow AuthAPI to act as an external passwordless provider in existing authentication systems.

8. **Improved Testing and CI/CD Automation**
   - Automate backend and frontend builds with GitHub Actions for faster deployment.
   - Expand the testing suite to include unit, integration, and end-to-end security tests.

### Long-Term Vision

The long-term goal of AuthAPI is to evolve into a **universal authentication framework** — one that minimizes password dependency, enhances user trust, and accelerates secure digital transformation across industries.  
It aims to become a modular authentication microservice that any organization can integrate with **just a few lines of configuration**, ensuring both simplicity and security.

---

## Contributors

This project is the result of collective effort, technical collaboration, and shared commitment to innovation.  
Each contributor played a vital role throughout the design, development, and testing phases.

### **Aeshna Preyasi** | [LinkedIn](https://www.linkedin.com/in/aeshnapreyasi05)

- Developed a **testing web module** — [AuthAPI Testing Site](https://www.github.com/aeshnapreyasi/auth-api-testing-site) — that enables real-time user registration, login, and data persistence.
- The testing site validated the feasibility of integrating AuthAPI into external platforms quickly and effectively.
- Actively participated in **UI/UX design**, **requirement analysis**, and **integration testing**, ensuring smooth project execution.



### **Akanksha Sharma** | [LinkedIn](https://www.linkedin.com/in/akanksha-sharma098)

- Led the **documentation and research efforts**, preparing the **Project Report**, **Synopsis**, **Presentation**, and **Software Requirement Specification (SRS)** documents.
- Ensured every development step aligned with academic and technical standards for project approval.
- Contributed significantly to **requirement gathering**, **workflow design**, and the **conceptual phase**, helping define clear project objectives and success metrics.



### **Akhilesh Tiwari** | [LinkedIn](https://www.linkedin.com/in/asdtiwari)

- Designed and developed the **backend server** using **Spring Boot** and the **mobile application** using **Flutter**.
- Architected the **end-to-end communication flow** between the mobile app, testing web module, and backend APIs.
- Implemented core features such as **device registration**, **QR-based authentication**, and **passwordless login**.
- Responsible for the overall **system design**, **API development**, and **deployment strategy**.

---

## Conclusion

The development of **AuthAPI** marks a significant step toward the adoption of **secure, user-friendly, and passwordless authentication** mechanisms.  
By combining **device fingerprinting**, **unique identifiers**, and **encrypted communication**, AuthAPI eliminates the need for traditional credentials while maintaining high standards of data privacy and system reliability.

Through collaborative teamwork and innovative problem-solving, the project successfully demonstrates that passwordless authentication can be **efficiently integrated** into existing platforms with minimal technical overhead.

Looking ahead, AuthAPI holds the potential to evolve into a **universal, developer-friendly authentication service** capable of reshaping how users verify their identities in digital ecosystems — making authentication not just more secure, but truly seamless.

---