import type { SupabaseClient } from '@supabase/supabase-js'

export type UserProfile = {
  id: string
  username: string
}

export async function getUserProfile(
  supabase: SupabaseClient,
  username: string
): Promise<UserProfile | null> {
  const clean = username.replace(/^@/, '')
  const { data } = await supabase
    .from('profiles')
    .select('id, username')
    .eq('username', clean)
    .maybeSingle()
  return data ?? null
}
