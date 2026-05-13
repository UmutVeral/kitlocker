# ADR-0001: Flutter over React Native

**Status:** Accepted  
**Date:** 2026-05-13

## Context

KitLocker requires a cross-platform mobile app (iOS + Android) with heavy custom UI: 3D/WOW garment visualization, floating effects, animated transitions. The two viable options were Flutter and React Native.

## Decision

Use **Flutter** as the cross-platform framework.

## Reasons

- Flutter's Impeller rendering engine renders directly to a canvas without relying on platform widgets. This gives consistent, high-performance visuals across iOS and Android — essential for WOW visualization screens.
- Custom shaders (`dart:ui` / `flutter_shaders`) are accessible directly, enabling advanced visual effects without native module bridges.
- React Native's JavaScript bridge adds overhead on animation-heavy screens; bridgeless architecture (New Architecture) mitigates this but is still maturing.
- V1 has no web app, so React Native's JavaScript/web code-sharing advantage does not apply.

## Consequences

- Dart is the language. Team must be comfortable with Dart or learn it.
- Flutter package ecosystem (pub.dev) replaces npm for mobile dependencies — generally mature for the use cases required.
- Changing to React Native later would require a full rewrite — this decision is expensive to reverse.
