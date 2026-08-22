abstract class AuthRepository {
  bool get isConfigured;
  Future<void> login(String email, String password);
  Future<void> register(String email, String password);
  Future<void> logout();
  bool get isAuthenticated;
}
