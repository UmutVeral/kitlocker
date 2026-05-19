import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kitlocker/features/onboarding/providers/onboarding_notifier.dart';

class FakeOnboardingNotifier extends OnboardingNotifier {
  FakeOnboardingNotifier([this._initial = false]);
  final bool _initial;

  bool completeOnboardingCalled = false;

  @override
  Future<bool> build() async => _initial;

  @override
  Future<void> completeOnboarding() async {
    completeOnboardingCalled = true;
    state = const AsyncData(true);
  }
}
