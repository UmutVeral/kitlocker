import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/features/locker/models/locker_condition.dart';
import 'package:kitlocker/features/locker/providers/locker_entries_notifier.dart';
import '../../helpers/locker_fakes.dart';

ProviderContainer _container([List<dynamic> initial = const []]) {
  final c = ProviderContainer(overrides: [
    lockerEntriesProvider
        .overrideWith(() => FakeLockerEntriesNotifier(List.of(initial.cast()))),
  ]);
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('sortLockerEntries', () {
    test('favoriler önce gelir', () {
      final fav = fakeEntry(id: 'fav', isFavourite: true);
      final notFav = fakeEntry(id: 'nf', isFavourite: false);

      final sorted = sortLockerEntries([notFav, fav]);

      expect(sorted.first.id, 'fav');
    });

    test('aynı favori durumunda yeniler önce gelir', () {
      final older = fakeEntry(id: 'old', createdAt: DateTime(2024));
      final newer = fakeEntry(id: 'new', createdAt: DateTime(2025));

      final sorted = sortLockerEntries([older, newer]);

      expect(sorted.first.id, 'new');
    });
  });

  group('LockerEntriesNotifier — state transitions', () {
    test('başlangıçta liste boştur', () {
      final c = _container();
      expect(c.read(lockerEntriesProvider), isEmpty);
    });

    test('add() sonrası yeni entry state\'e eklenir', () async {
      final c = _container();
      await c.read(lockerEntriesProvider.notifier).add(
            teamName: 'Galatasaray',
            season: '2024-25',
            condition: LockerCondition.mint,
          );

      final entries = c.read(lockerEntriesProvider);
      expect(entries, hasLength(1));
      expect(entries.first.teamName, 'Galatasaray');
      expect(entries.first.season, '2024-25');
      expect(entries.first.condition, LockerCondition.mint);
    });

    test('remove() sonrası entry state\'den düşer', () async {
      final c = _container([fakeEntry(id: 'e1')]);
      await c.read(lockerEntriesProvider.notifier).remove('e1');

      expect(c.read(lockerEntriesProvider), isEmpty);
    });

    test('update() sonrası değişiklik state\'e yansır', () async {
      final entry = fakeEntry(id: 'e1', teamName: 'Galatasaray');
      final c = _container([entry]);
      await c.read(lockerEntriesProvider.notifier).update(
            entry.copyWith(teamName: 'Fenerbahçe'),
          );

      expect(c.read(lockerEntriesProvider).first.teamName, 'Fenerbahçe');
    });

    test('toggleFavourite() isFavourite değerini tersine çevirir', () async {
      final entry = fakeEntry(id: 'e1', isFavourite: false);
      final c = _container([entry]);
      await c.read(lockerEntriesProvider.notifier).toggleFavourite('e1');

      expect(c.read(lockerEntriesProvider).first.isFavourite, isTrue);
    });

    test('favori ekleme sonrası favori entry listenin başına geçer', () async {
      final notFav = fakeEntry(id: 'nf', isFavourite: false);
      final fav = fakeEntry(id: 'fav', isFavourite: false);
      final c = _container([notFav, fav]);
      await c.read(lockerEntriesProvider.notifier).toggleFavourite('fav');

      expect(c.read(lockerEntriesProvider).first.id, 'fav');
    });
  });
}
