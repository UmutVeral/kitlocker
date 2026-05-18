import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../models/locker_entry.dart';
import '../providers/locker_entries_notifier.dart';

class LockerScreen extends ConsumerWidget {
  const LockerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(lockerEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          key: const Key('locker_kit_count'),
          entriesAsync.maybeWhen(
            data: (entries) => '${entries.length} Kit',
            orElse: () => 'Locker',
          ),
        ),
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: TextButton.icon(
            onPressed: () => ref.invalidate(lockerEntriesProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
          ),
        ),
        data: (entries) => entries.isEmpty
            ? const Center(child: Text('Henüz kit eklenmedi.'))
            : GridView.builder(
                key: const Key('locker_grid'),
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: entries.length,
                itemBuilder: (context, index) =>
                    _KitCard(entry: entries[index]),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('locker_add_button'),
        onPressed: () => context.go(AppRoutes.lockerAdd),
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
                        errorBuilder: (_, __, ___) => const _PhotoPlaceholder(),
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
