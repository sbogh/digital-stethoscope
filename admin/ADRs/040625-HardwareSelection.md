# Architecture Decision Record: Hardware selection

**Status**: Accepted  
**Date**: 2025-04-06  

---

## 1. Context

Our first stage for hardware selection was determining a good fit for the main component of our embedded system. There are options like the Raspberry Pi (single-board computer), Arduino boards (microcontroller), ESP32 (microcontroller), and others. The selected hardware needs to be capable of connecting components to record and process heart and lung sounds, transmit data wirelessly, and potentially run classification models.

## 2. Decision

Our project requirements lean towards the use of a microcontroller.

## 3. Rationale

A SBC is more complex than is needed for this project given the straightforward use case. Additionally, size constraints make it so that a microcontroller may be a better choice for the product form factor. Potential stretch goals, like onboard ML inference, can still be explored using higher-end microcontrollers like the ESP32-S3.


## 4. Consequences


### Positive outcomes

- Lower cost and power requirements
- Smaller physical footprint
- Easier integration with embedded peripherals like microphones
- Faster development for real-time, single-purpose firmware

### Negative outcomes
- Limited processing power may constrain future ML capabilities or advanced signal
processing

## 5. Alternatives Considered

- Raspberry Pi (e.g., Pico W): Rejected due to lack of Bluetooth on Pico W, higher cost and power usage on full-size Pi models, and overkill for the use case.


- STM32 family: Not chosen due to longer learning curve and less community documentation compared to ESP32.


- ESP32-WROOM-32 / ESP32-S3: These were selected as microcontroller options based on processing capability, wireless features, and documentation maturity.



## 6. References

Raspberry Pi Pico documentation [https://www.raspberrypi.com/documentation/microcontrollers/pico-series.html]

STM32 32-bit Arm Cortex MCUs
[https://www.st.com/en/microcontrollers-microprocessors/stm32-32-bit-arm-cortex-mcus/documentation.html]

ESP32-S3 datasheet and Espressif documentation [https://www.espressif.com/sites/default/files/documentation/esp32-s3_datasheet_en.pdf]



