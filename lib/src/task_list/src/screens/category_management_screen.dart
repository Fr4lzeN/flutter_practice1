import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/cubit/category_cubit.dart';
import 'package:practice1/src/cubit/task_list_cubit.dart';
import 'package:practice1/src/navigation/app_router.dart';
import 'package:practice1/src/widgets/app_header.dart';
import '../models/category_model.dart';

class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({super.key});

  void _addCategory(BuildContext context) async {
    final newCategory = await showDialog<TaskCategory>(
      context: context,
      builder: (context) => const AddCategoryDialog(),
    );
    if (newCategory != null && context.mounted) {
      context.read<CategoryCubit>().addCategory(newCategory);
    }
  }

  void _deleteCategory(
      BuildContext context, int index, TaskCategory category) {
    context.read<CategoryCubit>().deleteCategory(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Категория "${category.name}" удалена'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            context.read<CategoryCubit>().insertCategory(index, category);
          },
        ),
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

  void _showManageTasksDialog(BuildContext context, TaskCategory category) {
    final taskListCubit = context.read<TaskListCubit>();
    final tasks = taskListCubit.state;
    // Задачи, которые принадлежат этой категории
    final selectedTaskIds = tasks
        .where((t) => t.categoryId == category.id)
        .map((t) => t.id)
        .toSet();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Задачи для "${category.name}"'),
          content: SizedBox(
            width: double.maxFinite,
            child: tasks.isEmpty
                ? const Center(
                    child: Text('Нет доступных задач'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final isSelected = selectedTaskIds.contains(task.id);
                      return CheckboxListTile(
                        title: Text(task.title),
                        subtitle: Text(
                          task.isCompleted ? 'Завершена' : 'Активна',
                          style: TextStyle(
                            color: task.isCompleted ? Colors.green : Colors.orange,
                          ),
                        ),
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedTaskIds.add(task.id);
                            } else {
                              selectedTaskIds.remove(task.id);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                // Обновляем categoryId для каждой задачи
                for (int i = 0; i < tasks.length; i++) {
                  final task = tasks[i];
                  final shouldBelongToCategory = selectedTaskIds.contains(task.id);
                  final currentlyBelongs = task.categoryId == category.id;

                  if (shouldBelongToCategory && !currentlyBelongs) {
                    // Добавить задачу в категорию
                    taskListCubit.updateTask(i, task.copyWith(categoryId: category.id));
                  } else if (!shouldBelongToCategory && currentlyBelongs) {
                    // Убрать задачу из категории
                    taskListCubit.updateTask(i, task.copyWith(clearCategory: true));
                  }
                }
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Слушаем изменения задач для обновления счётчика
    final tasks = context.watch<TaskListCubit>().state;

    int getTaskCountForCategory(String categoryId) {
      return tasks.where((t) => t.categoryId == categoryId).length;
    }

    return BlocBuilder<CategoryCubit, List<TaskCategory>>(
      builder: (context, categories) {
        return Scaffold(
      appBar: const AppHeader(currentRoute: AppRouter.categoriesRoute),
      body: categories.isEmpty
          ? const Center(
              child: Text(
                'Нет категорий',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return Dismissible(
                  key: Key(category.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Удалить категорию?'),
                        content: Text(
                            'Вы уверены, что хотите удалить категорию "${category.name}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Удалить'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    _deleteCategory(context, index, category);
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getColorFromString(category.color),
                        child: Text(
                          category.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        category.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category.description),
                          const SizedBox(height: 4),
                          Text(
                            'Задач: ${getTaskCountForCategory(category.id)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.playlist_add),
                            tooltip: 'Управление задачами',
                            onPressed: () => _showManageTasksDialog(context, category),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Редактирование будет добавлено')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _addCategory(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedColor = 'blue';

  final List<String> _availableColors = [
    'blue',
    'green',
    'purple',
    'red',
    'orange',
    'yellow',
    'pink',
    'teal'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveCategory() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название категории')),
      );
      return;
    }

    final newCategory = TaskCategory(
      id: DateTime.now().toString(),
      name: _nameController.text,
      description: _descriptionController.text,
      color: _selectedColor,
    );

    Navigator.of(context).pop(newCategory);
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить категорию'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            const Text('Цвет:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _availableColors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getColorFromString(color),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _saveCategory,
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
