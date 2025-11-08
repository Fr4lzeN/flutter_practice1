import 'package:flutter/material.dart';
import 'package:practice1/src/task_list/src/screens/category_management_screen.dart';
import 'package:practice1/src/task_list/src/screens/task_list_screen.dart';
import 'package:practice1/src/task_list/src/screens/task_stats_screen.dart';

enum AppPage { tasks, stats, categories }

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final AppPage currentPage;

  const AppHeader({super.key, required this.currentPage});

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
          color: currentPage == AppPage.tasks
              ? Theme.of(context).primaryColor
              : null,
          onPressed: () {
            if (currentPage != AppPage.tasks) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TaskListScreen()),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.bar_chart),
          tooltip: 'Статистика',
          color: currentPage == AppPage.stats
              ? Theme.of(context).primaryColor
              : null,
          onPressed: () {
            if (currentPage != AppPage.stats) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const TaskStatsScreen()),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.category),
          tooltip: 'Категории',
          color: currentPage == AppPage.categories
              ? Theme.of(context).primaryColor
              : null,
          onPressed: () {
            if (currentPage != AppPage.categories) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CategoryManagementScreen()),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
