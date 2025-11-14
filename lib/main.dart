import 'package:flutter/material.dart';
import 'package:practice1/src/di/app_state.dart';
import 'package:practice1/src/navigation/app_router.dart';
import 'package:practice1/src/task_list/src/repository/task_repository.dart';

void main() {
  runApp(
    AppState(
      taskRepository: TaskRepository(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Трекер задач',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
