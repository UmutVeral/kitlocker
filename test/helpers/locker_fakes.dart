import 'package:kitlocker/features/locker/models/locker_condition.dart';
import 'package:kitlocker/features/locker/models/locker_entry.dart';
import 'package:kitlocker/features/locker/providers/locker_entries_notifier.dart';

class FakeLockerEntriesNotifier extends LockerEntriesNotifier {
  FakeLockerEntriesNotifier([List<LockerEntry> initial = const []])
      : _initial = List.of(initial);

  final List<LockerEntry> _initial;

  ({
    String teamName,
    String season,
    LockerCondition condition,
    String? playerName,
    String? number,
    String? notes,
  })? lastAddCall;
  String? lastRemoveCall;
  LockerEntry? lastUpdateCall;
  String? lastToggleFavouriteCall;

  @override
  List<LockerEntry> build() => List.of(_initial);

  @override
  Future<void> add({
    required String teamName,
    required String season,
    required LockerCondition condition,
    String? playerName,
    String? number,
    String? notes,
  }) async {
    lastAddCall = (
      teamName: teamName,
      season: season,
      condition: condition,
      playerName: playerName,
      number: number,
      notes: notes,
    );
    final entry = LockerEntry(
      id: 'fake-${state.length}',
      userId: 'fake-user',
      teamName: teamName,
      season: season,
      condition: condition,
      isFavourite: false,
      createdAt: DateTime.now(),
      playerName: playerName,
      number: number,
      notes: notes,
    );
    state = sortLockerEntries([entry, ...state]);
  }

  @override
  Future<void> remove(String id) async {
    lastRemoveCall = id;
    state = state.where((e) => e.id != id).toList();
  }

  @override
  Future<void> update(LockerEntry entry) async {
    lastUpdateCall = entry;
    state = sortLockerEntries(
      state.map((e) => e.id == entry.id ? entry : e).toList(),
    );
  }

  @override
  Future<void> toggleFavourite(String id) async {
    lastToggleFavouriteCall = id;
    final entry = state.firstWhere((e) => e.id == id);
    await update(entry.copyWith(isFavourite: !entry.isFavourite));
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
