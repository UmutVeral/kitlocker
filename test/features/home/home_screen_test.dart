import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/features/home/screens/home_screen.dart';
import 'package:kitlocker/l10n/app_localizations.dart';

Widget _homeWithLocale(Locale locale) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const HomeScreen(),
  );
}

void main() {
  group('HomeScreen localization', () {
    testWidgets('shows Turkish greeting for TR locale', (tester) async {
      await tester.pumpWidget(_homeWithLocale(const Locale('tr')));
      await tester.pumpAndSettle();

      expect(find.text("KitLocker'a hoş geldin"), findsOneWidget);
    });

    testWidgets('shows English greeting for EN locale', (tester) async {
      await tester.pumpWidget(_homeWithLocale(const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to KitLocker'), findsOneWidget);
    });
  });
}
