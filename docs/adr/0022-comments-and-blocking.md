# ADR-0022: Comments, Blocking, and Social Safety

**Status:** Accepted  
**Date:** 2026-05-13

## Comment rules

- Max 500 characters per comment.
- No @mention support in V1 — adds notification complexity not justified for V1.
- Deletion: user can delete their own comments; kit owner can delete any comment on their kit.
- Rate limit: max 5 comments per user per 60 seconds (enforced at Supabase RLS / Edge Function level).

## Blocking

- Any user can block any other user.
- Blocking effect: blocker cannot see blockee's content; blockee cannot see blocker's content, comment on their kits, or follow them.
- Block list stored as a simple table: (blockerId, blockedId, createdAt).
- Required for App Store compliance.

## Reporting

- Comments are reportable (extends ADR-0021 reporting mechanism).
- Report reasons: spam, inappropriate content, harassment.

## V1 out of scope

- Comment likes
- Nested replies / threads
- @mentions
