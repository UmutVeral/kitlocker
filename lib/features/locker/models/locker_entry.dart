import 'locker_condition.dart';

class LockerEntry {
  const LockerEntry({
    required this.id,
    required this.userId,
    required this.teamName,
    required this.season,
    required this.condition,
    required this.isFavourite,
    required this.createdAt,
    this.kitCatalogId,
    this.leagueId,
    this.playerName,
    this.number,
    this.notes,
    this.photos = const [],
    this.visualizationUrl,
  });

  final String id;
  final String userId;
  final String? kitCatalogId;
  final String teamName;
  final String? leagueId;
  final String season;
  final String? playerName;
  final String? number;
  final LockerCondition condition;
  final String? notes;
  final List<String> photos;
  final String? visualizationUrl;
  final bool isFavourite;
  final DateTime createdAt;

  factory LockerEntry.fromJson(Map<String, dynamic> json) => LockerEntry(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        kitCatalogId: json['kit_catalog_id'] as String?,
        teamName: json['team_name'] as String,
        leagueId: json['league_id'] as String?,
        season: json['season'] as String,
        playerName: json['player_name'] as String?,
        number: json['number'] as String?,
        condition:
            LockerCondition.values.byName(json['condition'] as String),
        notes: json['notes'] as String?,
        photos: (json['photos'] as List<dynamic>?)?.cast<String>() ?? const [],
        visualizationUrl: json['visualization_url'] as String?,
        isFavourite: json['is_favourite'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        if (kitCatalogId != null) 'kit_catalog_id': kitCatalogId,
        'team_name': teamName,
        if (leagueId != null) 'league_id': leagueId,
        'season': season,
        if (playerName != null) 'player_name': playerName,
        if (number != null) 'number': number,
        'condition': condition.name,
        if (notes != null) 'notes': notes,
        'photos': photos,
        if (visualizationUrl != null) 'visualization_url': visualizationUrl,
        'is_favourite': isFavourite,
      };

  LockerEntry copyWith({
    String? id,
    String? userId,
    String? kitCatalogId,
    String? teamName,
    String? leagueId,
    String? season,
    String? playerName,
    String? number,
    LockerCondition? condition,
    String? notes,
    List<String>? photos,
    String? visualizationUrl,
    bool? isFavourite,
    DateTime? createdAt,
  }) =>
      LockerEntry(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        kitCatalogId: kitCatalogId ?? this.kitCatalogId,
        teamName: teamName ?? this.teamName,
        leagueId: leagueId ?? this.leagueId,
        season: season ?? this.season,
        playerName: playerName ?? this.playerName,
        number: number ?? this.number,
        condition: condition ?? this.condition,
        notes: notes ?? this.notes,
        photos: photos ?? this.photos,
        visualizationUrl: visualizationUrl ?? this.visualizationUrl,
        isFavourite: isFavourite ?? this.isFavourite,
        createdAt: createdAt ?? this.createdAt,
      );
}
