import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/app_settings_model.dart';

class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit() : super(AppSettings());

  void toggleTheme() {
    emit(state.copyWith(isDarkTheme: !state.isDarkTheme));
  }

  void toggleNotifications() {
    emit(state.copyWith(notificationsEnabled: !state.notificationsEnabled));
  }

  void setLanguage(String language) {
    emit(state.copyWith(language: language));
  }

  void setDefaultPriority(int priority) {
    emit(state.copyWith(defaultPriority: priority));
  }

  void toggleShowCompletedTasks() {
    emit(state.copyWith(showCompletedTasks: !state.showCompletedTasks));
  }
}
