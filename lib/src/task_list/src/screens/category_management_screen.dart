import 'package:flutter/material.dart';
import 'package:practice1/src/navigation/app_router.dart';
import 'package:practice1/src/widgets/app_header.dart';
import '../models/category_model.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  List<TaskCategory> categories = [
    TaskCategory(
      id: '1',
      name: 'Работа',
      description: 'Задачи связанные с работой',
      color: 'blue',
      taskCount: 5,
    ),
    TaskCategory(
      id: '2',
      name: 'Личные',
      description: 'Личные дела и планы',
      color: 'green',
      taskCount: 3,
    ),
    TaskCategory(
      id: '3',
      name: 'Учеба',
      description: 'Образовательные задачи',
      color: 'purple',
      taskCount: 2,
    ),
    TaskCategory(
      id: '4',
      name: 'Здоровье',
      description: 'Задачи по здоровью и спорту',
      color: 'red',
      taskCount: 1,
    ),
    TaskCategory(
      id: '5',
      name: 'Покупки',
      description: 'Список покупок и расходов',
      color: 'orange',
      taskCount: 4,
    ),
  ];

  void _addCategory() async {
    final newCategory = await showDialog<TaskCategory>(
      context: context,
      builder: (context) => const AddCategoryDialog(),
    );
    if (newCategory != null) {
      setState(() {
        categories.add(newCategory);
      });
    }
  }

  void _deleteCategory(int index) {
    final deletedCategory = categories[index];
    setState(() {
      categories.removeAt(index);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Категория "${deletedCategory.name}" удалена'),
          action: SnackBarAction(
            label: 'Отменить',
            onPressed: () {
              setState(() {
                categories.insert(index, deletedCategory);
              });
            },
          ),
        ),
      );
    }
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
                    _deleteCategory(index);
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
                            'Задач: ${category.taskCount}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Редактирование будет добавлено')),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
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
