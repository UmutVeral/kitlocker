import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  sb.SupabaseClient get _supabase => sb.Supabase.instance.client;

  @override
  AuthState build() {
    final subscription = _supabase.auth.onAuthStateChange.listen((data) {
      state = data.session != null
          ? Authenticated(userId: data.session!.user.id)
          : const Unauthenticated();
    });
    ref.onDispose(subscription.cancel);
    return const AuthLoading();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on sb.AuthException catch (e) {
      state = AuthError(message: e.message);
    } catch (_) {
      state = const AuthError(message: 'Beklenmeyen bir hata oluştu.');
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
  }) async {
    state = const AuthLoading();
    try {
      final response =
          await _supabase.auth.signUp(email: email, password: password);
      if (response.user != null) {
        await _supabase.from('profiles').insert({
          'id': response.user!.id,
          'username': username,
        });
      }
    } on sb.AuthException catch (e) {
      state = AuthError(message: e.message);
    } catch (_) {
      state = const AuthError(message: 'Kayıt başarısız.');
    }
  }

  Future<void> signOut() async {
    state = const AuthLoading();
    try {
      await _supabase.auth.signOut();
    } on sb.AuthException catch (e) {
      state = AuthError(message: e.message);
    }
  }
}

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
