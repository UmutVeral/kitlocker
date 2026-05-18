// ignore_for_file: avoid_print
//
// Idempotent FKAPI → kit_catalog seed.
//
// Usage:
//   FKAPI_BASE_URL=https://... \
//   SUPABASE_URL=https://... \
//   SUPABASE_SERVICE_ROLE_KEY=... \
//   dart run tool/seed_kit_catalog.dart
//
// Without FKAPI_BASE_URL, seeds a minimal dev fixture (Super Lig sample).

import 'dart:convert';
import 'dart:io';

const _targetLeagues = [
  'Süper Lig',
  'Super Lig',
  'Premier League',
  'La Liga',
  'Bundesliga',
  'Serie A',
  'Ligue 1',
];

Future<void> main() async {
  final supabaseUrl = Platform.environment['SUPABASE_URL'];
  final serviceKey = Platform.environment['SUPABASE_SERVICE_ROLE_KEY'];
  if (supabaseUrl == null || serviceKey == null) {
    stderr.writeln('SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are required.');
    exit(1);
  }

  final fkapiBase = Platform.environment['FKAPI_BASE_URL'];
  final rows = fkapiBase == null
      ? _devFixtureRows()
      : await _fetchFromFkapi(fkapiBase);

  var inserted = 0;
  for (final row in rows) {
    final res = await _upsertRow(supabaseUrl, serviceKey, row);
    if (res) inserted++;
  }
  print('Seed complete: $inserted/${rows.length} rows upserted.');
}

List<Map<String, dynamic>> _devFixtureRows() => [
      {
        'fkapi_kit_id': 'dev-gs-2024-25-home',
        'team_name': 'Galatasaray',
        'league_id': 'super-lig',
        'season': '2024-25',
        'kit_type': 'home',
        'image_url': null,
      },
      {
        'fkapi_kit_id': 'dev-fb-2024-25-home',
        'team_name': 'Fenerbahçe',
        'league_id': 'super-lig',
        'season': '2024-25',
        'kit_type': 'home',
        'image_url': null,
      },
      {
        'fkapi_kit_id': 'dev-bjk-2024-25-home',
        'team_name': 'Beşiktaş',
        'league_id': 'super-lig',
        'season': '2024-25',
        'kit_type': 'home',
        'image_url': null,
      },
    ];

Future<List<Map<String, dynamic>>> _fetchFromFkapi(String baseUrl) async {
  final client = HttpClient();
  try {
    final competitions = await _getJson(
      client,
      '$baseUrl/api/competitions?limit=500',
    );
    final items = (competitions['items'] as List?) ?? competitions as List;
    final leagueIds = <String>[];
    for (final item in items) {
      final map = item as Map<String, dynamic>;
      final name = (map['name'] as String?) ?? '';
      if (_targetLeagues.any((l) => name.toLowerCase().contains(l.toLowerCase()))) {
        leagueIds.add(map['id'].toString());
      }
    }

    final rows = <Map<String, dynamic>>[];
    for (final leagueId in leagueIds) {
      final kits = await _getJson(
        client,
        '$baseUrl/api/competitions/$leagueId/kits?limit=500',
      );
      final kitItems = (kits['items'] as List?) ?? kits as List;
      for (final kit in kitItems) {
        final k = kit as Map<String, dynamic>;
        rows.add(_mapFkapiKit(k, leagueId));
      }
    }
    return rows;
  } finally {
    client.close();
  }
}

Map<String, dynamic> _mapFkapiKit(Map<String, dynamic> kit, String leagueId) {
  final typeRaw = (kit['type'] as String?) ?? (kit['kit_type'] as String?) ?? 'home';
  final kitType = switch (typeRaw.toLowerCase()) {
    'away' => 'away',
    'third' || 'alternate' => 'third',
    _ => 'home',
  };
  return {
    'fkapi_kit_id': kit['id'].toString(),
    'team_name': kit['club_name'] ?? kit['team_name'] ?? 'Unknown',
    'league_id': leagueId,
    'season': kit['season_name'] ?? kit['season'] ?? '',
    'kit_type': kitType,
    'image_url': kit['image_url'] ?? kit['image'],
  };
}

Future<Map<String, dynamic>> _getJson(HttpClient client, String url) async {
  final request = await client.getUrl(Uri.parse(url));
  final response = await request.close();
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw HttpException('GET $url failed: ${response.statusCode}');
  }
  final body = await response.transform(utf8.decoder).join();
  return jsonDecode(body) as Map<String, dynamic>;
}

Future<bool> _upsertRow(
  String supabaseUrl,
  String serviceKey,
  Map<String, dynamic> row,
) async {
  final client = HttpClient();
  try {
    final uri =
        Uri.parse('$supabaseUrl/rest/v1/kit_catalog?on_conflict=fkapi_kit_id');
    final request = await client.postUrl(uri);
    request.headers.set('apikey', serviceKey);
    request.headers.set('Authorization', 'Bearer $serviceKey');
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Prefer', 'resolution=merge-duplicates');
    request.write(jsonEncode(row));
    final response = await request.close();
    return response.statusCode >= 200 && response.statusCode < 300;
  } finally {
    client.close();
  }
}
