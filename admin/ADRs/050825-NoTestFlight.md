# Architecture Decision Record: Avoid Use of TestFlight for Demo

**Status**: Accepted  
**Date**: 05-08-25

---

## 1. Context

As part of the development process for our iOS application, we explored methods to share app builds with team members and for demos. One standard option for distributing pre-release iOS applications is Apple's TestFlight platform. However, using TestFlight requires enrollment in the Apple Developer Program, which costs $99 USD per year.

We are currently operating with limited budget and resources, so we're evaluating cost-effective ways to demonstrate app functionality during early development stages.

## 2. Decision

We have decided **not** to use TestFlight for distributing demo builds of our iOS application. Instead, we will conduct all demos using the Xcode simulator.

## 3. Rationale

The primary reason for this decision is financial: enrolling in the Apple Developer Program solely to use TestFlight is not justified at this stage of the project. Since we do not need to test the app on physical devices yet, the Xcode simulator is sufficient for demonstrating basic functionality and UI to stakeholders.

Key factors considered:
- The $99/year Apple Developer fee
- The current need is limited to internal demos, not wide distribution or testing
- The Xcode simulator provides adequate functionality for early-stage demonstrations

## 4. Consequences

**Positive outcomes:**
- No immediate cost for developer account enrollment
- Simple and fast demo setup via simulator
- No need to manage provisioning profiles or UDIDs

**Negative outcomes:**
- Cannot test performance or device-specific issues on real iPhone devices
- Will require future investment if we decide to move to real device testing or App Store distribution

**Process changes:**
- All demos will be conducted via screen sharing or in-person sessions using the Xcode simulator

## 5. Alternatives Considered

- **Using TestFlight**: Rejected due to cost and current lack of need for real device testing
- **Building and distributing .ipa files manually**: This would take time away from our more desirable nice-to-have features and still requires developer account provisioning

## 6. Related Decisions

N/A

## 7. References

- [Apple Developer Program](https://developer.apple.com/programs/)
- [TestFlight Overview - Apple Developer Documentation](https://developer.apple.com/testflight/)