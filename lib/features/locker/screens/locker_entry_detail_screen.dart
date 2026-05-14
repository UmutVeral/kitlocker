import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/locker_entry.dart';
import '../providers/locker_entries_notifier.dart';
import 'locker_entry_form_screen.dart';

class LockerEntryDetailScreen extends ConsumerWidget {
  const LockerEntryDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(lockerEntriesProvider);

    if (entriesAsync.isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final entry = entriesAsync.valueOrNull?.where((e) => e.id == id).firstOrNull;

    if (entry == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Kit bulunamadı.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.teamName),
        actions: [
          IconButton(
            key: const Key('detail_favourite_button'),
            icon: Icon(
              entry.isFavourite ? Icons.star : Icons.star_border,
              color: entry.isFavourite ? Colors.amber : null,
            ),
            onPressed: () =>
                ref.read(lockerEntriesProvider.notifier).toggleFavourite(id),
          ),
          IconButton(
            key: const Key('detail_edit_button'),
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LockerEntryFormScreen(existing: entry),
              ),
            ),
          ),
          IconButton(
            key: const Key('detail_delete_button'),
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, ref, entry),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Row('Takım', entry.teamName),
          _Row('Sezon', entry.season),
          _Row('Durum', entry.condition.name),
          if (entry.playerName != null) _Row('Oyuncu', entry.playerName!),
          if (entry.number != null) _Row('Numara', entry.number!),
          if (entry.notes != null) _Row('Notlar', entry.notes!),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    LockerEntry entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kiti Sil'),
        content: Text('${entry.teamName} kitini silmek istiyor musun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          TextButton(
            key: const Key('confirm_delete_button'),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(lockerEntriesProvider.notifier).remove(entry.id);
      if (context.mounted) context.pop();
    }
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              child: Text(
                '$label:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );
}
