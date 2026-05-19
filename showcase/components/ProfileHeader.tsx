type Props = {
  username: string
  kitCount: number
  topTeams: string[]
}

export default function ProfileHeader({ username, kitCount, topTeams }: Props) {
  return (
    <div className="flex flex-col items-center gap-4 py-8">
      <div className="w-20 h-20 rounded-full bg-gray-200 flex items-center justify-center text-3xl font-bold text-gray-500">
        {username[0].toUpperCase()}
      </div>
      <h1 className="text-xl font-semibold">@{username}</h1>
      <div className="flex gap-6 text-center">
        <div>
          <p className="text-2xl font-bold">{kitCount}</p>
          <p className="text-sm text-gray-500">kit</p>
        </div>
      </div>
      {topTeams.length > 0 && (
        <div data-testid="top-teams" className="flex flex-wrap gap-2 justify-center">
          {topTeams.map((team) => (
            <span key={team} className="px-3 py-1 bg-gray-100 rounded-full text-sm text-gray-700">
              {team}
            </span>
          ))}
        </div>
      )}
    </div>
  )
}
