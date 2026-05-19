import Image from 'next/image'
import type { LockerEntry } from '@/lib/locker'

export default function KitGrid({ entries }: { entries: LockerEntry[] }) {
  if (entries.length === 0) {
    return (
      <p className="text-center text-gray-500 py-12">Henüz kit yok</p>
    )
  }

  return (
    <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
      {entries.map((entry) => (
        <div key={entry.id} className="rounded-lg overflow-hidden bg-gray-100 aspect-square relative">
          {entry.photos.length > 0 ? (
            <Image
              src={entry.photos[0]}
              alt={`${entry.team_name} ${entry.season}`}
              fill
              className="object-cover"
              unoptimized
            />
          ) : (
            <div
              data-testid={`kit-placeholder-${entry.id}`}
              className="w-full h-full flex items-center justify-center text-gray-400"
            >
              <svg xmlns="http://www.w3.org/2000/svg" className="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>
          )}
          <div className="absolute bottom-0 inset-x-0 bg-gradient-to-t from-black/60 p-2">
            <p className="text-white text-xs font-medium truncate">{entry.team_name}</p>
            <p className="text-white/70 text-xs">{entry.season}</p>
          </div>
        </div>
      ))}
    </div>
  )
}
