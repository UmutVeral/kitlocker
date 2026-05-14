import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../providers/locker_entries_notifier.dart';

class LockerScreen extends ConsumerWidget {
  const LockerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(lockerEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          key: const Key('locker_kit_count'),
          '${entries.length} Kit',
        ),
      ),
      body: entries.isEmpty
          ? const Center(child: Text('Henüz kit eklenmedi.'))
          : GridView.builder(
              key: const Key('locker_grid'),
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return GestureDetector(
                  onTap: () => context.go(AppRoutes.lockerDetail(entry.id)),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (entry.isFavourite)
                          const Icon(Icons.star, color: Colors.amber),
                        Text(
                          entry.teamName,
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          entry.season,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        key: const Key('locker_add_button'),
        onPressed: () => context.go(AppRoutes.lockerAdd),
        child: const Icon(Icons.add),
      ),
    );
  }
}
