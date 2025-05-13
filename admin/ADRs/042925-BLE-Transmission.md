# Architecture Decision Record: Bluetooth Audio Transmission

**Status**: Accepted  
**Date**: 2025-04-25  

---

## 1. Context

The team explored how to transmit audio data from the ESP32 microcontroller to an iPhone via Bluetooth and considered possible architecture designs to handle audio file storage and avoid data loss during transmission.
## 2. Decision

We investigated Bluetooth audio transmission using the ESP32 A2DP profile and a timer-based audio recording trigger (e.g., press button → record for X seconds). We also decided to integrate a microSD card interface for local storage of audio prior to transmission.
## 3. Rationale

The ESP32 supports A2DP (Advanced Audio Distribution Profile) for Bluetooth audio streaming, which seems to be standard. iOS places limitations on BLE connections (such as MTU, packet limitations, transmission intervals). 
For the timer-based recording, this simplifies our firmware logic so that we can press record, record for a fixed time, and auto stop. Local storage via microSD ensures recordings are not lost due to unstable wireless conditions.

## 4. Consequences


### Positive outcomes

- Reduced risk of data loss with local microSD buffering

### Negative outcomes
- Potential delays in file upload if relying on local storage

- Need to manage microSD read/write cycles and file system handling

- Increased firmware and hardware complexity for SD card integration and buffer management

### Changes to processes/systems
- Introduce SD card write/delete logic into embedded software

- Need to evaluate packet framing strategies for .wav file reconstruction (header + raw data)

## 5. Alternatives Considered

Potential pivots based on iOS BLE connection limitations:  Have ESP32 connect either directly to a cloud server gateway or use the app as an authentication gateway to make connection with cloud server and have data transmitted directly there rather than to the iPhone.

## 6. Related Decisions
Guide for MicroSD Card Module using Arduino IDE
[https://randomnerdtutorials.com/esp32-microsd-card-arduino/]

Challenges in Bluetooth Low Energy (BLE) Integration with iOS Devices
[https://www.zco.com/blog/challenges-in-ble-integration-with-ios-devices/]
