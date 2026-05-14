import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_state.dart';
import '../auth/auth_state_provider.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authStateProvider);
    final location = state.matchedLocation;

    return switch (authState) {
      AuthLoading() => location == '/splash' ? null : '/splash',
      Authenticated() =>
        (location == '/auth' || location == '/splash') ? '/home' : null,
      Unauthenticated() => location == '/auth' ? null : '/auth',
      AuthError() => location == '/auth' ? null : '/auth',
    };
  }
}
