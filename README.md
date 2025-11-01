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

### Dependencies


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