# ADR-0010: Firebase Cloud Messaging (FCM) for Push Notifications

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

Use **Firebase Cloud Messaging (FCM)** for push notifications. Supabase Edge Functions trigger FCM on relevant events (new follower, like, Ghost Mannequin render complete).

## Reasons

- FCM is the industry standard for iOS + Android push — free, reliable, no per-notification cost.
- No need for a wrapper service (OneSignal, Expo Notifications) — KitLocker's notification types are simple and don't warrant the extra dependency.
- Supabase Edge Function → FCM REST API is a straightforward integration.

## Notification types (V1)

- New follower
- Kit liked
- Ghost Mannequin render complete

## Consequences

- Firebase project required alongside Supabase. Firebase is used only for FCM — no Firestore, no Firebase Auth.
