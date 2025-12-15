import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:practice1/src/navigation/app_router.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String currentRoute;

  const AppHeader({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Трекер задач'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.list),
          tooltip: 'Список',
          color: currentRoute == AppRouter.tasksRoute
              ? Theme.of(context).primaryColor
              : null,
          onPressed: () {
            if (currentRoute != AppRouter.tasksRoute) {
              context.pushReplacement(AppRouter.tasksRoute);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.bar_chart),
          tooltip: 'Статистика',
          color: currentRoute == AppRouter.statsRoute
              ? Theme.of(context).primaryColor
              : null,
          onPressed: () {
            if (currentRoute != AppRouter.statsRoute) {
              context.pushReplacement(AppRouter.statsRoute);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.category),
          tooltip: 'Категории',
          color: currentRoute == AppRouter.categoriesRoute
              ? Theme.of(context).primaryColor
              : null,
          onPressed: () {
            if (currentRoute != AppRouter.categoriesRoute) {
              context.pushReplacement(AppRouter.categoriesRoute);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.label),
          tooltip: 'Теги',
          color: currentRoute == AppRouter.tagsRoute
              ? Theme.of(context).primaryColor
              : null,
          onPressed: () {
            if (currentRoute != AppRouter.tagsRoute) {
              context.pushReplacement(AppRouter.tagsRoute);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.checklist),
          tooltip: 'Подзадачи',
          color: currentRoute == AppRouter.subtasksRoute
              ? Theme.of(context).primaryColor
              : null,
          onPressed: () {
            if (currentRoute != AppRouter.subtasksRoute) {
              context.pushReplacement(AppRouter.subtasksRoute);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          tooltip: 'Напоминания',
          color: currentRoute == AppRouter.remindersRoute
              ? Theme.of(context).primaryColor
              : null,
          onPressed: () {
            if (currentRoute != AppRouter.remindersRoute) {
              context.pushReplacement(AppRouter.remindersRoute);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.person),
          tooltip: 'Профиль',
          color: currentRoute == AppRouter.profileRoute
              ? Theme.of(context).primaryColor
              : null,
          onPressed: () {
            if (currentRoute != AppRouter.profileRoute) {
              context.pushReplacement(AppRouter.profileRoute);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Настройки',
          color: currentRoute == AppRouter.settingsRoute
              ? Theme.of(context).primaryColor
              : null,
          onPressed: () {
            if (currentRoute != AppRouter.settingsRoute) {
              context.pushReplacement(AppRouter.settingsRoute);
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
