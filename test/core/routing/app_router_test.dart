import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/app.dart';
import 'package:kitlocker/core/auth/auth_state.dart';
import 'package:kitlocker/core/auth/auth_state_provider.dart';
import 'package:kitlocker/features/auth/screens/auth_screen.dart';
import 'package:kitlocker/features/home/screens/home_screen.dart';
import 'package:kitlocker/features/onboarding/providers/onboarding_notifier.dart';
import 'package:kitlocker/features/onboarding/screens/onboarding_camera_screen.dart';
import '../../helpers/auth_fakes.dart';
import '../../helpers/onboarding_fakes.dart';

void main() {
  group('AppRouter redirect', () {
    testWidgets('unauthenticated user is redirected to auth screen',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider
                .overrideWith(() => FakeAuthNotifier(const Unauthenticated())),
          ],
          child: const KitLockerApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AuthScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('authenticated returning user sees home screen', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              () => FakeAuthNotifier(
                const Authenticated(userId: 'test-user-123'),
              ),
            ),
            onboardingStatusProvider
                .overrideWith(() => FakeOnboardingNotifier(true)),
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
                .overrideWith(() => FakeAuthNotifier(const AuthLoading())),
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
              () => FakeAuthNotifier(
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

    testWidgets(
        'new user (onboarding not completed) sees onboarding camera screen',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              () =>
                  FakeAuthNotifier(const Authenticated(userId: 'new-user-id')),
            ),
            onboardingStatusProvider
                .overrideWith(() => FakeOnboardingNotifier(false)),
          ],
          child: const KitLockerApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingCameraScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets(
        'returning user (onboarding completed) does not see onboarding screen',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith(
              () => FakeAuthNotifier(
                  const Authenticated(userId: 'returning-user-id')),
            ),
            onboardingStatusProvider
                .overrideWith(() => FakeOnboardingNotifier(true)),
          ],
          child: const KitLockerApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(OnboardingCameraScreen), findsNothing);
    });
  });
}
