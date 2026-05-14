import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/app.dart';
import 'package:kitlocker/core/auth/auth_notifier.dart';
import 'package:kitlocker/core/auth/auth_state.dart';
import 'package:kitlocker/core/auth/auth_state_provider.dart';

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(this._initial);
  final AuthState _initial;

  @override
  AuthState build() => _initial;
}

void main() {
  testWidgets('app renders without error', (tester) async {
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
    expect(find.byType(KitLockerApp), findsOneWidget);
  });
}
