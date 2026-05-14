import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/core/auth/auth_state_provider.dart';
import 'package:kitlocker/features/auth/screens/auth_screen.dart';
import 'package:kitlocker/l10n/app_localizations.dart';
import '../../helpers/auth_fakes.dart';

Widget _buildTestApp(FakeAuthNotifier notifier) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith(() => notifier),
    ],
    child: const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale('tr'), Locale('en')],
      home: AuthScreen(),
    ),
  );
}

void main() {
  group('AuthScreen — Sign-up formu', () {
    late FakeAuthNotifier notifier;

    setUp(() => notifier = FakeAuthNotifier());

    testWidgets('sign-up sekmesinde email, şifre ve username alanları var',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(notifier));
      await tester.pumpAndSettle();

      // Kayıt sekmesi aktif olmalı (varsayılan)
      expect(find.byKey(const Key('signup_email_field')), findsOneWidget);
      expect(find.byKey(const Key('signup_password_field')), findsOneWidget);
      expect(find.byKey(const Key('signup_username_field')), findsOneWidget);
    });

    testWidgets('geçersiz username kayıt denemesinde hata mesajı gösterir',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(notifier));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('signup_email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('signup_password_field')), 'password123');
      await tester.enterText(
          find.byKey(const Key('signup_username_field')), 'ab'); // çok kısa

      await tester.tap(find.byKey(const Key('signup_submit_button')));
      await tester.pump();

      expect(find.textContaining('3 karakter'), findsOneWidget);
      expect(notifier.lastRegisterCall, isNull);
    });

    testWidgets('geçerli form register() metodunu doğru parametrelerle çağırır',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(notifier));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('signup_email_field')), 'umut@example.com');
      await tester.enterText(
          find.byKey(const Key('signup_password_field')), 'sifre123');
      await tester.enterText(
          find.byKey(const Key('signup_username_field')), 'umut_veral');

      await tester.tap(find.byKey(const Key('signup_submit_button')));
      await tester.pump();

      expect(notifier.lastRegisterCall?.email, 'umut@example.com');
      expect(notifier.lastRegisterCall?.password, 'sifre123');
      expect(notifier.lastRegisterCall?.username, 'umut_veral');
    });
  });

  group('AuthScreen — Sign-in formu', () {
    late FakeAuthNotifier notifier;

    setUp(() => notifier = FakeAuthNotifier());

    testWidgets('giriş sekmesinde email ve şifre alanları var',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(notifier));
      await tester.pumpAndSettle();

      // Giriş sekmesine geç
      await tester.tap(find.byKey(const Key('signin_tab')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('signin_email_field')), findsOneWidget);
      expect(find.byKey(const Key('signin_password_field')), findsOneWidget);
    });

    testWidgets('giriş formu signIn() metodunu doğru parametrelerle çağırır',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(notifier));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('signin_tab')));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('signin_email_field')), 'umut@example.com');
      await tester.enterText(
          find.byKey(const Key('signin_password_field')), 'sifre123');

      await tester.tap(find.byKey(const Key('signin_submit_button')));
      await tester.pump();

      expect(notifier.lastSignInCall?.email, 'umut@example.com');
      expect(notifier.lastSignInCall?.password, 'sifre123');
    });
  });
}
