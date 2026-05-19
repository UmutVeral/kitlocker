import { notFound } from 'next/navigation'
import { cache } from 'react'
import type { Metadata } from 'next'
import { createAnonClient } from '@/lib/supabase'
import { getUserProfile } from '@/lib/profile'
import { getPublicLocker, deriveTopTeams } from '@/lib/locker'
import ProfileHeader from '@/components/ProfileHeader'
import KitGrid from '@/components/KitGrid'

const getProfileData = cache(async (username: string) => {
  const supabase = createAnonClient()
  const profile = await getUserProfile(supabase, username)
  if (!profile) return null
  const entries = await getPublicLocker(supabase, profile.id)
  return { profile, entries }
})

type Props = { params: Promise<{ username: string }> }

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { username } = await params
  const data = await getProfileData(username)
  if (!data) return { title: 'Profil bulunamadı' }

  const { profile, entries } = data
  const clean = profile.username
  const kitCount = entries.length
  const firstPhoto = entries.find((e) => e.photos.length > 0)?.photos[0]

  return {
    title: `${clean}'in Locker'ı — ${kitCount} kit | KitLocker`,
    description: `${clean} KitLocker'da ${kitCount} forma koleksiyonu paylaşıyor.`,
    openGraph: {
      title: `${clean}'in Locker'ı`,
      description: `${kitCount} forma koleksiyonu`,
      images: firstPhoto ? [{ url: firstPhoto }] : [],
      type: 'profile',
    },
    twitter: {
      card: 'summary_large_image',
      title: `${clean}'in Locker'ı — ${kitCount} kit`,
      description: `${clean} KitLocker'da ${kitCount} forma koleksiyonu paylaşıyor.`,
      images: firstPhoto ? [firstPhoto] : [],
    },
  }
}

export default async function ProfilePage({ params }: Props) {
  const { username } = await params
  const data = await getProfileData(username)
  if (!data) notFound()

  const { profile, entries } = data
  const topTeams = deriveTopTeams(entries)

  return (
    <main className="max-w-2xl mx-auto px-4 pb-16">
      <ProfileHeader
        username={profile.username}
        kitCount={entries.length}
        topTeams={topTeams}
      />
      <KitGrid entries={entries} />
    </main>
  )
}
