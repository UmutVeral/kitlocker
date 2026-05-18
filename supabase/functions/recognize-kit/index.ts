import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

type RecognitionResponse = {
  team: string | null;
  league: string | null;
  season: string | null;
  playerName: string | null;
  number: string | null;
  confidence: number;
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const apiKey = Deno.env.get("GEMINI_API_KEY");
    if (!apiKey) {
      return jsonError("GEMINI_API_KEY not configured", 500);
    }

    const { imageBase64 } = await req.json();
    if (!imageBase64 || typeof imageBase64 !== "string") {
      return jsonError("imageBase64 required", 400);
    }

    const model = Deno.env.get("GEMINI_MODEL") ?? "gemini-2.0-flash";
    const geminiUrl =
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`;

    const prompt = `You identify football jersey kits from photos.
Return ONLY valid JSON with keys: team, league, season, playerName, number, confidence.
confidence is 0-1 for how sure you are about team and season.
Use null for unknown fields. season format like "2024-25".`;

    const geminiRes = await fetch(geminiUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [
          {
            parts: [
              { text: prompt },
              {
                inline_data: {
                  mime_type: "image/jpeg",
                  data: imageBase64,
                },
              },
            ],
          },
        ],
        generationConfig: {
          responseMimeType: "application/json",
        },
      }),
    });

    if (!geminiRes.ok) {
      const errText = await geminiRes.text();
      console.error("Gemini error", geminiRes.status, errText);
      return jsonError("vision model failed", 502);
    }

    const geminiJson = await geminiRes.json();
    const text =
      geminiJson?.candidates?.[0]?.content?.parts?.[0]?.text ?? "{}";
    const parsed = JSON.parse(text) as Partial<RecognitionResponse>;

    const response: RecognitionResponse = {
      team: asStringOrNull(parsed.team),
      league: asStringOrNull(parsed.league),
      season: asStringOrNull(parsed.season),
      playerName: asStringOrNull(parsed.playerName),
      number: parsed.number != null ? String(parsed.number) : null,
      confidence: clampConfidence(parsed.confidence),
    };

    return new Response(JSON.stringify(response), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (e) {
    console.error(e);
    return jsonError("internal error", 500);
  }
});

function asStringOrNull(value: unknown): string | null {
  if (value == null) return null;
  const s = String(value).trim();
  return s.length === 0 ? null : s;
}

function clampConfidence(value: unknown): number {
  const n = typeof value === "number" ? value : Number(value);
  if (Number.isNaN(n)) return 0;
  return Math.min(1, Math.max(0, n));
}

function jsonError(message: string, status: number) {
  return new Response(JSON.stringify({ error: message }), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
