import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_state.dart';
import '../auth/auth_state_provider.dart';
import '../../features/onboarding/providers/onboarding_notifier.dart';
import 'app_routes.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, _) => notifyListeners());
    _ref.listen(onboardingStatusProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authStateProvider);
    final location = state.matchedLocation;

    return switch (authState) {
      AuthLoading() =>
        location == AppRoutes.splash ? null : AppRoutes.splash,
      Unauthenticated() =>
        location == AppRoutes.auth ? null : AppRoutes.auth,
      AuthError() =>
        location == AppRoutes.auth ? null : AppRoutes.auth,
      Authenticated() => _authenticatedRedirect(location),
    };
  }

  String? _authenticatedRedirect(String location) {
    final onboardingStatus = _ref.read(onboardingStatusProvider);
    return onboardingStatus.when(
      loading: () => location == AppRoutes.splash ? null : AppRoutes.splash,
      error: (e, st) => location == AppRoutes.home ? null : AppRoutes.home,
      data: (completed) {
        if (!completed) {
          return location == AppRoutes.onboardingCamera
              ? null
              : AppRoutes.onboardingCamera;
        }
        if (location == AppRoutes.auth ||
            location == AppRoutes.splash ||
            location == AppRoutes.onboardingCamera) {
          return AppRoutes.home;
        }
        return null;
      },
    );
  }
}
