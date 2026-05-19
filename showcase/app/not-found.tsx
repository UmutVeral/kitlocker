import Link from 'next/link'

export default function NotFound() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-8 text-center">
      <h1 className="text-4xl font-bold text-gray-900">404</h1>
      <p className="mt-2 text-lg text-gray-500">Bu profil bulunamadı.</p>
      <Link href="/" className="mt-6 text-sm text-blue-600 hover:underline">
        Ana sayfaya dön
      </Link>
    </main>
  )
}
