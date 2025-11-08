import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:practice1/src/task_list/src/models/task_model.dart';
import 'package:practice1/src/task_list/src/screens/add_task_screen.dart';
import 'package:practice1/src/task_list/src/screens/category_management_screen.dart';
import 'package:practice1/src/task_list/src/screens/edit_task_screen.dart';
import 'package:practice1/src/task_list/src/screens/task_detail_screen.dart';
import 'package:practice1/src/task_list/src/screens/task_list_screen.dart';
import 'package:practice1/src/task_list/src/screens/task_stats_screen.dart';
import 'package:practice1/src/welcome/welcome_screen.dart';

class AppRouter {
  static const String welcomeRoute = '/';
  static const String tasksRoute = '/tasks';
  static const String statsRoute = '/stats';
  static const String categoriesRoute = '/categories';
  static const String addTaskRoute = '/add-task';
  static const String taskDetailRoute = '/task-detail';
  static const String editTaskRoute = '/edit-task';

  static final GoRouter router = GoRouter(
    initialLocation: tasksRoute,
    routes: [
      GoRoute(
        path: welcomeRoute,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: tasksRoute,
        name: 'tasks',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TaskListScreen(),
        ),
      ),
      GoRoute(
        path: statsRoute,
        name: 'stats',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TaskStatsScreen(),
        ),
      ),
      GoRoute(
        path: categoriesRoute,
        name: 'categories',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: CategoryManagementScreen(),
        ),
      ),
      GoRoute(
        path: addTaskRoute,
        name: 'add-task',
        builder: (context, state) => const AddTaskScreen(),
      ),
      GoRoute(
        path: taskDetailRoute,
        name: 'task-detail',
        builder: (context, state) {
          final task = state.extra as Task;
          return TaskDetailScreen(task: task);
        },
      ),
      GoRoute(
        path: editTaskRoute,
        name: 'edit-task',
        builder: (context, state) {
          final task = state.extra as Task;
          return EditTaskScreen(task: task);
        },
      ),
    ],
  );
}
