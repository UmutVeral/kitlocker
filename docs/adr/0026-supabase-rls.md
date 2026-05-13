# ADR-0026: Supabase Row Level Security (RLS) Policies

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

RLS is enabled on all tables. No table is left open. The Flutter app uses the `anon` key — all data access is gated by RLS policies.

## Core policies

| Table | Read | Write |
|---|---|---|
| `locker_entries` | Public profiles: anyone. Private profiles: owner only. | Owner only |
| `users` | Public fields (username, avatar, bio): anyone. Private fields (email): owner only | Owner only |
| `follows` | Anyone (needed for follower counts) | Owner only (own follow relationships) |
| `feed_events` | Follower of the source user, or public profile | System only (Edge Function) |
| `comments` | Anyone on public kits | Authenticated users |
| `likes` | Anyone | Authenticated users |
| `blocks` | Owner only | Owner only |
| `reports` | Owner only | Authenticated users |

## Service role

Ghost Mannequin render completion (updating `visualization_url` on a `locker_entry`) is done via a Supabase Edge Function using the **service role key** — bypasses RLS for system operations. The service role key is never exposed to the client.
