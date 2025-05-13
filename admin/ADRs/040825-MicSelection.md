# Architecture Decision Record: Microphone selection

**Status**: Accepted  
**Date**: 2025-04-08 

---

## 1. Context

The team decided to test both analog and digital microphones with the devices to determine the best device to use to capture heart and lung sounds. The microphones with the correct frequency ranges are difficult to source so initial testing will be done with common microphones easily available and then when a decision is made (between digital and analog), the microphone will be swapped for the true device.

## 2. Decision

Our team decided to test both an analog microphone (MAX4466) and a digital microphone (INMP441).

## 3. Rationale

Frequency range: Both MAX4466 and INMP441 can support frequencies near the required 20–3000 Hz range.

Sampling rate: Both mics support a sampling rate 2x of highest frequency

Availability and cost: Both microphones are inexpensive and widely available, which is ideal for our initial prototype.

## 4. Consequences


### Positive outcomes

- INMP441 (digital): Uses I2S protocol, avoiding analog signal interference. I2S is natively supported on ESP32 and has reliable open-source examples and community support.

### Negative outcomes
- MAX4466 (analog) requires analog-to-digital conversion (ADC) and may introduce analog noise. Also, the ESP32-S3 does not have built-in ADC, requiring external components.


## 5. Alternatives Considered

N/A

## 6. References

Heart and lung frequencies [https://pmc.ncbi.nlm.nih.gov/articles/PMC2990233/#:~:text=The%20spectrum%20of%20heart%20sounds,like%20fine%20or%20coarse%20crackles.]
