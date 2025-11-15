import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/cubit/add_task_cubit.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  void _saveTask(BuildContext context, AddTaskState state) {
    if (state.title.isEmpty) {
      return;
    }
    final newTask = Task(
      id: DateTime.now().toString(),
      title: state.title,
      description: state.description,
      priority: state.priority,
      isCompleted: false,
    );
    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddTaskCubit(),
      child: BlocBuilder<AddTaskCubit, AddTaskState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Добавить задачу'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    onChanged: (value) =>
                        context.read<AddTaskCubit>().updateTitle(value),
                    decoration: const InputDecoration(
                      labelText: 'Название',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) =>
                        context.read<AddTaskCubit>().updateDescription(value),
                    decoration: const InputDecoration(
                      labelText: 'Описание',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Приоритет:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<int>(
                    value: state.priority,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Высокий (1)')),
                      DropdownMenuItem(value: 2, child: Text('Средний (2)')),
                      DropdownMenuItem(value: 3, child: Text('Низкий (3)')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        context.read<AddTaskCubit>().updatePriority(value);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _saveTask(context, state),
                    child: const Text('Сохранить'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

