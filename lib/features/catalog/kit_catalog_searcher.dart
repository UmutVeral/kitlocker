import 'models/kit_catalog_entry.dart';
import 'models/kit_type.dart';

/// Client-side fuzzy search over a kit catalog snapshot.
class KitCatalogSearcher {
  const KitCatalogSearcher({this.maxResults = 20});

  final int maxResults;

  List<KitCatalogEntry> search(
    List<KitCatalogEntry> catalog, {
    required String teamQuery,
    String? season,
    KitType? kitType,
  }) {
    final query = teamQuery.trim();
    if (query.isEmpty) return const [];

    final scored = <({KitCatalogEntry entry, double score})>[];
    for (final entry in catalog) {
      if (season != null && entry.season != season) continue;
      if (kitType != null && entry.kitType != kitType) continue;

      final score = _teamMatchScore(query, entry.teamName);
      if (score > 0) scored.add((entry: entry, score: score));
    }

    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(maxResults).map((e) => e.entry).toList();
  }

  double _teamMatchScore(String query, String teamName) {
    final q = _normalize(query);
    final t = _normalize(teamName);
    if (q.isEmpty) return 0;

    if (t.contains(q)) return 1.0;

    final words = t.split(RegExp(r'\s+'));
    if (words.any((w) => w.startsWith(q))) return 0.9;

    final similarity = _trigramSimilarity(q, t);
    if (similarity >= 0.35) return similarity;

    return 0;
  }

  String _normalize(String value) {
    const trMap = {
      'ş': 's',
      'Ş': 's',
      'ğ': 'g',
      'Ğ': 'g',
      'ü': 'u',
      'Ü': 'u',
      'ö': 'o',
      'Ö': 'o',
      'ç': 'c',
      'Ç': 'c',
      'ı': 'i',
      'İ': 'i',
    };
    final lowered = value.toLowerCase();
    final buffer = StringBuffer();
    for (final rune in lowered.runes) {
      final ch = String.fromCharCode(rune);
      buffer.write(trMap[ch] ?? ch);
    }
    return buffer.toString().replaceAll(RegExp(r'[^a-z0-9\s]'), '');
  }

  double _trigramSimilarity(String a, String b) {
    if (a == b) return 1;
    if (a.length < 2 || b.length < 2) return a == b ? 1 : 0;

    final gramsA = _trigrams(a);
    final gramsB = _trigrams(b);
    final intersection = gramsA.intersection(gramsB).length;
    return (2 * intersection) / (gramsA.length + gramsB.length);
  }

  Set<String> _trigrams(String s) {
    final padded = '  $s ';
    return {
      for (var i = 0; i < padded.length - 2; i++) padded.substring(i, i + 3),
    };
  }
}
