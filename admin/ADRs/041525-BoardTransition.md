# Architecture Decision Record: Transition to ESP-WROOM-32 with Digital Microphone

**Status**: Accepted  
**Date**: 2025-04-15  

---

## 1. Context

The team conducted testing with both analog and digital microphones on selected MCU boards (ESP32-S3 and ESP-WROOM-32) to identify the best microphone for capturing heart/lung sounds and verify compatibility with the microcontroller platform.

## 2. Decision

Microphone testing occurred and based on outcome the digital microphone was chosen. The initial ESP32 S3 board failed to interface with the microphone so the ESP-WROOM-32 has been made the primary board.

## 3. Rationale

Mic Selection: 
- The analog microphone (MAX4466) suffered from heavy power supply noise and delivered poor sound quality, and failed to filter noise effectively.

- The digital microphone (INMP441) leveraged the I2S interface on ESP32 boards allowing seamless and quick setup.

- The use of a digital mic also eliminates the need for external ADCs, simplifying hardware design.

Board Selection:

- The ESP32-S3 failed to recognize any serial data over I2S from the INMP441 during testing.

- The ESP-WROOM-32 successfully captured audio from the digital microphone and was thus selected as the new primary board for development.

Additional considerations included:

- Aliasing and mssing low frequencies: These issues can be mitigated by selecting an appropriately high sampling rate.

- File size and audio compression: The raw audio data can be stored in WAV format (lossless) or transmitted as raw bytes and reconstructed server-side

- Bluetooth transmission limits: Live streaming of audio via BLE may not be feasible; however, delayed upload is acceptable our use case.

## 4. Consequences


### Positive outcomes

- Improved audio quality and reduced noise using INMP441
- More stable and compatible development environment using ESP-WROOM-32
- Simplified integration path via I2S (no need for ADC)

### Negative outcomes
- Not using the ESP32-S3 forfeits potential for onboard AI inference unless revisited

### Changes to processes/systems
- Transition away from analog signal processing to digital-only audio handling

- Firmware updates to focus exclusively on I2S and ESP-WROOM-32 compatibility

- Audio files will likely be recorded in WAV format

## 5. Alternatives Considered

N/A

## 6. Related Decisions
MCU Decision
[https://github.com/sbogh/digital-stethoscope/blob/main/admin/ADRs/040725-MCU-Decision.md]

Mic Selection
[https://github.com/sbogh/digital-stethoscope/blob/main/admin/ADRs/040825-MicSelection.md]
