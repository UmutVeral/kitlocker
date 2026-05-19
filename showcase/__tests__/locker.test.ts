import { describe, it, expect, vi } from 'vitest'
import { getPublicLocker, deriveTopTeams } from '../lib/locker'
import type { LockerEntry } from '../lib/locker'

function makeEntry(team_name: string, overrides: Partial<LockerEntry> = {}): LockerEntry {
  return {
    id: Math.random().toString(),
    team_name,
    season: '2024-25',
    player_name: null,
    number: null,
    photos: [],
    is_favourite: false,
    created_at: '2024-01-01T00:00:00Z',
    ...overrides,
  }
}

describe('getPublicLocker', () => {
  it('returns entries for userId', async () => {
    const entries = [makeEntry('Galatasaray', { photos: ['url1'] })]
    const mock = {
      from: vi.fn().mockReturnValue({
        select: vi.fn().mockReturnValue({
          eq: vi.fn().mockResolvedValue({ data: entries, error: null }),
        }),
      }),
    }
    const result = await getPublicLocker(mock as never, 'user-1')
    expect(result).toEqual(entries)
    expect(mock.from).toHaveBeenCalledWith('locker_entries')
  })

  it('returns empty array when user has no entries', async () => {
    const mock = {
      from: vi.fn().mockReturnValue({
        select: vi.fn().mockReturnValue({
          eq: vi.fn().mockResolvedValue({ data: [], error: null }),
        }),
      }),
    }
    const result = await getPublicLocker(mock as never, 'user-empty')
    expect(result).toEqual([])
  })
})

describe('deriveTopTeams', () => {
  it('returns top 3 teams by kit count', () => {
    const entries = [
      makeEntry('Galatasaray'),
      makeEntry('Galatasaray'),
      makeEntry('Galatasaray'),
      makeEntry('Fenerbahçe'),
      makeEntry('Fenerbahçe'),
      makeEntry('Beşiktaş'),
      makeEntry('Trabzonspor'),
    ]
    expect(deriveTopTeams(entries)).toEqual(['Galatasaray', 'Fenerbahçe', 'Beşiktaş'])
  })

  it('returns fewer than 3 when locker has fewer teams', () => {
    const entries = [makeEntry('Galatasaray'), makeEntry('Fenerbahçe')]
    expect(deriveTopTeams(entries)).toEqual(['Galatasaray', 'Fenerbahçe'])
  })

  it('returns empty array for empty locker', () => {
    expect(deriveTopTeams([])).toEqual([])
  })

  it('breaks ties by first occurrence', () => {
    const entries = [makeEntry('A'), makeEntry('B'), makeEntry('A'), makeEntry('B')]
    const result = deriveTopTeams(entries)
    expect(result).toHaveLength(2)
    expect(result).toContain('A')
    expect(result).toContain('B')
  })
})
