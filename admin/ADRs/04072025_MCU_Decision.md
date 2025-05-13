# Architecture Decision Record: MCU decision

**Status**: Accepted 
**Date**: 2025-04-07 

---

## 1. Context

The team decided on an MCU after considering other embedded device options due to the need for the system to be low-cost and being able to handle wireless connectivity and potentially ML inferencing.

## 2. Decision

Based on the stretch goal the ESP32 S3 was chosen, with the ESP-WROOM-32 chosen as a secondary fallback.

## 3. Rationale

Key considerations included budget constraints, time constraints (well documented board), and connectivity functionality (need for BLE/WiFi).
ESP32 S3 contains a strong processing unit capable of onboard inference for an AI model (a potential stretch goal for the team)


## 4. Consequences

### Positive outcomes
- The ESP32-S3 Dev Module has strong processing capabilities, allowing future support for onboard AI inference
- Leverages well-supported and cost-effective components
### Negative outcomes
- ESP32 S3 does not contain built-in ADC so audio out would likely require additional components
- ESP32-S3 is newer, so some libraries or integrations may be less mature than ESP-WROOM-32.

### Any changes to processes, systems, or dependencies
- Since ESP32 S3 does not contain an ADC, we may have to consider other mic interfaces like I2S

## 5. Alternatives Considered

Arduino Nano ESP32 user experience research shows that the interface is not aligned with traditional ESP32 use and will require additional research to understand some niche aspects of connecting peripheral devices
ESP-WROOM-32 is the best documented of all devices, but may not be able to handle the ML inferencing computational requirement.

## 6. Related Decisions

N/A

## 7. References

Esp32-wroom-32 docs [https://www.espressif.com/sites/default/files/documentation/esp32-wroom-32_datasheet_en.pdf]
