import { describe, it, expect, vi } from 'vitest'
import { getUserProfile } from '../lib/profile'

function makeSupabaseMock(result: { data: unknown; error: unknown }) {
  return {
    from: vi.fn().mockReturnValue({
      select: vi.fn().mockReturnValue({
        eq: vi.fn().mockReturnValue({
          maybeSingle: vi.fn().mockResolvedValue(result),
        }),
      }),
    }),
  }
}

describe('getUserProfile', () => {
  it('returns profile when username exists', async () => {
    const mock = makeSupabaseMock({ data: { id: 'uuid-1', username: 'umut' }, error: null })
    const result = await getUserProfile(mock as never, 'umut')
    expect(result).toEqual({ id: 'uuid-1', username: 'umut' })
    expect(mock.from).toHaveBeenCalledWith('profiles')
  })

  it('returns null when username does not exist', async () => {
    const mock = makeSupabaseMock({ data: null, error: null })
    const result = await getUserProfile(mock as never, 'nonexistent')
    expect(result).toBeNull()
  })

  it('strips @ prefix from username before querying', async () => {
    const mock = makeSupabaseMock({ data: { id: 'uuid-2', username: 'umut' }, error: null })
    const result = await getUserProfile(mock as never, '@umut')
    expect(result).toEqual({ id: 'uuid-2', username: 'umut' })
    const eqCall = mock.from('profiles').select('id, username').eq
    expect(eqCall).toHaveBeenCalledWith('username', 'umut')
  })
})
