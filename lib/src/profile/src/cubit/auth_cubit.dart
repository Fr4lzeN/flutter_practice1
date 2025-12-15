import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, error: null));

    // Имитация задержки сети
    await Future.delayed(const Duration(seconds: 1));

    // Mock проверка (любой email/пароль проходит)
    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Введите email и пароль',
      ));
      return;
    }

    if (!email.contains('@')) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Неверный формат email',
      ));
      return;
    }

    final user = User(
      id: DateTime.now().toString(),
      name: email.split('@').first,
      email: email,
      createdAt: DateTime.now(),
      totalTasksCreated: 12,
      totalTasksCompleted: 8,
    );

    emit(state.copyWith(
      user: user,
      isLoading: false,
      isLoggedIn: true,
    ));
  }

  Future<void> register(String name, String email, String password) async {
    emit(state.copyWith(isLoading: true, error: null));

    await Future.delayed(const Duration(seconds: 1));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Заполните все поля',
      ));
      return;
    }

    if (!email.contains('@')) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Неверный формат email',
      ));
      return;
    }

    if (password.length < 6) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Пароль должен быть не менее 6 символов',
      ));
      return;
    }

    final user = User(
      id: DateTime.now().toString(),
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );

    emit(state.copyWith(
      user: user,
      isLoading: false,
      isLoggedIn: true,
    ));
  }

  void logout() {
    emit(AuthState());
  }

  void updateProfile({String? name, String? email}) {
    if (state.user == null) return;

    final updatedUser = state.user!.copyWith(
      name: name,
      email: email,
    );

    emit(state.copyWith(user: updatedUser));
  }

  void incrementTasksCreated() {
    if (state.user == null) return;
    emit(state.copyWith(
      user: state.user!.copyWith(
        totalTasksCreated: state.user!.totalTasksCreated + 1,
      ),
    ));
  }

  void incrementTasksCompleted() {
    if (state.user == null) return;
    emit(state.copyWith(
      user: state.user!.copyWith(
        totalTasksCompleted: state.user!.totalTasksCompleted + 1,
      ),
    ));
  }
}
