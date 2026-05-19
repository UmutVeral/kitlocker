import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/features/locker/models/locker_condition.dart';
import 'package:kitlocker/features/locker/models/locker_entry.dart';
import 'package:kitlocker/features/locker/models/locker_filter.dart';
import 'package:kitlocker/features/locker/models/locker_sort_state.dart';
import 'package:kitlocker/features/locker/providers/locker_entries_notifier.dart';
import 'package:kitlocker/features/locker/providers/locker_filter_provider.dart';
import '../../helpers/locker_fakes.dart';

LockerEntry e({
  String id = 'e1',
  String team = 'Galatasaray',
  String season = '2024-25',
  String? league,
  String? player,
  bool fav = false,
  DateTime? date,
}) =>
    LockerEntry(
      id: id,
      userId: 'u',
      teamName: team,
      season: season,
      leagueId: league,
      playerName: player,
      condition: LockerCondition.mint,
      isFavourite: fav,
      createdAt: date ?? DateTime(2025, 1, 1),
    );

void main() {
  group('applyFilterAndSort', () {
    final gs = e(id: '1', team: 'Galatasaray', season: '2024-25');
    final bjk = e(id: '2', team: 'Beşiktaş', season: '2023-24');
    final fb = e(id: '3', team: 'Fenerbahçe', season: '2024-25');

    // --- filter ---

    test('no filter returns all entries', () {
      final result = applyFilterAndSort(
        [gs, bjk, fb],
        const LockerFilter(),
        const LockerSortState(),
      );
      expect(result, hasLength(3));
    });

    test('team filter returns only matching entries', () {
      final result = applyFilterAndSort(
        [gs, bjk, fb],
        const LockerFilter(team: 'Galatasaray'),
        const LockerSortState(favoritesFirst: false),
      );
      expect(result, hasLength(1));
      expect(result.first.teamName, 'Galatasaray');
    });

    test('team filter is case-insensitive', () {
      final result = applyFilterAndSort(
        [gs, bjk],
        const LockerFilter(team: 'galatasaray'),
        const LockerSortState(favoritesFirst: false),
      );
      expect(result, hasLength(1));
    });

    test('season filter returns only matching season', () {
      final result = applyFilterAndSort(
        [gs, bjk, fb],
        const LockerFilter(season: '2024-25'),
        const LockerSortState(favoritesFirst: false),
      );
      expect(result, hasLength(2));
      expect(result.every((e) => e.season == '2024-25'), isTrue);
    });

    test('multi-filter (team + season) uses AND logic', () {
      final result = applyFilterAndSort(
        [gs, bjk, fb],
        const LockerFilter(team: 'Galatasaray', season: '2024-25'),
        const LockerSortState(favoritesFirst: false),
      );
      expect(result, hasLength(1));
      expect(result.first.id, '1');
    });

    test('league filter matches leagueId exactly', () {
      final withLeague = e(id: '4', league: 'turkiye-super-lig');
      final noLeague = e(id: '5');
      final result = applyFilterAndSort(
        [withLeague, noLeague],
        const LockerFilter(league: 'turkiye-super-lig'),
        const LockerSortState(favoritesFirst: false),
      );
      expect(result, hasLength(1));
      expect(result.first.id, '4');
    });

    test('player filter returns only entries with matching playerName', () {
      final withPlayer = e(id: '6', player: 'Icardi');
      final noPlayer = e(id: '7');
      final result = applyFilterAndSort(
        [withPlayer, noPlayer],
        const LockerFilter(player: 'Icardi'),
        const LockerSortState(favoritesFirst: false),
      );
      expect(result, hasLength(1));
      expect(result.first.id, '6');
    });

    test('filter with no matches returns empty list', () {
      final result = applyFilterAndSort(
        [gs, bjk],
        const LockerFilter(team: 'Trabzonspor'),
        const LockerSortState(favoritesFirst: false),
      );
      expect(result, isEmpty);
    });

    // --- sort ---

    test('sort dateAdded: newest first', () {
      final old = e(id: 'old', date: DateTime(2024, 1, 1));
      final newer = e(id: 'new', date: DateTime(2025, 6, 1));
      final result = applyFilterAndSort(
        [old, newer],
        const LockerFilter(),
        const LockerSortState(
          option: LockerSortOption.dateAdded,
          favoritesFirst: false,
        ),
      );
      expect(result.first.id, 'new');
      expect(result.last.id, 'old');
    });

    test('sort teamAlphabetic: A→Z', () {
      final result = applyFilterAndSort(
        [gs, bjk, fb],
        const LockerFilter(),
        const LockerSortState(
          option: LockerSortOption.teamAlphabetic,
          favoritesFirst: false,
        ),
      );
      final names = result.map((e) => e.teamName).toList();
      expect(names, equals(List.of(names)..sort()));
    });

    test('sort seasonChronological: oldest season first', () {
      final s2022 = e(id: 'a', season: '2022-23');
      final s2023 = e(id: 'b', season: '2023-24');
      final s2024 = e(id: 'c', season: '2024-25');
      final result = applyFilterAndSort(
        [s2024, s2022, s2023],
        const LockerFilter(),
        const LockerSortState(
          option: LockerSortOption.seasonChronological,
          favoritesFirst: false,
        ),
      );
      expect(result.map((e) => e.season).toList(),
          equals(['2022-23', '2023-24', '2024-25']));
    });

    test('favoritesFirst: favorites appear before non-favorites', () {
      final fav = e(id: 'fav', fav: true, date: DateTime(2024, 1, 1));
      final notFav = e(id: 'notfav', fav: false, date: DateTime(2025, 1, 1));
      final result = applyFilterAndSort(
        [notFav, fav],
        const LockerFilter(),
        const LockerSortState(
          option: LockerSortOption.dateAdded,
          favoritesFirst: true,
        ),
      );
      expect(result.first.id, 'fav');
      expect(result.last.id, 'notfav');
    });

    test('favoritesFirst=false: sort order not affected by favourite flag',
        () {
      final fav = e(id: 'fav', fav: true, date: DateTime(2024, 1, 1));
      final notFav = e(id: 'notfav', fav: false, date: DateTime(2025, 1, 1));
      final result = applyFilterAndSort(
        [fav, notFav],
        const LockerFilter(),
        const LockerSortState(
          option: LockerSortOption.dateAdded,
          favoritesFirst: false,
        ),
      );
      expect(result.first.id, 'notfav'); // newer first
    });
  });

  group('filteredLockerEntriesProvider', () {
    final entries = [
      fakeEntry(id: '1', teamName: 'Galatasaray', season: '2024-25'),
      fakeEntry(id: '2', teamName: 'Beşiktaş', season: '2023-24'),
    ];

    ProviderContainer buildContainer({
      List<LockerEntry> initial = const [],
      LockerFilter filter = const LockerFilter(),
      LockerSortState sort = const LockerSortState(),
    }) {
      final container = ProviderContainer(
        overrides: [
          lockerEntriesProvider
              .overrideWith(() => FakeLockerEntriesNotifier(initial)),
          lockerFilterProvider.overrideWith((ref) => filter),
          lockerSortProvider.overrideWith((ref) => sort),
        ],
      );
      return container;
    }

    test('provider returns all entries when no filter', () async {
      final container = buildContainer(initial: entries);
      addTearDown(container.dispose);

      await container.read(lockerEntriesProvider.future);
      final result = container.read(filteredLockerEntriesProvider);

      expect(result, hasLength(2));
    });

    test('provider filters entries by team', () async {
      final container = buildContainer(
        initial: entries,
        filter: const LockerFilter(team: 'Galatasaray'),
      );
      addTearDown(container.dispose);

      await container.read(lockerEntriesProvider.future);
      final result = container.read(filteredLockerEntriesProvider);

      expect(result, hasLength(1));
      expect(result.first.teamName, 'Galatasaray');
    });
  });
}
