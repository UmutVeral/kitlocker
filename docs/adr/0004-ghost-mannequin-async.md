# ADR-0004: Ghost Mannequin Render is Asynchronous in V1

**Status:** Accepted  
**Date:** 2026-05-13

## Context

WOW Visualization (Ghost Mannequin effect) is computationally expensive. The question is whether the user waits for the render before seeing the kit in their Locker, or whether the render happens in the background.

## Decision

Ghost Mannequin renders are **asynchronous** in V1. The kit is added to the Locker immediately with the flat photo; the Ghost Mannequin render replaces it automatically when ready. The user receives a notification when the render is complete.

## Reasons

- Render time is unpredictable and potentially 10–30 seconds depending on the service. Blocking the user for this duration is a poor UX.
- The flat photo is a valid placeholder — the kit is in the Locker, which is the primary goal.
- Async is simpler to implement reliably in V1.

## Future

If render times improve to under 3 seconds, revisit synchronous rendering for the first kit (onboarding WOW moment) as a high-impact UX upgrade. This decision is cheap to reverse once the pipeline is fast enough.

## Pipeline

User uploads photo → Supabase Storage → render job queued → Ghost Mannequin service processes → result stored in Supabase Storage → Supabase Realtime notifies the app → Locker Entry updates automatically.
