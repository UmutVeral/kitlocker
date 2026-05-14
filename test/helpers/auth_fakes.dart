import 'package:kitlocker/core/auth/auth_notifier.dart';
import 'package:kitlocker/core/auth/auth_state.dart';

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier([this._initial = const Unauthenticated()]);
  final AuthState _initial;

  ({String email, String password, String username})? lastRegisterCall;
  ({String email, String password})? lastSignInCall;

  @override
  AuthState build() => _initial;

  @override
  Future<void> register({
    required String email,
    required String password,
    required String username,
  }) async {
    lastRegisterCall = (email: email, password: password, username: username);
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    lastSignInCall = (email: email, password: password);
  }
}
