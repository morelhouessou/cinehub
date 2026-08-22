import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? message;
  const AuthState(this.status, {this.message});
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  AuthCubit(this.repository) : super(const AuthState(AuthStatus.initial));

  bool get isConfigured => repository.isConfigured;

  void checkSession() => emit(AuthState(
    repository.isAuthenticated ? AuthStatus.authenticated : AuthStatus.unauthenticated,
  ));

  Future<void> login(String email, String password) async {
    emit(const AuthState(AuthStatus.loading));
    try {
      await repository.login(email, password);
      emit(const AuthState(AuthStatus.authenticated));
    } catch (e) {
      emit(AuthState(AuthStatus.error, message: e.toString()));
    }
  }

  Future<void> register(String email, String password) async {
    emit(const AuthState(AuthStatus.loading));
    try {
      await repository.register(email, password);
      emit(const AuthState(AuthStatus.authenticated));
    } catch (e) {
      emit(AuthState(AuthStatus.error, message: e.toString()));
    }
  }

  Future<void> logout() async {
    await repository.logout();
    emit(const AuthState(AuthStatus.unauthenticated));
  }
}
