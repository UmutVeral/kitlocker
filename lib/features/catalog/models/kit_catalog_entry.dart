import 'kit_type.dart';

class KitCatalogEntry {
  const KitCatalogEntry({
    required this.id,
    required this.teamName,
    required this.leagueId,
    required this.season,
    required this.kitType,
    this.imageUrl,
  });

  final String id;
  final String teamName;
  final String leagueId;
  final String season;
  final KitType kitType;
  final String? imageUrl;

  factory KitCatalogEntry.fromJson(Map<String, dynamic> json) => KitCatalogEntry(
        id: json['id'] as String,
        teamName: json['team_name'] as String,
        leagueId: json['league_id'] as String,
        season: json['season'] as String,
        kitType: KitType.values.byName(json['kit_type'] as String),
        imageUrl: json['image_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'team_name': teamName,
        'league_id': leagueId,
        'season': season,
        'kit_type': kitType.name,
        if (imageUrl != null) 'image_url': imageUrl,
      };
}
