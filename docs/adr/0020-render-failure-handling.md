# ADR-0020: Ghost Mannequin Render Failure Handling

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

On render failure: **automatic retry 3 times with exponential backoff**, then surface a manual "Tekrar Dene" button on the kit card.

## States

```
pending → processing → completed
                     ↘ failed (after 3 retries) → user-retriggerable
```

## UX

- While `pending` or `processing`: kit card shows original photo with a subtle shimmer overlay.
- On `failed`: kit card shows original photo + a small "WOW görünüm oluşturulamadı — tekrar dene" chip.
- User taps chip → render re-queued → back to `processing`.
- No push notification on failure — only on success.

## Timeout

If the render service does not respond within 120 seconds, treat as failure and begin retry logic.

## Rationale

Silently leaving the flat photo forever confuses users who expected WOW. Making the user manually trigger without any auto-retry wastes retries that often succeed. 3 auto-retries + user escape hatch balances reliability and transparency.
