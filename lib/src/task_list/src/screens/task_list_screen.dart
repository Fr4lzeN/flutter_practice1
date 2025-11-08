import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:practice1/src/navigation/app_router.dart';
import 'package:practice1/src/widgets/app_header.dart';
import '../models/task_model.dart';
import '../widgets/task_list_item.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();

  static final List<Task> _tasks = [
    Task(
        id: '1',
        title: 'Изучить Flutter',
        description: 'Пройти базовый курс по Flutter',
        priority: 1,
        isCompleted: false),
    Task(
        id: '2',
        title: 'Купить продукты',
        description: 'Молоко, хлеб, масло',
        priority: 2,
        isCompleted: true),
  ];

  static List<Task> get tasks => _tasks;
}

class _TaskListScreenState extends State<TaskListScreen> {
  void _addTask() async {
    final newTask =
        await context.push<Task>(AppRouter.addTaskRoute);
    if (newTask != null) {
      setState(() {
        TaskListScreen._tasks.add(newTask);
      });
    }
  }

  void _openTaskDetail(int index) async {
    final result = await context.push<Object>(
      AppRouter.taskDetailRoute,
      extra: TaskListScreen._tasks[index],
    );
    if (result == 'delete') {
      setState(() {
        TaskListScreen._tasks.removeAt(index);
      });
    } else if (result is Task) {
      setState(() {
        TaskListScreen._tasks[index] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(currentRoute: AppRouter.tasksRoute),
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: TaskListScreen._tasks.length,
        itemBuilder: (context, index) {
          return TaskListItem(
            task: TaskListScreen._tasks[index],
            onTap: () => _openTaskDetail(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
        tooltip: 'Добавить задачу',
      ),
    );
  }
}

