import '../models/user_model.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isLoggedIn;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isLoggedIn = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isLoggedIn,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
