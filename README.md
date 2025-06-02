# ScopeFace: Digital Stethoscope

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Team](#team)
- [UX Research](#ux-research)
- [System Design](#system-design)
  - [UI Prototypes](#ui-prototypes)
  - [System Diagrams](#system-diagrams)
  - [Architecture](#architecture)
- [Repo Structure](#repo-structure)
- [Software](#software)
  - [Frontend](#frontend)
  - [Backend](#backend)
  - [Running the App](#running-the-app)
- [Hardware](#hardware)
  - [Hardware Setup](#hardware-setup)
  - [Hardware Operation](#hardware-operation)
- [Known Limitations](#known-limitations)
- [Future Work](#future-work)

## Introduction
**ScopeFace** is a portable digital stethoscope system developed over 10 weeks as part of UC San Diego's CSE 237D Embedded Systems Project course (Spring 2025). Our goal was to prototype a clinician-focused tool that amplifies, records, and replays heart and lung sounds through a streamlined mobile interface.

Designed with input from nurses, PAs, and doctors, the app supports session-based `.wav` recording, waveform visualization, note-taking, and Firebase-backed data storage. The hardware component captures sound using a custom-built stethoscope device, while the SwiftUI app allows users to review and annotate sessions in real time.

Check out our [external web presence here](https://myrmanshelby.github.io/digital-stethoscope-landing-page/)  
(External web presence [repo linked here](https://github.com/myrmanshelby/digital-stethoscope-landing-page)).

## Features
- Session-based `.wav` recording and playback  
- Waveform visualization  
- Session renaming and note-taking  
- Firebase integration for storage and authentication

## Team
- [Siya Rajpal](https://www.linkedin.com/in/siya-rajpal/): fullstack engineer
- [Shelby Myrman](https://www.linkedin.com/in/shelby-myrman/): ux design/frontend engineer
- [Amrita Moturi](https://www.linkedin.com/in/amrita-moturi/): hardware engineer
- [Shayan Boghani](https://www.linkedin.com/in/shayan-b/): hardware engineer

## UX Research
Before developing, we conducted user research interviews to gauge user needs. We then looked at app design inspiration and mapped in-app customer journeys. See our UX artifacts below:
- [User Interviews](https://github.com/sbogh/digital-stethoscope/blob/main/admin/user-research/user-research-summary.md)
- [Design Inpsiration](https://github.com/sbogh/digital-stethoscope/blob/main/admin/initial-diagrams/design-inspiration.pdf)
- [Initial User Journey Map](https://github.com/sbogh/digital-stethoscope/blob/main/admin/initial-diagrams/initial-user-journey.pdf)

## System Design

### UI Prototypes
We completed high-fidelity prototypes for both our MVP and ideal full system. 

#### MVP Prototypes
- [Login Flow](https://www.figma.com/design/D0sZ9Dy5eKCmVsZL9oDZRN/Digital-Stethoscope?node-id=1-34&t=OJdkmq2NDCs8I1Uz-1)
- [New Recording Page](https://www.figma.com/design/D0sZ9Dy5eKCmVsZL9oDZRN/Digital-Stethoscope?node-id=60-2107&t=OJdkmq2NDCs8I1Uz-1)

#### Reach System Prototypes
- [Learn More Flow](https://www.figma.com/design/D0sZ9Dy5eKCmVsZL9oDZRN/Digital-Stethoscope?node-id=38-15&t=OJdkmq2NDCs8I1Uz-1)
- [Home Page](https://www.figma.com/design/D0sZ9Dy5eKCmVsZL9oDZRN/Digital-Stethoscope?node-id=47-155&t=OJdkmq2NDCs8I1Uz-1)
- [FAQs Page](https://www.figma.com/design/D0sZ9Dy5eKCmVsZL9oDZRN/Digital-Stethoscope?node-id=60-2147&t=OJdkmq2NDCs8I1Uz-1)
- [History Flow](https://www.figma.com/design/D0sZ9Dy5eKCmVsZL9oDZRN/Digital-Stethoscope?node-id=60-2146&t=OJdkmq2NDCs8I1Uz-1)
- [Patient Flow](https://www.figma.com/design/D0sZ9Dy5eKCmVsZL9oDZRN/Digital-Stethoscope?node-id=78-3089&t=OJdkmq2NDCs8I1Uz-1)
- [Account Page](https://www.figma.com/design/D0sZ9Dy5eKCmVsZL9oDZRN/Digital-Stethoscope?node-id=52-3486&t=OJdkmq2NDCs8I1Uz-1)

### System Diagrams
We created 2 sets of system diagrams: our MVP system and our ideal full product system.
- **MVP System**: See our [MVP System Diagram here](https://github.com/sbogh/digital-stethoscope/blob/main/admin/mvp-product-diagrams/mvp-system-diagram.pdf) and our [MVP Database Schema Diagram here](https://github.com/sbogh/digital-stethoscope/blob/main/admin/mvp-product-diagrams/mvp-database-schema.pdf)
- **Full System**: See our [Full System Diagram here](https://github.com/sbogh/digital-stethoscope/blob/main/admin/full-product-diagrams/reach-system-diagram.pdf) and our [Full Database Schema Diagram here](https://github.com/sbogh/digital-stethoscope/blob/main/admin/full-product-diagrams/reach-database-schema.pdf)

For clearer views of our system diagrams, visit our [Miro board here](https://miro.com/app/board/uXjVI8VBn7o=/?share_link_id=259432345089).

### Architecture
- **Frontend**: SwiftUI-based iOS app tailored for clinician workflow (see [frontend ADR here](https://github.com/sbogh/digital-stethoscope/blob/main/admin/ADRs/042125-Swift.md))
- **Backend**: Python FastAPI service to support future device integrations and analytics (see [backend ADR here](https://github.com/sbogh/digital-stethoscope/blob/main/admin/ADRs/042125-Python-FastAPI.md))
- **Database**: Firebase Firestore and Authentication for secure session tracking (see [database ADR here](https://github.com/sbogh/digital-stethoscope/blob/main/admin/ADRs/042125-Firebase.md)) 
- **Hardware**: Custom stethoscope device with onboard mic and amplifier circuitry

## Repo Structure

```text
digital-stethoscope/
│
├── .github/                        # GitHub configuration files
│   └── workflows/                  # CI/CD pipeline setup (e.g., test and deploy scripts)
│
├── admin/                          # Documentation, planning assets, and research
│   ├── ADRs/                       # Architectural Decision Records
│   ├── full-product-diagrams/     # Diagrams for long-term vision of the system
│   ├── initial-diagrams/          # Early conceptual or low-fidelity diagrams
│   ├── mvp-product-diagrams/      # Diagrams focused on MVP system architecture
│   └── user-research/             # Notes and transcripts from stakeholder interviews
│
├── backend/                        # FastAPI backend services (e.g., API endpoints, auth)
│   ├── main.py                     # Entry point for the FastAPI app
│   └── ...                         # Additional modules, routes, and utilities
│
├── hardware/                       # Embedded systems and electronics
│   ├── modules/                    # Modular firmware for sensors, audio processing, etc.
│   └── ...                         # Circuit schematics, board configurations
│
├── digital-stethoscope/           # SwiftUI iOS app (Xcode project root)
│   └── digital-stethoscope/       # Main app source folder
│       ├── Config/                # Environment settings, constants, Firebase setup
│       ├── Controllers/           # ViewModels and state management logic
│       ├── Extensions/            # Swift extensions for common utilities
│       ├── Models/                # Data structures for recordings, sessions, user state
│       └── Views/                 # SwiftUI interface components
│           ├── LearnMoreFlow/     # "Learn More" educational flow
│           ├── LoginFlow/         # Sign-in and account setup screens
│           └── RecordingsPage/    # Session list, audio playback, and note-taking
│
└── README.md                       # Project overview and documentation
```

## Software

### Frontend
1. Make sure you have Xcode downloaded on your computer.
2. The app is nested in folders of the same name. When you clone the respository, be sure to open digital-stethoscope/digital-stethoscope
3. Firebase SDK: You must install the Firebase SDK on your own machine.
    1. Navigate to the Project icon and right click (the first digital-stethoscope)
    2. Click on "Add Package Dependencies"
    3. In the search bar that pops up, paste this link: https://github.com/firebase/firebase-ios-sdk
    4. Click "Add Package"
    5. Then look through the list, adding Firebase Auth, Firebase Core, and Firebase FireStore to the target, which is just digital-stethoscope
4. Info.plist: Click on the projet icon one more time
    1. Navigate to the target (the icon labeled digital-stethoscope)
    2. Go to build settings, at the top, and click "all"
    3. Then search for "Generate Info.plist File". It should be under "Packaging". Make sure it is turned to No.
    4. Below that, there will be a field Info.plist File. Ensure the path to the Info file in the cell. 
5. Then you should be good to go!

### Backend
1. Make sure you have Python 3.10+ installed.
2. Make sure to have FastAPI installed
3. Take a look at main.py to get an idea of how everything works.
4. use ```uvicorn main:app --reload``` to run the server

### Running the App
To run ScopeFace locally, start by launching the backend server and then run the iOS app through Xcode.
1. Install dependencies from the `requirements.txt` file:
   ```bash
   cd backend
   pip install -r requirements.txt 
2. Run the server
    ```bash
    uvicorn main:app --reload
3. Open the XCode project at digital-stethoscope/digital-stethoscope
4. Connect your iOS simulator or device and click run in Xcode.

## Hardware

### Hardware Setup
1. Using the Arduino IDE, plug in your XIAO ESP32-S3
2. Go to Tools -> PSRAM and enable "OPI PSRAM"
3. Add WiFi SSID and Password Information where specified in instruction comments
4. Add Firebase API Key and double check bucket and user authentication information
5. Compile and upload to microcontroller

### Hardware Operation
1. Wait for upload to complete and check for initialization success (serial monitor will display WiFi connected, Firebase connected)
2. Press button to record 30 seconds of audio (onboard LED will be on)
3. Wait for Firebase upload to complete (onboard LED will be on)
4. Navigate to Firebase to playback audio

## Known Limitations

- Currently runs only on the iOS simulator (no physical deployment)
- No patient or date search functionality
- No HIPAA compliance implemented
- ML diagnostics and patient profiles are not yet developed

## Future Work

While our MVP successfully supports audio recording and playback through a mobile interface, we do not plan to continue developing this product beyond the scope of our course. However, if we were to bring the app to market, the following areas represent logical extensions based on our prototypes and system design:

### HIPAA Compliance
To prepare the system for real-world clinical use, we would need to implement full HIPAA compliance. This would include encrypted data storage, authenticated access, and audit logging to ensure secure handling of sensitive health information.

### Patient Assignment and Record Management
A full version of the app could support assigning heartbeat and lung recordings to individual patients. This might include:
- Patient profiles
- Recording tagging and linking

See our [Patient Flow Prototype](https://www.figma.com/design/D0sZ9Dy5eKCmVsZL9oDZRN/Digital-Stethoscope?node-id=78-3089&t=OJdkmq2NDCs8I1Uz-1) and [Full System Diagram](https://github.com/sbogh/digital-stethoscope/blob/main/admin/full-product-diagrams/reach-system-diagram.pdf) for intended design.

### History and Session Review
We envisioned adding a history view to allow clinicians to filter by date, patient, or condition to access recordings.

See our [History Flow Prototype](https://www.figma.com/design/D0sZ9Dy5eKCmVsZL9oDZRN/Digital-Stethoscope?node-id=60-2146&t=OJdkmq2NDCs8I1Uz-1).

### Improved Home and Recordings Pages
In a production-ready version, the home and recordings pages could be enhanced to include streamlined navigation across patients and sessions

See our [Home Page Prototype](https://www.figma.com/design/D0sZ9Dy5eKCmVsZL9oDZRN/Digital-Stethoscope?node-id=47-155&t=OJdkmq2NDCs8I1Uz-1) compared to our [MVP Recordings Page](https://www.figma.com/design/D0sZ9Dy5eKCmVsZL9oDZRN/Digital-Stethoscope?node-id=60-2107&t=OJdkmq2NDCs8I1Uz-1).

### Machine Learning for Diagnostics
If continued, we could explore machine learning models for analyzing heart and lung sounds. Features might include:
- On-device or server-side analysis
- Detection of irregular rhythms, murmurs, or wheezing
- Clinician-facing summaries of algorithmic findings

This concept would be positioned as decision support rather than automated diagnosis.

### Deployment and TestFlight
Currently, the app can only be run on a simulator due to the cost of an Apple Developer account. In a future rollout, we would:
- Register for an Apple Developer account
- Use TestFlight to distribute builds to physical devices
- Consider submitting to the App Store for clinical pilots

---

These potential extensions align with the user needs captured in our [User Interviews](https://github.com/sbogh/digital-stethoscope/blob/main/admin/user-research/user-research-summary.md) and the architecture outlined in our [Miro board](https://miro.com/app/board/uXjVI8VBn7o=/?share_link_id=259432345089).

## Contributing
This project is no longer actively maintained, but if you'd like to fork or reuse components, feel free to open issues or pull requests.