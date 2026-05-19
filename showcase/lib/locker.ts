import type { SupabaseClient } from '@supabase/supabase-js'

export type LockerEntry = {
  id: string
  team_name: string
  season: string
  player_name: string | null
  number: string | null
  photos: string[]
  is_favourite: boolean
  created_at: string
}

export async function getPublicLocker(
  supabase: SupabaseClient,
  userId: string
): Promise<LockerEntry[]> {
  const { data } = await supabase
    .from('locker_entries')
    .select('id, team_name, season, player_name, number, photos, is_favourite, created_at')
    .eq('user_id', userId)
  return data ?? []
}

export function deriveTopTeams(entries: LockerEntry[]): string[] {
  const counts = new Map<string, number>()
  for (const e of entries) {
    counts.set(e.team_name, (counts.get(e.team_name) ?? 0) + 1)
  }
  return [...counts.entries()]
    .sort((a, b) => b[1] - a[1])
    .slice(0, 3)
    .map(([team]) => team)
}
