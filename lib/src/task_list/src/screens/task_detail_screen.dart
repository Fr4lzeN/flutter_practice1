import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:practice1/src/navigation/app_router.dart';
import 'package:practice1/src/subtasks/subtasks.dart';
import '../models/task_model.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task.isCompleted;
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Высокий';
      case 2:
        return 'Средний';
      case 3:
        return 'Низкий';
      default:
        return 'Неизвестный';
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _saveAndReturn() {
    final updatedTask = widget.task.copyWith(isCompleted: _isCompleted);
    Navigator.pop(context, updatedTask);
  }

  void _editTask() async {
    final result = await context.push<Object>(
      AppRouter.editTaskRoute,
      extra: widget.task,
    );

    if (result == 'delete') {
      if (context.mounted) {
        Navigator.pop(context, result);
      }
    } else if (result is Task) {
      if (context.mounted) {
        Navigator.pop(context, result.copyWith(isCompleted: _isCompleted));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали задачи'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editTask,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Название:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.task.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Описание:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.task.description.isEmpty
                          ? 'Нет описания'
                          : widget.task.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Приоритет:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(widget.task.priority),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getPriorityText(widget.task.priority),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: SwitchListTile(
                title: const Text('Статус выполнения'),
                subtitle: Text(_isCompleted ? 'Выполнено' : 'Не выполнено'),
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            // Секция подзадач
            _buildSubtasksSection(context),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveAndReturn,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Сохранить и вернуться'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtasksSection(BuildContext context) {
    return BlocBuilder<SubtaskCubit, List<Subtask>>(
      builder: (context, allSubtasks) {
        final subtasks = context.read<SubtaskCubit>().getSubtasksForTask(widget.task.id);
        final completedCount = subtasks.where((s) => s.isCompleted).length;

        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Подзадачи (${completedCount}/${subtasks.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.green),
                      tooltip: 'Добавить подзадачу',
                      onPressed: () => _showAddSubtaskDialog(context),
                    ),
                  ],
                ),
              ),
              if (subtasks.isEmpty)
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    'Нет подзадач',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...subtasks.map((subtask) => ListTile(
                      leading: Checkbox(
                        value: subtask.isCompleted,
                        onChanged: (_) {
                          context.read<SubtaskCubit>().toggleSubtask(subtask.id);
                        },
                      ),
                      title: Text(
                        subtask.title,
                        style: TextStyle(
                          decoration: subtask.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: subtask.isCompleted ? Colors.grey : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () {
                          context.read<SubtaskCubit>().deleteSubtask(subtask.id);
                        },
                      ),
                    )),
              if (subtasks.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: LinearProgressIndicator(
                    value: subtasks.isEmpty ? 0 : completedCount / subtasks.length,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showAddSubtaskDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Новая подзадача'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Название подзадачи',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final subtaskCubit = context.read<SubtaskCubit>();
                final existingSubtasks = subtaskCubit.getSubtasksForTask(widget.task.id);

                final newSubtask = Subtask(
                  id: DateTime.now().toString(),
                  taskId: widget.task.id,
                  title: controller.text,
                  orderIndex: existingSubtasks.length,
                );

                subtaskCubit.addSubtask(newSubtask);
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}

