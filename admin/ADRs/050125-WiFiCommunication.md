# Architecture Decision Record: Pivot to WiFi Communication and microSD-Based File Storage with Firebase Integration

**Status**: Superseded
**Date**: 2025-05-01

---

## 1. Context

The team initially explored how to transmit audio data from the ESP32 microcontroller to an iPhone via Bluetooth. However, BLE limitations including connection instability, low MTU size, and complexity in handling large file transfers led to reevaluation.

## 2. Decision
Pivot from BLE to WiFi for uploading audio data from the ESP32. We also decided to use Firebase as the backend for file uploads and database management.

## 3. Rationale
- WiFi offers higher bandwidth and greater reliability than BLE for transmitting large audio files. It also avoids limitations of iOS BLE stack, including lack of native BLE file transfer interfaces.

- TA recommendation confirmed WiFi would be more practical within the project’s scope and timeline.
- Firebase is easy-to-integrate with ESP32 and the front-end team was familiar with the framework.

## 4. Consequences


### Positive outcomes
WiFi transmission
- More reliable data transmission via WiFi
  
-  Easier integration with mobile frontend through Firebase

Firebase:
- Provides secure file hosting and database access

- Frontend can easily pull data directly from Firebase without complex middleware

### Negative outcomes
N/A


## 5. Alternatives Considered

As mentioned, we pivoted away from BLE transmission of audio data.
## 6. Related Decisions
BLE Transmission ADR [https://github.com/sbogh/digital-stethoscope/blob/main/admin/ADRs/050925-BLE-Transmission.md]
