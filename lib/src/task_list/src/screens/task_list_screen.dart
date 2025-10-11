import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/task_list_item.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';
import 'task_stats_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [
    Task(
      id: '1',
      title: 'Изучить Flutter',
      description: 'Пройти базовый курс по Flutter и создать первое приложение',
      priority: 1,
      isCompleted: false,
    ),
    Task(
      id: '2',
      title: 'Купить продукты',
      description: 'Молоко, хлеб, масло',
      priority: 2,
      isCompleted: true,
    ),
    Task(
      id: '3',
      title: 'Сделать зарядку',
      description: 'Утренняя зарядка 30 минут',
      priority: 3,
      isCompleted: false,
    ),
    Task(
      id: '4',
      title: 'Прочитать книгу',
      description: 'Закончить главу по архитектуре приложений',
      priority: 2,
      isCompleted: false,
    ),
  ];

  void _addTask() async {
    final newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
      });
    }
  }

  void _openTaskDetail(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: tasks[index]),
      ),
    );

    if (result == 'delete') {
      setState(() {
        tasks.removeAt(index);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Задача удалена')),
        );
      }
    } else if (result is Task) {
      setState(() {
        tasks[index] = result;
      });
    }
  }

  void _openStats() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskStatsScreen(tasks: tasks),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Трекер задач'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _openStats,
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'Нет задач',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < tasks.length; i++) ...[
                    TaskListItem(
                      task: tasks[i],
                      onTap: () => _openTaskDetail(i),
                    ),
                  ],
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}

