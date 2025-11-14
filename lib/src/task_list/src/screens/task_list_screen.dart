import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:practice1/src/di/app_state.dart';
import 'package:practice1/src/navigation/app_router.dart';
import 'package:practice1/src/task_list/src/repository/task_repository.dart';
import 'package:practice1/src/widgets/app_header.dart';
import '../models/task_model.dart';
import '../widgets/task_list_item.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late TaskRepository _taskRepository;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = AppState.of(context);
    if (appState != null) {
      _taskRepository = appState.taskRepository;
    }
  }

  void _addTask() async {
    final newTask = await context.push<Task>(AppRouter.addTaskRoute);
    if (newTask != null) {
      setState(() {
        _taskRepository.addTask(newTask);
      });
    }
  }

  void _openTaskDetail(int index) async {
    final task = _taskRepository.getTask(index);
    if (task == null) return;

    final result = await context.push<Object>(
      AppRouter.taskDetailRoute,
      extra: task,
    );

    if (result == 'delete') {
      setState(() {
        _taskRepository.deleteTask(index);
      });
    } else if (result is Task) {
      setState(() {
        _taskRepository.updateTask(index, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _taskRepository.getTasks();

    return Scaffold(
      appBar: const AppHeader(currentRoute: AppRouter.tasksRoute),
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskListItem(
            task: tasks[index],
            onTap: () => _openTaskDetail(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Добавить задачу',
        child: const Icon(Icons.add),
      ),
    );
  }
}

