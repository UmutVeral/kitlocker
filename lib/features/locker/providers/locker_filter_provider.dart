import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/locker_entry.dart';
import '../models/locker_filter.dart';
import '../models/locker_sort_state.dart';
import 'locker_entries_notifier.dart';

final lockerFilterProvider =
    StateProvider<LockerFilter>((ref) => const LockerFilter());

final lockerSortProvider =
    StateProvider<LockerSortState>((ref) => const LockerSortState());

final filteredLockerEntriesProvider = Provider<List<LockerEntry>>((ref) {
  final entries = ref.watch(lockerEntriesProvider).valueOrNull ?? [];
  final filter = ref.watch(lockerFilterProvider);
  final sort = ref.watch(lockerSortProvider);
  return applyFilterAndSort(entries, filter, sort);
});

List<LockerEntry> applyFilterAndSort(
  List<LockerEntry> entries,
  LockerFilter filter,
  LockerSortState sort,
) {
  final filtered = entries.where((entry) {
    if (filter.team != null &&
        !entry.teamName
            .toLowerCase()
            .contains(filter.team!.toLowerCase())) {
      return false;
    }
    if (filter.league != null && entry.leagueId != filter.league) {
      return false;
    }
    if (filter.season != null && entry.season != filter.season) {
      return false;
    }
    if (filter.player != null &&
        (entry.playerName == null ||
            !entry.playerName!
                .toLowerCase()
                .contains(filter.player!.toLowerCase()))) {
      return false;
    }
    return true;
  }).toList();

  filtered.sort((a, b) {
    if (sort.favoritesFirst) {
      final cmp = _compareFavourites(a, b);
      if (cmp != 0) return cmp;
    }
    return switch (sort.option) {
      LockerSortOption.dateAdded => b.createdAt.compareTo(a.createdAt),
      LockerSortOption.teamAlphabetic => a.teamName.compareTo(b.teamName),
      LockerSortOption.seasonChronological => a.season.compareTo(b.season),
    };
  });

  return filtered;
}

int _compareFavourites(LockerEntry a, LockerEntry b) {
  if (a.isFavourite && !b.isFavourite) return -1;
  if (!a.isFavourite && b.isFavourite) return 1;
  return 0;
}
