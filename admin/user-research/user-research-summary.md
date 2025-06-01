# User Research Summary

## April 2, 2025: Shelby's Discussion with Nurses

### Requested Use Cases from a Small Sample of Nurses and Physician Assistants

#### Cost
- Stethoscopes are expensive, often costing at least $100 out of pocket.
- Nurses prioritize performance and are willing to pay for quality.
- **Our solution**: Create a significantly more affordable alternative.

#### Difficulty Hearing
- Nurses report that stethoscope sounds are often too quiet.
- One nurse was unable to hear wheezing that her trainer could, even after repeated attempts.
- **Our solution**: Integrate sound amplification.

#### Confirming Sounds with Doctors
- A nurse identified a murmur that was not heard by a physician during follow-up, leading to uncertainty.
- Having a recording to replay for confirmation would be helpful.
- **Our solution**: Enable sound recording and playback.

#### Difficulty Counting
- Nurses struggle with counting beats per minute (BPM) and respirations while listening for anomalies.
- **Our solution**: Provide automatic BPM and respiration rate counting.

#### Portability and Usability
- Nurses often misplace stethoscopes.
- Pediatric nurses report that traditional stethoscopes can scare children.
- **Our solution**: Consider a compact, wearable, or pin-based form factor with a friendly design.

#### Live Listening
- Some assessments are time-sensitive and require immediate feedback.
- **Our solution**: Support live listening via speakers or Bluetooth-connected headphones.

---

## Other Considerations

### Pediatric Use
- Traditional stethoscopes have a baby-specific diaphragm.
- Using the adult side on a baby results in excessive noise and poor sound isolation.
- **Note**: Our design may need a smaller sensor or a separate pediatric version.

### Machine Learning Diagnostics
- Nurses support ML-aided diagnostics, but prioritize reliable amplification and recording.
- Users want access to recordings even if automated diagnosis is included.
- **Our solution**: Focus on recording, with ML as an optional aid.

### Lungs
- Stethoscopes are also used for lung auscultation.
- Lung and heart sounds are distinct; users may need to indicate which organ is being monitored.
- **Our solution**: Offer a simple toggle between heart and lung modes.

---

## April 4, 2025: Shayan’s Discussion with a Doctor

### Clinical Use Cases During Exams

#### Heart Rate
- Categories: bradycardia, normal (60–100 bpm), tachycardia

#### Rhythm
- Regular or irregular
  - Irregularly irregular (e.g. atrial fibrillation)
  - Episodic irregular
  - Premature beat

#### Heart Sounds
- S1: Closure of mitral and tricuspid valves
- S2: Closure of aortic and pulmonary valves

##### Important Sound Features
- Sound intensity: muffled, too loud, normal
- Split sounds: generally not prominent in adults
  - S1: mitral before tricuspid
  - S2: aortic before pulmonary
- Murmurs: may indicate normal or pathological flow
  - Example: anemia can cause high flow murmurs

##### Murmur Classification
- Phase: systolic (S1–S2) or diastolic
- Timing: early, late, throughout
- Special case: machinery murmur (present in both phases)

#### Note
- Many doctors now rely on ECGs instead of stethoscopes.

---

## April 4, 2025: Amrita’s Meeting with Nicolay (Sensor Specialist)

### Technical Feedback and Suggestions

- The stethoscope’s listening component is complex enough to justify a full project focus.
- Consider creating a disposable patch version with external electronics.
- Companies in this space include Eko and Korean pet care companies using Bluetooth-enabled stethoscopes.

### Hardware Considerations

- Evaluate whether the **NDP120** chip can handle onboard inferencing.
- Explore **PDM** output format for sensor-to-dev board interfacing.
- Use an **audio codec chip** to translate raw sensor data into a usable format.

### Sensor Recommendations

- Consider analog sensors for better compatibility with audio processing.
- Prioritize small form factor and low noise for clean signal capture.
- V2S sensor operates at 10 kHz, but heart sounds are below 500 Hz.
  - Excessive bandwidth introduces noise; filtering is necessary.
  - Prefer sensors with native bandwidth under 1 kHz.

### Additional Notes

- Explore accelerometers and vibration sensors as alternatives.
- Arduino Nano 33 supports PDM input and could be a good prototyping option.