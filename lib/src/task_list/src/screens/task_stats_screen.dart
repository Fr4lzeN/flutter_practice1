import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:practice1/src/navigation/app_router.dart';
import 'package:practice1/src/widgets/app_header.dart';
import '../models/task_model.dart';
import '../widgets/task_list_item.dart';
import 'task_list_screen.dart';
import 'task_detail_screen.dart';

class TaskStatsScreen extends StatefulWidget {
  const TaskStatsScreen({super.key});

  @override
  State<TaskStatsScreen> createState() => _TaskStatsScreenState();
}

class _TaskStatsScreenState extends State<TaskStatsScreen> {
  String _selectedFilter = 'all';

  List<Task> get tasks => TaskListScreen.tasks;

  void _openTaskDetail(Task task) async {
    final index = TaskListScreen.tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      final result = await context.push<Object>(
        AppRouter.taskDetailRoute,
        extra: task,
      );
      if (result == 'delete') {
        setState(() {
          TaskListScreen.tasks.removeAt(index);
        });
      } else if (result is Task) {
        setState(() {
          TaskListScreen.tasks[index] = result;
        });
      }
    }
  }

  List<Task> get _filteredTasks {
    switch (_selectedFilter) {
      case 'completed':
        return tasks.where((task) => task.isCompleted).toList();
      case 'incomplete':
        return tasks.where((task) => !task.isCompleted).toList();
      case 'high':
        return tasks.where((task) => task.priority == 1).toList();
      case 'medium':
        return tasks.where((task) => task.priority == 2).toList();
      case 'low':
        return tasks.where((task) => task.priority == 3).toList();
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final incompleteTasks = totalTasks - completedTasks;

    final highPriorityTasks = tasks.where((task) => task.priority == 1).length;
    final mediumPriorityTasks =
        tasks.where((task) => task.priority == 2).length;
    final lowPriorityTasks = tasks.where((task) => task.priority == 3).length;

    return Scaffold(
      appBar: const AppHeader(currentRoute: AppRouter.statsRoute),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    _buildFilterChip('Все', 'all'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Выполненные', 'completed'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Не выполненные', 'incomplete'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Высокий приоритет', 'high'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Средний приоритет', 'medium'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Низкий приоритет', 'low'),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.task_alt,
                            size: 40,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Всего задач: $totalTasks',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: Colors.green[50],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Colors.green, size: 24),
                                const SizedBox(height: 8),
                                Text(
                                  '$completedTasks',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const Text(
                                  'Выполнено',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          color: Colors.orange[50],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Icon(Icons.pending,
                                    color: Colors.orange, size: 24),
                                const SizedBox(height: 8),
                                Text(
                                  '$incompleteTasks',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                const Text(
                                  'Не выполнено',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'По приоритетам:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Icon(Icons.priority_high,
                                    color: Colors.red, size: 20),
                                const SizedBox(height: 4),
                                Text(
                                  '$highPriorityTasks',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                const Text(
                                  'Высокий',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Icon(Icons.flag,
                                    color: Colors.orange, size: 20),
                                const SizedBox(height: 4),
                                Text(
                                  '$mediumPriorityTasks',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                const Text(
                                  'Средний',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Icon(Icons.low_priority,
                                    color: Colors.green, size: 20),
                                const SizedBox(height: 4),
                                Text(
                                  '$lowPriorityTasks',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const Text(
                                  'Низкий',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Задачи (${_filteredTasks.length}):',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _filteredTasks.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: const Center(
                    child: Text(
                      'Нет задач для отображения',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = _filteredTasks[index];
                      return TaskListItem(
                        key: ValueKey(task.id),
                        task: task,
                        onTap: () => _openTaskDetail(task),
                      );
                    },
                    childCount: _filteredTasks.length,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }
}
