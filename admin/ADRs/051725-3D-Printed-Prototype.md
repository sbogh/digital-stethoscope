# Architecture Decision Record: [Use of 3D Printing for Device Enclosure]

**Status**: [Accepted] 
**Date**: [2025-05-17]  

---

## 1. Context

The design requires mechanical stability and access to GPIO features (e.g., button, RGB diode). We explored manufacturing options for producing a suitable casing, including 3D printing, injection molding, and metal machining.

During this phase of development, we are rapidly iterating on layout, sizing, and component placement. A CAD model of the initial design was created and tested as part of the integrated pipeline.
## 2. Decision

We decided to 3D print the device enclosure using PLA material for prototyping and testing phases. We also tested PETG filaments.


## 3. Rationale

3D printing was selected over other manufacturing methods due to the following considerations:

Rapid iteration: Enables fast and low-cost turnaround for modifying and testing updated CAD models

Low upfront cost: Unlike injection molding or CNC machining, 3D printing does not require expensive tooling, molds, or setup costs.

Customizability: Easy to adapt design features such as button slots, microcontroller mounts, and access ports across iterations.

In-house fabrication: Printing can be done directly in our lab and the Envision Lab without relying on external vendors.

## 4. Consequences

Positive outcomes:

- Enables iterative mechanical testing with minimal delay.

- Simplifies integration of electronic components in a confined space.


Negative outcomes:

- Inconsistent print quality between different 3D printers and filament types can result in slight dimensional variances, affecting part fit and assembly precision.

- PLA material is less durable and heat-resistant than final production materials.

- Printed parts may not provide long-term mechanical stability or tight tolerances.

- Not suitable for final clinical-grade production without redesign.



## 5. Alternatives Considered

Injection molding: Rejected due to high upfront tooling cost and long lead times. Not suitable for frequent design changes at this stage.

Metal machining: Considered too rigid for rapid iteration. Also more expensive for early-stage prototype.

