import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_state.dart';
import '../auth/auth_state_provider.dart';
import 'app_routes.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authStateProvider);
    final location = state.matchedLocation;

    return switch (authState) {
      AuthLoading() =>
        location == AppRoutes.splash ? null : AppRoutes.splash,
      Authenticated() =>
        (location == AppRoutes.auth || location == AppRoutes.splash)
            ? AppRoutes.home
            : null,
      Unauthenticated() =>
        location == AppRoutes.auth ? null : AppRoutes.auth,
      AuthError() =>
        location == AppRoutes.auth ? null : AppRoutes.auth,
    };
  }
}
