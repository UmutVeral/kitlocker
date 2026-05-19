import { describe, it, expect } from 'vitest'
import { render, screen } from '@testing-library/react'
import KitGrid from '../components/KitGrid'
import type { LockerEntry } from '../lib/locker'

function makeEntry(overrides: Partial<LockerEntry> = {}): LockerEntry {
  return {
    id: '1',
    team_name: 'Galatasaray',
    season: '2024-25',
    player_name: null,
    number: null,
    photos: [],
    is_favourite: false,
    created_at: '2024-01-01T00:00:00Z',
    ...overrides,
  }
}

describe('KitGrid', () => {
  it('renders a kit card for each entry', () => {
    const entries = [
      makeEntry({ id: '1', team_name: 'Galatasaray', photos: ['https://example.com/kit1.jpg'] }),
      makeEntry({ id: '2', team_name: 'Fenerbahçe', photos: [] }),
    ]
    render(<KitGrid entries={entries} />)
    expect(screen.getByText('Galatasaray')).toBeInTheDocument()
    expect(screen.getByText('Fenerbahçe')).toBeInTheDocument()
  })

  it('shows placeholder when entry has no photos', () => {
    const entries = [makeEntry({ id: '1', photos: [] })]
    render(<KitGrid entries={entries} />)
    expect(screen.getByTestId('kit-placeholder-1')).toBeInTheDocument()
  })

  it('shows kit photo when entry has photos', () => {
    const entries = [makeEntry({ id: '1', photos: ['https://example.com/kit.jpg'] })]
    render(<KitGrid entries={entries} />)
    const img = screen.getByRole('img')
    expect(img).toHaveAttribute('src', expect.stringContaining('kit.jpg'))
  })

  it('shows empty state when no entries', () => {
    render(<KitGrid entries={[]} />)
    expect(screen.getByText(/henüz kit yok/i)).toBeInTheDocument()
  })
})
