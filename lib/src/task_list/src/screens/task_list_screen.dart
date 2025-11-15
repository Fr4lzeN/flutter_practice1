import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice1/src/cubit/task_list_cubit.dart';
import 'package:practice1/src/navigation/app_router.dart';
import 'package:practice1/src/widgets/app_header.dart';
import '../models/task_model.dart';
import '../widgets/task_list_item.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  void _addTask(BuildContext context) async {
    final newTask = await context.push<Task>(AppRouter.addTaskRoute);
    if (newTask != null && context.mounted) {
      context.read<TaskListCubit>().addTask(newTask);
    }
  }

  void _openTaskDetail(BuildContext context, int index, Task task) async {
    final result = await context.push<Object>(
      AppRouter.taskDetailRoute,
      extra: task,
    );

    if (!context.mounted) return;

    if (result == 'delete') {
      context.read<TaskListCubit>().deleteTask(index);
    } else if (result is Task) {
      context.read<TaskListCubit>().updateTask(index, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskListCubit, List<Task>>(
      builder: (context, tasks) {

        return Scaffold(
          appBar: const AppHeader(currentRoute: AppRouter.tasksRoute),
          body: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskListItem(
                task: tasks[index],
                onTap: () => _openTaskDetail(context, index, tasks[index]),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _addTask(context),
            tooltip: 'Добавить задачу',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

