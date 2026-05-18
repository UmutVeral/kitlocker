import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitlocker/features/locker/models/locker_condition.dart';
import 'package:kitlocker/features/locker/models/locker_entry.dart';
import 'package:kitlocker/features/locker/providers/locker_entries_notifier.dart';
import 'package:kitlocker/features/locker/screens/locker_entry_form_screen.dart';
import 'package:kitlocker/features/locker/screens/locker_screen.dart';
import '../../helpers/locker_fakes.dart';
import '../../helpers/photo_fakes.dart';

class _ThrowingLockerEntriesNotifier extends LockerEntriesNotifier {
  _ThrowingLockerEntriesNotifier()
      : super(
          photoRepository: FakePhotoRepository(),
          photoCompressor: FakePhotoCompressor(),
        );

  @override
  Future<List<LockerEntry>> build() async => [];

  @override
  Future<void> addWithPhotos({
    required List<XFile> newPhotos,
    required List<String> existingUrls,
    required String teamName,
    required String season,
    required LockerCondition condition,
    String? playerName,
    String? number,
    String? notes,
  }) async =>
      throw Exception('upload failed');
}

List<Override> _formOverrides(LockerEntriesNotifier notifier) => [
      lockerEntriesProvider.overrideWith(() => notifier),
    ];

Widget _buildLockerApp(FakeLockerEntriesNotifier notifier) => ProviderScope(
      overrides: [lockerEntriesProvider.overrideWith(() => notifier)],
      child: const MaterialApp(home: LockerScreen()),
    );

Widget _buildFormApp(FakeLockerEntriesNotifier notifier) => ProviderScope(
      overrides: _formOverrides(notifier),
      child: const MaterialApp(home: LockerEntryFormScreen()),
    );

void main() {
  group('LockerScreen', () {
    testWidgets('boş locker\'da "Henüz kit eklenmedi" mesajı görünür',
        (tester) async {
      await tester.pumpWidget(_buildLockerApp(FakeLockerEntriesNotifier()));
      await tester.pumpAndSettle();

      expect(find.text('Henüz kit eklenmedi.'), findsOneWidget);
    });

    testWidgets('header\'da kit sayısı gösterilir', (tester) async {
      final notifier = FakeLockerEntriesNotifier([
        fakeEntry(id: 'e1', teamName: 'Galatasaray'),
        fakeEntry(id: 'e2', teamName: 'Fenerbahçe'),
      ]);
      await tester.pumpWidget(_buildLockerApp(notifier));
      await tester.pumpAndSettle();

      expect(find.text('2 Kit'), findsOneWidget);
    });

    testWidgets('kitler grid\'de takım adı ve sezon ile listelenir',
        (tester) async {
      final notifier = FakeLockerEntriesNotifier([
        fakeEntry(id: 'e1', teamName: 'Galatasaray', season: '2024-25'),
      ]);
      await tester.pumpWidget(_buildLockerApp(notifier));
      await tester.pumpAndSettle();

      expect(find.text('Galatasaray'), findsOneWidget);
      expect(find.text('2024-25'), findsOneWidget);
    });

    testWidgets('favori kit yıldız icon\'u gösterir', (tester) async {
      final notifier = FakeLockerEntriesNotifier([
        fakeEntry(id: 'e1', isFavourite: true),
      ]);
      await tester.pumpWidget(_buildLockerApp(notifier));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group('LockerEntryFormScreen', () {
    Future<void> _setTallViewport(WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('form submit add() metodunu doğru payload ile çağırır',
        (tester) async {
      await _setTallViewport(tester);
      final notifier = FakeLockerEntriesNotifier();
      await tester.pumpWidget(_buildFormApp(notifier));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('form_team_name')), 'Galatasaray');
      await tester.enterText(find.byKey(const Key('form_season')), '2024-25');
      await tester.tap(find.byKey(const Key('form_submit_button')));
      await tester.pumpAndSettle();

      expect(notifier.lastAddCall?.teamName, 'Galatasaray');
      expect(notifier.lastAddCall?.season, '2024-25');
      expect(notifier.lastAddCall?.condition, LockerCondition.mint);
    });

    testWidgets('boş takım adı formu submit etmez', (tester) async {
      await _setTallViewport(tester);
      final notifier = FakeLockerEntriesNotifier();
      await tester.pumpWidget(_buildFormApp(notifier));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('form_season')), '2024-25');
      await tester.tap(find.byKey(const Key('form_submit_button')));
      await tester.pump();

      expect(find.text('Takım adı zorunlu'), findsOneWidget);
      expect(notifier.lastAddCall, isNull);
    });

    testWidgets('upload hatası SnackBar gösterir', (tester) async {
      await _setTallViewport(tester);
      await tester.pumpWidget(ProviderScope(
        overrides: _formOverrides(_ThrowingLockerEntriesNotifier()),
        child: const MaterialApp(home: LockerEntryFormScreen()),
      ));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('form_team_name')), 'Galatasaray');
      await tester.enterText(find.byKey(const Key('form_season')), '2024-25');
      await tester.tap(find.byKey(const Key('form_submit_button')));
      await tester.pumpAndSettle();

      expect(
        find.text('Fotoğraf yüklenemedi. Lütfen tekrar deneyin.'),
        findsOneWidget,
      );
    });
  });
}
