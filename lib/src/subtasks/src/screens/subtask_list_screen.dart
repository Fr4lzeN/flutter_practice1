import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/navigation/app_router.dart';
import 'package:practice1/src/widgets/app_header.dart';
import 'package:practice1/src/cubit/task_list_cubit.dart';
import 'package:practice1/src/task_list/src/models/task_model.dart';
import '../cubit/subtask_cubit.dart';
import '../models/subtask_model.dart';

class SubtaskListScreen extends StatefulWidget {
  const SubtaskListScreen({super.key});

  @override
  State<SubtaskListScreen> createState() => _SubtaskListScreenState();
}

class _SubtaskListScreenState extends State<SubtaskListScreen> {
  String? _selectedTaskId;
  final _addController = TextEditingController();

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  void _addSubtask(BuildContext context) {
    if (_addController.text.isEmpty || _selectedTaskId == null) return;

    final subtaskCubit = context.read<SubtaskCubit>();
    final existingSubtasks = subtaskCubit.getSubtasksForTask(_selectedTaskId!);

    final newSubtask = Subtask(
      id: DateTime.now().toString(),
      taskId: _selectedTaskId!,
      title: _addController.text,
      orderIndex: existingSubtasks.length,
    );

    subtaskCubit.addSubtask(newSubtask);
    _addController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskListCubit, List<Task>>(
      builder: (context, tasks) {
        return BlocBuilder<SubtaskCubit, List<Subtask>>(
          builder: (context, allSubtasks) {
            return Scaffold(
              appBar: const AppHeader(currentRoute: AppRouter.subtasksRoute),
              body: Column(
                children: [
                  // Выбор задачи из реального списка задач
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: DropdownButtonFormField<String>(
                      value: _selectedTaskId,
                      decoration: const InputDecoration(
                        labelText: 'Выберите задачу',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Все подзадачи'),
                        ),
                        ...tasks.map((task) => DropdownMenuItem(
                              value: task.id,
                              child: Text(task.title),
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedTaskId = value;
                        });
                      },
                    ),
                  ),

                  // Поле добавления подзадачи
                  if (_selectedTaskId != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _addController,
                              decoration: const InputDecoration(
                                hintText: 'Новая подзадача...',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (_) => _addSubtask(context),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.add_circle, size: 32),
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: () => _addSubtask(context),
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Выберите задачу из списка выше, чтобы добавить подзадачу',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Список подзадач
                  Expanded(
                    child: _buildSubtaskList(context, allSubtasks, tasks),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getTaskTitle(List<Task> tasks, String taskId) {
    final task = tasks.where((t) => t.id == taskId).firstOrNull;
    return task?.title ?? 'Задача #$taskId';
  }

  Widget _buildSubtaskList(BuildContext context, List<Subtask> allSubtasks, List<Task> tasks) {
    List<Subtask> subtasks;
    if (_selectedTaskId == null) {
      subtasks = allSubtasks;
    } else {
      subtasks = context.read<SubtaskCubit>().getSubtasksForTask(_selectedTaskId!);
    }

    if (subtasks.isEmpty) {
      return const Center(
        child: Text(
          'Нет подзадач',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    // Группируем по taskId если показываем все
    if (_selectedTaskId == null) {
      final grouped = <String, List<Subtask>>{};
      for (final subtask in subtasks) {
        grouped.putIfAbsent(subtask.taskId, () => []).add(subtask);
      }

      return ListView.builder(
        itemCount: grouped.length,
        itemBuilder: (context, index) {
          final taskId = grouped.keys.elementAt(index);
          final taskSubtasks = grouped[taskId]!;
          final completed = taskSubtasks.where((s) => s.isCompleted).length;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(
                _getTaskTitle(tasks, taskId),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('$completed/${taskSubtasks.length} выполнено'),
              trailing: CircularProgressIndicator(
                value: taskSubtasks.isEmpty ? 0 : completed / taskSubtasks.length,
                backgroundColor: Colors.grey[300],
                strokeWidth: 6,
              ),
              children: taskSubtasks
                  .map((subtask) => _buildSubtaskTile(context, subtask))
                  .toList(),
            ),
          );
        },
      );
    }

    return ListView.builder(
      itemCount: subtasks.length,
      itemBuilder: (context, index) {
        return _buildSubtaskTile(context, subtasks[index]);
      },
    );
  }

  Widget _buildSubtaskTile(BuildContext context, Subtask subtask) {
    return Dismissible(
      key: Key(subtask.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<SubtaskCubit>().deleteSubtask(subtask.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Подзадача "${subtask.title}" удалена')),
        );
      },
      child: ListTile(
        leading: Checkbox(
          value: subtask.isCompleted,
          onChanged: (_) {
            context.read<SubtaskCubit>().toggleSubtask(subtask.id);
          },
        ),
        title: Text(
          subtask.title,
          style: TextStyle(
            decoration: subtask.isCompleted ? TextDecoration.lineThrough : null,
            color: subtask.isCompleted ? Colors.grey : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, size: 20),
          onPressed: () => _showEditDialog(context, subtask),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Subtask subtask) {
    final controller = TextEditingController(text: subtask.title);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Редактировать подзадачу'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Название',
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
                context.read<SubtaskCubit>().updateSubtask(
                      subtask.id,
                      subtask.copyWith(title: controller.text),
                    );
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
