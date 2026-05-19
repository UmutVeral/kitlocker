import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitlocker/features/onboarding/providers/onboarding_notifier.dart';
import '../../helpers/onboarding_fakes.dart';

void main() {
  group('OnboardingNotifier', () {
    test('completeOnboarding sets state to true', () async {
      final container = ProviderContainer(
        overrides: [
          onboardingStatusProvider
              .overrideWith(() => FakeOnboardingNotifier(false)),
        ],
      );
      addTearDown(container.dispose);

      await container.read(onboardingStatusProvider.future);
      expect(container.read(onboardingStatusProvider).value, false);

      await container
          .read(onboardingStatusProvider.notifier)
          .completeOnboarding();

      expect(container.read(onboardingStatusProvider).value, true);
    });

    test('initial true state is preserved', () async {
      final container = ProviderContainer(
        overrides: [
          onboardingStatusProvider
              .overrideWith(() => FakeOnboardingNotifier(true)),
        ],
      );
      addTearDown(container.dispose);

      await container.read(onboardingStatusProvider.future);
      expect(container.read(onboardingStatusProvider).value, true);
    });
  });
}
