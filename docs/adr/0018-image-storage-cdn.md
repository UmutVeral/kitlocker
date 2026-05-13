# ADR-0018: Image Storage — Supabase Storage with Client-Side Compression

**Status:** Accepted  
**Date:** 2026-05-13

## Decision

Store all kit photos and Ghost Mannequin renders in **Supabase Storage**. Compress and resize images client-side before upload.

## Image pipeline

1. User captures photo in Flutter app.
2. Flutter resizes to max 1080px on the longest edge and converts to WebP (quality 85).
3. Compressed image uploaded to Supabase Storage.
4. Supabase Storage serves via built-in Cloudflare CDN — no separate CDN setup needed.
5. Ghost Mannequin render result (produced by external service) is downloaded and re-uploaded to Supabase Storage so all assets are in one place and under our control.

## Bucket structure

```
kit-photos/        ← original (compressed) user photos
kit-renders/       ← Ghost Mannequin rendered images
avatars/           ← user profile photos
```

## Access control

- `kit-photos/` and `kit-renders/`: public read (Showcase must be viewable without auth), owner write only (Supabase RLS).
- `avatars/`: public read, owner write only.

## Why re-upload the render

The Ghost Mannequin render comes from a third-party service URL. Storing that URL directly creates a dependency on the provider's storage — if they change URLs or delete the file, images break. Re-uploading to Supabase Storage ensures we own all assets.
