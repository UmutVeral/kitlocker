import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
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

  Future<void> add({
    required String teamName,
    required String season,
    required LockerCondition condition,
    String? playerName,
    String? number,
    String? notes,
  }) async {
    final userId = _supabase.auth.currentUser!.id;
    final data = await _supabase
        .from('locker_entries')
        .insert({
          'user_id': userId,
          'team_name': teamName,
          'season': season,
          'condition': condition.name,
          'player_name': ?playerName,
          'number': ?number,
          'notes': ?notes,
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
  LockerEntriesNotifier.new,
);
