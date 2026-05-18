import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../photos/flutter_image_compress_photo_compressor.dart';
import '../../photos/photo_compressor.dart';
import '../../photos/photo_repository.dart';
import '../../photos/supabase_photo_repository.dart';
import '../models/locker_condition.dart';
import '../models/locker_entry.dart';

List<LockerEntry> sortLockerEntries(List<LockerEntry> entries) {
  return [...entries]..sort((a, b) {
      if (a.isFavourite == b.isFavourite) {
        return b.createdAt.compareTo(a.createdAt);
      }
      return a.isFavourite ? -1 : 1;
    });
}

class LockerEntriesNotifier extends AsyncNotifier<List<LockerEntry>> {
  LockerEntriesNotifier({
    required PhotoRepository photoRepository,
    required PhotoCompressor photoCompressor,
  })  : _photoRepository = photoRepository,
        _photoCompressor = photoCompressor;

  final PhotoRepository _photoRepository;
  final PhotoCompressor _photoCompressor;

  sb.SupabaseClient get _supabase => sb.Supabase.instance.client;

  @override
  Future<List<LockerEntry>> build() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];
    final data = await _supabase
        .from('locker_entries')
        .select()
        .eq('user_id', userId);
    final entries = (data as List)
        .map((e) => LockerEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    return sortLockerEntries(entries);
  }

  Future<List<String>> _uploadNewPhotos(List<XFile> newPhotos) async {
    final userId = _supabase.auth.currentUser!.id;
    final urls = <String>[];
    for (final xfile in newPhotos) {
      final bytes = await xfile.readAsBytes();
      final compressed = await _photoCompressor.compress(bytes);
      urls.add(await _photoRepository.uploadPhoto(compressed, userId));
    }
    return urls;
  }

  Future<void> addWithPhotos({
    required List<XFile> newPhotos,
    required List<String> existingUrls,
    required String teamName,
    required String season,
    required LockerCondition condition,
    String? kitCatalogId,
    String? leagueId,
    String? playerName,
    String? number,
    String? notes,
  }) async {
    final newUrls = await _uploadNewPhotos(newPhotos);
    await add(
      teamName: teamName,
      season: season,
      condition: condition,
      kitCatalogId: kitCatalogId,
      leagueId: leagueId,
      playerName: playerName,
      number: number,
      notes: notes,
      photos: [...existingUrls, ...newUrls],
    );
  }

  Future<void> updateEntryWithPhotos({
    required LockerEntry existing,
    required List<XFile> newPhotos,
    required List<String> existingUrls,
    required String teamName,
    required String season,
    required LockerCondition condition,
    String? playerName,
    String? number,
    String? notes,
  }) async {
    final newUrls = await _uploadNewPhotos(newPhotos);
    await updateEntry(existing.copyWith(
      teamName: teamName,
      season: season,
      condition: condition,
      playerName: playerName,
      number: number,
      notes: notes,
      photos: [...existingUrls, ...newUrls],
    ));
  }

  Future<void> add({
    required String teamName,
    required String season,
    required LockerCondition condition,
    String? kitCatalogId,
    String? leagueId,
    String? playerName,
    String? number,
    String? notes,
    List<String> photos = const [],
  }) async {
    final userId = _supabase.auth.currentUser!.id;
    final data = await _supabase
        .from('locker_entries')
        .insert({
          'user_id': userId,
          'kit_catalog_id': ?kitCatalogId,
          'team_name': teamName,
          'league_id': ?leagueId,
          'season': season,
          'condition': condition.name,
          'player_name': ?playerName,
          'number': ?number,
          'notes': ?notes,
          'photos': photos,
        })
        .select()
        .single();
    final entry = LockerEntry.fromJson(data);
    state = AsyncData(sortLockerEntries([entry, ...state.requireValue]));
  }

  Future<void> remove(String id) async {
    await _supabase.from('locker_entries').delete().eq('id', id);
    state = AsyncData(state.requireValue.where((e) => e.id != id).toList());
  }

  Future<void> updateEntry(LockerEntry entry) async {
    await _supabase
        .from('locker_entries')
        .update(entry.toJson())
        .eq('id', entry.id);
    state = AsyncData(sortLockerEntries(
      state.requireValue.map((e) => e.id == entry.id ? entry : e).toList(),
    ));
  }

  Future<void> toggleFavourite(String id) async {
    final entry = state.requireValue.firstWhere((e) => e.id == id);
    await updateEntry(entry.copyWith(isFavourite: !entry.isFavourite));
  }
}

final lockerEntriesProvider =
    AsyncNotifierProvider<LockerEntriesNotifier, List<LockerEntry>>(
  () => LockerEntriesNotifier(
    photoRepository: SupabasePhotoRepository(sb.Supabase.instance.client),
    photoCompressor: const FlutterImageCompressPhotoCompressor(),
  ),
);
