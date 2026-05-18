class KitRecognitionResult {
  const KitRecognitionResult({
    this.team,
    this.league,
    this.season,
    this.playerName,
    this.number,
    required this.confidence,
  });

  final String? team;
  final String? league;
  final String? season;
  final String? playerName;
  final String? number;
  final double confidence;

  factory KitRecognitionResult.fromJson(Map<String, dynamic> json) {
    return KitRecognitionResult(
      team: json['team'] as String?,
      league: json['league'] as String?,
      season: json['season'] as String?,
      playerName: json['playerName'] as String?,
      number: json['number']?.toString(),
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (team != null) 'team': team,
        if (league != null) 'league': league,
        if (season != null) 'season': season,
        if (playerName != null) 'playerName': playerName,
        if (number != null) 'number': number,
        'confidence': confidence,
      };
}
