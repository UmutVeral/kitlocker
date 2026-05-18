import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitlocker/features/locker/models/locker_condition.dart';
import 'package:kitlocker/features/locker/models/locker_entry.dart';
import 'package:kitlocker/features/locker/providers/locker_entries_notifier.dart';
import 'photo_fakes.dart';

class FakeLockerEntriesNotifier extends LockerEntriesNotifier {
  FakeLockerEntriesNotifier([List<LockerEntry> initial = const []])
      : _initial = List.of(initial),
        super(
          photoRepository: FakePhotoRepository(),
          photoCompressor: FakePhotoCompressor(),
        );

  final List<LockerEntry> _initial;

  ({
    String teamName,
    String season,
    LockerCondition condition,
    String? kitCatalogId,
    String? leagueId,
    String? playerName,
    String? number,
    String? notes,
    List<String> photos,
  })? lastAddCall;
  String? lastRemoveCall;
  LockerEntry? lastUpdateCall;
  String? lastToggleFavouriteCall;

  @override
  Future<List<LockerEntry>> build() async => List.of(_initial);

  @override
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
    await add(
      teamName: teamName,
      season: season,
      condition: condition,
      kitCatalogId: kitCatalogId,
      leagueId: leagueId,
      playerName: playerName,
      number: number,
      notes: notes,
      photos: existingUrls,
    );
  }

  @override
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
    await updateEntry(existing.copyWith(
      teamName: teamName,
      season: season,
      condition: condition,
      playerName: playerName,
      number: number,
      notes: notes,
      photos: existingUrls,
    ));
  }

  @override
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
    lastAddCall = (
      teamName: teamName,
      season: season,
      condition: condition,
      kitCatalogId: kitCatalogId,
      leagueId: leagueId,
      playerName: playerName,
      number: number,
      notes: notes,
      photos: photos,
    );
    final entry = LockerEntry(
      id: 'fake-${state.valueOrNull?.length ?? 0}',
      userId: 'fake-user',
      kitCatalogId: kitCatalogId,
      leagueId: leagueId,
      teamName: teamName,
      season: season,
      condition: condition,
      isFavourite: false,
      createdAt: DateTime.now(),
      playerName: playerName,
      number: number,
      notes: notes,
      photos: photos,
    );
    final current = state.valueOrNull ?? [];
    state = AsyncData(sortLockerEntries([entry, ...current]));
  }

  @override
  Future<void> remove(String id) async {
    lastRemoveCall = id;
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.where((e) => e.id != id).toList());
  }

  @override
  Future<void> updateEntry(LockerEntry entry) async {
    lastUpdateCall = entry;
    final current = state.valueOrNull ?? [];
    state = AsyncData(sortLockerEntries(
      current.map((e) => e.id == entry.id ? entry : e).toList(),
    ));
  }

  @override
  Future<void> toggleFavourite(String id) async {
    lastToggleFavouriteCall = id;
    final current = state.valueOrNull ?? [];
    final entry = current.firstWhere((e) => e.id == id);
    await updateEntry(entry.copyWith(isFavourite: !entry.isFavourite));
  }
}

LockerEntry fakeEntry({
  String id = 'e1',
  String teamName = 'Galatasaray',
  String season = '2024-25',
  LockerCondition condition = LockerCondition.mint,
  bool isFavourite = false,
  DateTime? createdAt,
}) =>
    LockerEntry(
      id: id,
      userId: 'fake-user',
      teamName: teamName,
      season: season,
      condition: condition,
      isFavourite: isFavourite,
      createdAt: createdAt ?? DateTime(2025, 1, 1),
    );
