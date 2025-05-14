# Architecture Decision Record: Removal of microSD Dependency Using PSRAM

**Status**: Accepted  
**Date**: 2025-05-09

---

## 1. Context

Early iterations of our design used a microSD card for local storage of .wav audio files before uploading them to the Firebase database. While functional, this approach increased latency and required additional components and wiring and increased the likelihood of hardware-related failure. As testing progressed, the team discovered that the onboard 8MB PSRAM (pseudo-static RAM) on the ESP32-S3 module could be enabled and used to store temporary recording data, making the SD card unnecessary for the current file size requirements.
## 2. Decision

Our team removed the need for a microSD card by using PSRAM.

## 3. Rationale

A 30-second .wav file is only ~2.6 MB, which fits within the 8MB limit for PSRAM. Memory-based storage also enables faster access and avoids file write delays that could lead to timing issues during recording.

## 4. Consequences


### Positive outcomes

- Upload now takes ~20 seconds with PSRAM-based storage as opposed to about 60-90 seconds from end of recording.
- Entire audio pipeline now completes in ~45–50 seconds, including 30 seconds for recording.
- Pre-allocating the buffer removed a costly memory operation, improving efficiency.


### Negative outcomes
- Limited by total available PSRAM (future stretch goals may exceed this buffer)
- Removed flexibility to retain multiple files locally if needed

### Changes to systems/processes
- Firmware now initializes a global buffer in setup() for audio capture

- No need to delete files post-upload as we had to with the microSD card

## 5. Alternatives Considered

N/A

## 6. References

Support for External RAM [https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-guides/external-ram.html]
