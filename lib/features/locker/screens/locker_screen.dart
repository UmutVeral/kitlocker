import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../models/locker_entry.dart';
import '../models/locker_filter.dart';
import '../models/locker_sort_state.dart';
import '../providers/locker_entries_notifier.dart';
import '../providers/locker_filter_provider.dart';

class LockerScreen extends ConsumerWidget {
  const LockerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allEntriesAsync = ref.watch(lockerEntriesProvider);
    final filteredEntries = ref.watch(filteredLockerEntriesProvider);
    final filter = ref.watch(lockerFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          key: const Key('locker_kit_count'),
          allEntriesAsync.maybeWhen(
            data: (_) => '${filteredEntries.length} Kit',
            orElse: () => 'Locker',
          ),
        ),
        actions: [
          IconButton(
            key: const Key('locker_filter_button'),
            icon: Badge(
              isLabelVisible: !filter.isEmpty,
              child: const Icon(Icons.filter_list),
            ),
            onPressed: () => _showFilterSheet(context, ref),
          ),
          IconButton(
            key: const Key('locker_sort_button'),
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!filter.isEmpty)
            _ActiveFilterChips(
              filter: filter,
              onFilterChanged: (f) =>
                  ref.read(lockerFilterProvider.notifier).state = f,
            ),
          Expanded(
            child: allEntriesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(
                child: TextButton.icon(
                  onPressed: () => ref.invalidate(lockerEntriesProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tekrar Dene'),
                ),
              ),
              data: (allEntries) {
                if (allEntries.isEmpty) {
                  return const Center(
                    child: Text('Henüz kit eklenmedi.'),
                  );
                }
                if (filteredEntries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          key: Key('locker_empty_filter_text'),
                          'Sonuç bulunamadı.',
                        ),
                        TextButton(
                          key: const Key('locker_clear_filters_button'),
                          onPressed: () {
                            ref.read(lockerFilterProvider.notifier).state =
                                const LockerFilter();
                          },
                          child: const Text('Filtreleri Temizle'),
                        ),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  key: const Key('locker_grid'),
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredEntries.length,
                  itemBuilder: (context, index) =>
                      _KitCard(entry: filteredEntries[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('locker_add_button'),
        onPressed: () => context.go(AppRoutes.lockerAdd),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.read(lockerFilterProvider);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _FilterSheet(initialFilter: currentFilter),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const _SortSheet(),
    );
  }
}

// — Filter chips row (active filters) —

class _ActiveFilterChips extends StatelessWidget {
  const _ActiveFilterChips({
    required this.filter,
    required this.onFilterChanged,
  });

  final LockerFilter filter;
  final ValueChanged<LockerFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          if (filter.team != null)
            _chip(
              'Takım: ${filter.team}',
              () => onFilterChanged(filter.copyWith(team: null)),
            ),
          if (filter.season != null)
            _chip(
              'Sezon: ${filter.season}',
              () => onFilterChanged(filter.copyWith(season: null)),
            ),
          if (filter.league != null)
            _chip(
              'Lig: ${filter.league}',
              () => onFilterChanged(filter.copyWith(league: null)),
            ),
          if (filter.player != null)
            _chip(
              'Oyuncu: ${filter.player}',
              () => onFilterChanged(filter.copyWith(player: null)),
            ),
        ],
      ),
    );
  }

  Widget _chip(String label, VoidCallback onDelete) => Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Chip(
          label: Text(label),
          onDeleted: onDelete,
        ),
      );
}

// — Filter bottom sheet —

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initialFilter});

  final LockerFilter initialFilter;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late final TextEditingController _team;
  late final TextEditingController _season;
  late final TextEditingController _league;
  late final TextEditingController _player;

  @override
  void initState() {
    super.initState();
    _team = TextEditingController(text: widget.initialFilter.team ?? '');
    _season = TextEditingController(text: widget.initialFilter.season ?? '');
    _league = TextEditingController(text: widget.initialFilter.league ?? '');
    _player = TextEditingController(text: widget.initialFilter.player ?? '');
  }

  @override
  void dispose() {
    _team.dispose();
    _season.dispose();
    _league.dispose();
    _player.dispose();
    super.dispose();
  }

  String? _nullIfEmpty(String s) => s.trim().isEmpty ? null : s.trim();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (ctx, ref, _) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.viewInsetsOf(ctx).bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Filtrele', style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              key: const Key('filter_team_field'),
              controller: _team,
              decoration: const InputDecoration(labelText: 'Takım'),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('filter_season_field'),
              controller: _season,
              decoration: const InputDecoration(labelText: 'Sezon'),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('filter_league_field'),
              controller: _league,
              decoration: const InputDecoration(labelText: 'Lig'),
            ),
            const SizedBox(height: 8),
            TextField(
              key: const Key('filter_player_field'),
              controller: _player,
              decoration: const InputDecoration(labelText: 'Oyuncu'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    key: const Key('filter_clear_button'),
                    onPressed: () {
                      ref.read(lockerFilterProvider.notifier).state =
                          const LockerFilter();
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Temizle'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    key: const Key('filter_apply_button'),
                    onPressed: () {
                      ref.read(lockerFilterProvider.notifier).state =
                          LockerFilter(
                        team: _nullIfEmpty(_team.text),
                        season: _nullIfEmpty(_season.text),
                        league: _nullIfEmpty(_league.text),
                        player: _nullIfEmpty(_player.text),
                      );
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Uygula'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// — Sort bottom sheet —

class _SortSheet extends ConsumerWidget {
  const _SortSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(lockerSortProvider);

    void update(LockerSortState updated) =>
        ref.read(lockerSortProvider.notifier).state = updated;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child:
                Text('Sırala', style: Theme.of(context).textTheme.titleMedium),
          ),
          RadioListTile<LockerSortOption>(
            key: const Key('sort_date'),
            title: const Text('Tarihe Göre (en yeni)'),
            value: LockerSortOption.dateAdded,
            groupValue: sort.option,
            onChanged: (v) => update(sort.copyWith(option: v)),
          ),
          RadioListTile<LockerSortOption>(
            key: const Key('sort_team'),
            title: const Text('Takım (A→Z)'),
            value: LockerSortOption.teamAlphabetic,
            groupValue: sort.option,
            onChanged: (v) => update(sort.copyWith(option: v)),
          ),
          RadioListTile<LockerSortOption>(
            key: const Key('sort_season'),
            title: const Text('Sezon (eskiden yeniye)'),
            value: LockerSortOption.seasonChronological,
            groupValue: sort.option,
            onChanged: (v) => update(sort.copyWith(option: v)),
          ),
          SwitchListTile(
            key: const Key('sort_favorites_first'),
            title: const Text('Favoriler Önce'),
            value: sort.favoritesFirst,
            onChanged: (v) => update(sort.copyWith(favoritesFirst: v)),
          ),
        ],
      ),
    );
  }
}

// — Kit card —

class _KitCard extends StatelessWidget {
  const _KitCard({required this.entry});

  final LockerEntry entry;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.go(AppRoutes.lockerDetail(entry.id)),
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: entry.photos.isNotEmpty
                    ? Image.network(
                        entry.photos.first,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) =>
                            const _PhotoPlaceholder(),
                      )
                    : const _PhotoPlaceholder(),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    if (entry.isFavourite)
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(
                      entry.teamName,
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      entry.season,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.checkroom, size: 48, color: Colors.grey),
        ),
      );
}
