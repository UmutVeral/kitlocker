import { describe, it, expect } from 'vitest'
import { render, screen } from '@testing-library/react'
import ProfileHeader from '../components/ProfileHeader'

describe('ProfileHeader', () => {
  it('shows username', () => {
    render(<ProfileHeader username="umut" kitCount={42} topTeams={[]} />)
    expect(screen.getByText('@umut')).toBeInTheDocument()
  })

  it('shows kit count', () => {
    render(<ProfileHeader username="umut" kitCount={42} topTeams={[]} />)
    expect(screen.getByText('42')).toBeInTheDocument()
  })

  it('shows top teams', () => {
    render(<ProfileHeader username="umut" kitCount={5} topTeams={['Galatasaray', 'Fenerbahçe']} />)
    expect(screen.getByText('Galatasaray')).toBeInTheDocument()
    expect(screen.getByText('Fenerbahçe')).toBeInTheDocument()
  })

  it('hides top teams section when no teams', () => {
    render(<ProfileHeader username="umut" kitCount={0} topTeams={[]} />)
    expect(screen.queryByTestId('top-teams')).not.toBeInTheDocument()
  })
})
