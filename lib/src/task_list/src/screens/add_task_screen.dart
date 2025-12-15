import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/cubit/add_task_cubit.dart';
import 'package:practice1/src/cubit/category_cubit.dart';
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
      categoryId: state.categoryId,
    );
    Navigator.pop(context, newTask);
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryCubit>().state;

    return BlocProvider(
      create: (_) => AddTaskCubit(),
      child: BlocBuilder<AddTaskCubit, AddTaskState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Добавить задачу'),
            ),
            body: SingleChildScrollView(
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
                    'Категория:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    value: state.categoryId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Выберите категорию',
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Без категории'),
                      ),
                      ...categories.map((cat) => DropdownMenuItem<String?>(
                            value: cat.id,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: _getColorFromString(cat.color),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(cat.name),
                              ],
                            ),
                          )),
                    ],
                    onChanged: (value) {
                      context.read<AddTaskCubit>().updateCategoryId(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Приоритет:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: state.priority,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Высокий')),
                      DropdownMenuItem(value: 2, child: Text('Средний')),
                      DropdownMenuItem(value: 3, child: Text('Низкий')),
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
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

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'yellow':
        return Colors.yellow;
      case 'pink':
        return Colors.pink;
      case 'teal':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

