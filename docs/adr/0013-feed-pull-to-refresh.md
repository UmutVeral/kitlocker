# ADR-0013: Feed Refresh Strategy — Pull-to-Refresh

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

Feed updates via **pull-to-refresh** only. No realtime websocket, no polling.

## Reason

Simplest reliable approach. User base in V1 is small — persistent websockets for all users is premature complexity. Supabase Realtime can be enabled later with minimal code change if needed.
