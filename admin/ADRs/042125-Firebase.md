# Architecture Decision Record: Use of Firebase for Authentication and Firestore Database

**Status**: Accepted  
**Date**: 04-21-25 

---

## 1. Context

We are developing a digital stethoscope system that captures `.wav` audio recordings from a custom hardware device and makes them accessible to users via a mobile or web application. To support this system, we require a backend that can:

- Receive and store `.wav` files (directly from the device)
- Associate each file with relevant metadata (e.g., user ID, timestamp)
- Securely manage user accounts and control access to data
- Provide real-time data access and synchronization to the app

Our goal is to keep the backend simple, scalable, and tightly integrated with our app development workflow.

## 2. Decision

We have chosen to use **Firebase** for the backend, specifically:

- **Firebase Authentication** to handle user sign-in, identity management, and access control.
- **Cloud Firestore** to store `.wav` audio files and associated metadata, enabling real-time syncing with the frontend.

## 3. Rationale

Firebase offers several benefits that align well with our project goals:

- **Tight integration** with mobile/web apps via official SDKs
- **Real-time updates** using Firestore, which is important for synchronizing recordings as they are uploaded
- **Authentication built-in**, reducing the need to implement a separate user management system
- **Managed infrastructure**, allowing us to focus on building the application rather than maintaining servers
- **Security rules** in Firestore and Firebase Auth ensure that users only access their own data

Although Firestore is not traditionally optimized for large file storage, our early-stage prototype uses it to store `.wav` files (e.g., as binary blobs or base64 strings) for simplicity.

## 4. Consequences

**Positive outcomes:**
- Rapid development with minimal backend code
- Real-time data access in the app
- Centralized and secure user authentication
- Scalable infrastructure with low maintenance overhead

**Negative outcomes:**
- Firestore is not optimized for large binary data, which may impact performance or cost at scale

## 5. Alternatives Considered

- **Firebase + Cloud Storage**: More appropriate for binary files, but introduces added complexity for now.
- **AWS (S3 + Cognito + DynamoDB)**: Powerful and flexible but requires more setup and integration effort.

## 6. Related Decisions

- Future ADR may be needed if we decide to offload audio file storage to a more suitable system.

## 7. References

- [Firebase Authentication](https://firebase.google.com/products/auth)
- [Cloud Firestore](https://firebase.google.com/products/firestore)