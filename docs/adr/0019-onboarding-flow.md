# ADR-0019: Onboarding Flow

**Status:** Accepted  
**Date:** 2026-05-13

## Flow (step by step)

1. Splash screen (logo, ~1.5s)
2. Welcome screen — minimal copy + "Formanı Ekle" CTA (primary) + "Zaten hesabın var mı? Giriş yap" (secondary)
3. Auth — Apple / Google / Email seçimi → kayıt tamamlanır
4. Kamera açılır direkt (galeri seçeneği de mevcut)
5. Fotoğraf çekilir → AI recognition başlar (loading indicator)
6. Metadata ekranı — AI sonuçları gösterilir, kullanıcı onaylar veya düzeltir
7. "Forma ekleniyor..." kısa animasyon
8. Locker açılır — forma düz fotoğrafla listelenir
9. Banner: "WOW görünümün hazırlanıyor..." (asenkron render kuyruğa alındı)
10. Push bildirimi → "Formanın hazır!" → tıklayınca Ghost Mannequin görünür

## Key decision

**Kayıt, forma eklenmeden önce gelir.** Kayıtsız kit ekleme yok — her kit bir kullanıcıya bağlı olmalı.

## Rationale

Welcome screen → Auth → Kit ekleme sırası, kullanıcının uygulamaya commit olmasını sağlar. Kayıtsız kullanıcıya WOW göstermek mümkün ama veriyi kaydetmek için sonradan auth zorunlu olurdu — bu daha kötü bir UX (yarım kalan form, kaybolan veri).
