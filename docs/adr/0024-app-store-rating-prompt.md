# ADR-0024: App Store Rating Prompt Timing

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

Trigger the in-app review prompt **immediately after the first Ghost Mannequin render completes** — the WOW moment.

## Rationale

The highest-emotion moment in the app is when the user sees their flat jersey photo transform into a Ghost Mannequin render for the first time. Requesting a review at this exact moment maximizes positive rating probability.

## Rules

- Show once per session, maximum once every 30 days (Apple/Google enforce their own limits on top of this).
- Never show during onboarding or before the first WOW render.
- Use native `in_app_review` Flutter package — renders the OS-native prompt, no custom UI.
