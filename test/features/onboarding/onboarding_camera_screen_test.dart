import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/features/onboarding/providers/onboarding_notifier.dart';
import 'package:kitlocker/features/onboarding/screens/onboarding_camera_screen.dart';
import '../../helpers/onboarding_fakes.dart';

void main() {
  group('OnboardingCameraScreen', () {
    late FakeOnboardingNotifier fakeOnboarding;

    setUp(() {
      fakeOnboarding = FakeOnboardingNotifier(false);
    });

    Widget buildScreen() => ProviderScope(
          overrides: [
            onboardingStatusProvider.overrideWith(() => fakeOnboarding),
          ],
          child: const MaterialApp(home: OnboardingCameraScreen()),
        );

    testWidgets('skip button is visible', (tester) async {
      await tester.pumpWidget(buildScreen());

      expect(find.byKey(const Key('onboarding_skip_button')), findsOneWidget);
    });

    testWidgets('skip button calls completeOnboarding', (tester) async {
      await tester.pumpWidget(buildScreen());

      await tester.tap(find.byKey(const Key('onboarding_skip_button')));
      await tester.pump();

      expect(fakeOnboarding.completeOnboardingCalled, isTrue);
    });

    testWidgets('add kit button is visible', (tester) async {
      await tester.pumpWidget(buildScreen());

      expect(
          find.byKey(const Key('onboarding_add_kit_button')), findsOneWidget);
    });
  });
}
