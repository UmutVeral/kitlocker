import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/app.dart';
import 'package:kitlocker/core/auth/auth_notifier.dart';
import 'package:kitlocker/core/auth/auth_state.dart';
import 'package:kitlocker/core/auth/auth_state_provider.dart';
import 'package:kitlocker/features/auth/screens/auth_screen.dart';
import 'package:kitlocker/features/home/screens/home_screen.dart';

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(this._initial);
  final AuthState _initial;

  @override
  AuthState build() => _initial;
}

void main() {
  group('AppRouter redirect', () {
    testWidgets('unauthenticated user is redirected to auth screen',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider
                .overrideWith(() => _FakeAuthNotifier(const Unauthenticated())),
          ],
          child: const KitLockerApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AuthScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('authenticated user sees home screen', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              () => _FakeAuthNotifier(
                const Authenticated(userId: 'test-user-123'),
              ),
            ),
          ],
          child: const KitLockerApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(AuthScreen), findsNothing);
    });

    testWidgets('loading state shows splash screen', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider
                .overrideWith(() => _FakeAuthNotifier(const AuthLoading())),
          ],
          child: const KitLockerApp(),
        ),
      );
      await tester.pump();

      expect(find.byType(AuthScreen), findsNothing);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('auth error redirects to auth screen', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              () => _FakeAuthNotifier(
                const AuthError(message: 'Invalid credentials'),
              ),
            ),
          ],
          child: const KitLockerApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AuthScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });
  });
}
