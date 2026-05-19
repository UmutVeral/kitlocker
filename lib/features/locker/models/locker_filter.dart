class LockerFilter {
  const LockerFilter({
    this.team,
    this.league,
    this.season,
    this.player,
  });

  final String? team;
  final String? league;
  final String? season;
  final String? player;

  bool get isEmpty =>
      team == null && league == null && season == null && player == null;

  LockerFilter copyWith({
    Object? team = _sentinel,
    Object? league = _sentinel,
    Object? season = _sentinel,
    Object? player = _sentinel,
  }) =>
      LockerFilter(
        team: team == _sentinel ? this.team : team as String?,
        league: league == _sentinel ? this.league : league as String?,
        season: season == _sentinel ? this.season : season as String?,
        player: player == _sentinel ? this.player : player as String?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LockerFilter &&
          team == other.team &&
          league == other.league &&
          season == other.season &&
          player == other.player;

  @override
  int get hashCode => Object.hash(team, league, season, player);
}

const _sentinel = Object();
