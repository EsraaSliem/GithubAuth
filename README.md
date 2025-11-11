# GithubAuth

**GithubAuth** is a SwiftUI sample app demonstrating GitHub OAuth login, secure token storage using Keychain, and fetching authenticated user repositories.  
The project follows **Clean Architecture** principles with a modular structure and reactive state management using Combine.

---

## 1. Prerequisites

- Xcode 16 (or newer) with the latest iOS 18 SDK.  
- A GitHub OAuth application configured for iOS: [GitHub Developer Settings](https://github.com/settings/developers)

---

## 2. Configure GitHub OAuth

- Set the **callback URL scheme** on GitHub to `githubAuth://auth`.  
- Copy the generated **Client ID** and **Client Secret**.  
- Update `GitHubConfiguration.swift` with these values (for local testing only).  


---

## 3. Keychain

- The app securely stores the GitHub access token using **Keychain** through a `SecureStorage` abstraction.  
---

## 4. Architecture

The app is structured following **Clean Architecture**, ensuring a clear separation of concerns and testability.

### Layers

| Layer | Description |
|-------|--------------|
| **Data** | Contains repositories and services that manage API calls and data persistence. |
| **Domain** | Defines use cases, entities, and protocol interfaces — independent of frameworks. |
| **Presentation** | Contains SwiftUI views and Combine-based view models responsible for UI logic and state management. |


---

## 5. Unit Testing

- The project includes **unit tests** for the authentication flow.  
- `SignInUseCaseTests` validates the logic of exchanging authorization codes for tokens and storing them securely.  
- Uses mocks for `OAuthRepository` and `SecureStorage` to ensure isolated, reliable tests.

---

## 6. UI Testing

- Includes a **UI Test** for the login flow to validate the OAuth process and user experience.  
- Tests verify correct transitions from login to the repositories screen upon successful authentication.

---

## 7. Future Work

- Add more repository details (e.g., stars, rating, and activity) to the list view.  
- Replace in-source secrets with secure configuration management (build settings, encrypted plist, or remote secrets service).  
- Implement pagination, branch viewing, and detailed repository screens.  
- Extend automated test coverage the whole App.  


## 7. preview the app

https://github.com/user-attachments/assets/24290e6f-eaa2-4532-9d5a-9a4e62852212

