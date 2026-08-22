import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  @override
  bool get isConfigured => _client != null;

  @override
  Future<void> login(String email, String password) async {
    final client = _client;
    if (client == null) {
      throw Exception('Supabase non configuré.');
    }
    await client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> register(String email, String password) async {
    final client = _client;
    if (client == null) throw Exception('Supabase non configuré.');
    await client.auth.signUp(email: email, password: password);
  }

  @override
  Future<void> logout() async => await _client?.auth.signOut();

  @override
  bool get isAuthenticated => _client?.auth.currentSession != null;
}
