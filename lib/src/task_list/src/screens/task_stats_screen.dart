import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/task_list_item.dart';

class TaskStatsScreen extends StatefulWidget {
  final List<Task> tasks;

  const TaskStatsScreen({super.key, required this.tasks});

  @override
  State<TaskStatsScreen> createState() => _TaskStatsScreenState();
}

class _TaskStatsScreenState extends State<TaskStatsScreen> {
  late List<Task> tasks;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    tasks = List.from(widget.tasks);
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

  void _deleteTask(int index) {
    final deletedTask = _filteredTasks[index];
    final originalIndex = tasks.indexOf(deletedTask);
    
    setState(() {
      tasks.removeAt(originalIndex);
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Задача "${deletedTask.title}" удалена'),
          action: SnackBarAction(
            label: 'Отменить',
            onPressed: () {
              setState(() {
                tasks.insert(originalIndex, deletedTask);
              });
            },
          ),
        ),
      );
    }
  }

  void _addTask() async {
    // Здесь можно добавить навигацию к экрану добавления задачи
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Функция добавления задач будет реализована')),
    );
  }

  void _returnWithUpdatedTasks() {
    Navigator.pop(context, tasks);
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
      appBar: AppBar(
        title: const Text('Статистика задач'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTask,
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _returnWithUpdatedTasks,
        ),
      ),
      body: Column(
        children: [
          // Фильтры
          Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
          // Статистика - компактная версия
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
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
                          const Icon(Icons.check_circle, color: Colors.green, size: 24),
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
                          const Icon(Icons.pending, color: Colors.orange, size: 24),
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
                          Icon(Icons.priority_high, color: Colors.red, size: 20),
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
                          Icon(Icons.flag, color: Colors.orange, size: 20),
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
                          Icon(Icons.low_priority, color: Colors.green, size: 20),
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
          // Список задач с ListView.builder
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Задачи (${_filteredTasks.length}):',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _filteredTasks.isEmpty
                      ? const Center(
                          child: Text(
                            'Нет задач для отображения',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredTasks.length,
                          itemBuilder: (context, index) {
                            return TaskListItem(
                              task: _filteredTasks[index],
                              onTap: () {},
                            );
                          },
                        ),
                ),
              ],
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

  Widget _buildPriorityRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

