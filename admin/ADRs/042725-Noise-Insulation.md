# Architecture Decision Record: Noise Insulation Strategy

**Status**: Accepted 
**Date**: 2025-04-27 

---

## 1. Context

During testing, it became clear that the microphone alone was too sensitive to ambient noise. To address this, the team researched acoustic insulation strategies to shield the microphone from external noise sources.
## 2. Decision

Based on our research, we will prototype a noise insulation solution using a construction-grade ear protection cup as a sound-dampening casing for the microphone. We will route microphone wiring through the ear cup and seal it to prevent sound leakage.

## 3. Rationale

The microphone is highly sensitive and picks up unwanted ambient sounds, which hinders the clarity of heartbeat/lung sounds. A construction ear protector offers a cost-effective and accessible solution for prototyping a noise-insulating material.


## 4. Consequences

### Positive outcomes
- Minimal-cost prototype with quick testability using off-the-shelf materials
### Negative outcomes
- Drilling ear cup and sealing introduces irreversible changes to prototype components

### Any changes to processes, systems, or dependencies
- Microphone wiring must be adapted to route through physical insulation

## 5. Alternatives Considered

Using commercial stethoscope housing: Considered overkill for early prototyping and lacks flexibility.
## 6. Related Decisions

N/A
