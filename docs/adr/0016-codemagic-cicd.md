# ADR-0016: Codemagic for CI/CD

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

Use **Codemagic** for building, signing, and deploying the Flutter app to App Store and Google Play.

## Reasons

- Flutter-native CI/CD — built specifically for Flutter, maintained in partnership with the Flutter team.
- Apple code signing (the hardest part of mobile CI/CD) is handled via Codemagic's UI — no manual certificate management.
- `codemagic.yaml` defines the full pipeline: test → build → sign → deploy to TestFlight / Play Internal Track.
- Free tier: 500 build minutes/month. Sufficient for V1.

## Rejected alternatives

- **GitHub Actions + Fastlane**: More flexible but setup takes days. Apple certificate management is a recurring maintenance burden. Not worth it for V1 team size.
- **Bitrise**: Expensive, no meaningful advantage over Codemagic for Flutter.

## Pipeline (V1)

- `main` branch push → run tests → build release → deploy to TestFlight (iOS) + Play Internal Track (Android)
- Manual promotion to App Store / Play Store production after QA sign-off.
