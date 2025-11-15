import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/cubit/edit_task_cubit.dart';
import '../models/task_model.dart';

class EditTaskScreen extends StatelessWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  void _saveTask(BuildContext context, EditTaskCubit cubit) {
    if (cubit.state.title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название задачи')),
      );
      return;
    }

    final updatedTask = cubit.getUpdatedTask();
    Navigator.pop(context, updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditTaskCubit(task),
      child: BlocBuilder<EditTaskCubit, EditTaskState>(
        builder: (context, state) {
          final cubit = context.read<EditTaskCubit>();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Редактировать задачу'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(context),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: TextEditingController(text: state.title)
                      ..selection = TextSelection.collapsed(
                          offset: state.title.length),
                    onChanged: (value) => cubit.updateTitle(value),
                    decoration: const InputDecoration(
                      labelText: 'Название',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: TextEditingController(text: state.description)
                      ..selection = TextSelection.collapsed(
                          offset: state.description.length),
                    onChanged: (value) => cubit.updateDescription(value),
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
                        cubit.updatePriority(value);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _saveTask(context, cubit),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Сохранить изменения'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить задачу?'),
        content: const Text('Вы уверены, что хотите удалить эту задачу?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context, 'delete');
            },
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

