import 'package:flutter/material.dart';
import 'package:practice1/src/task_list/src/repository/task_repository.dart';

class AppState extends InheritedWidget {
  final TaskRepository taskRepository;

  const AppState({
    super.key,
    required this.taskRepository,
    required super.child,
  });

  static AppState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppState>();
  }

  @override
  bool updateShouldNotify(AppState oldWidget) {
    return taskRepository != oldWidget.taskRepository;
  }
}

