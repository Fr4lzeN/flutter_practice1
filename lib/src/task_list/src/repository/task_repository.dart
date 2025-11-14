import '../models/task_model.dart';

class TaskRepository {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Изучить Flutter',
      description: 'Пройти базовый курс по Flutter',
      priority: 1,
      isCompleted: false,
    ),
    Task(
      id: '2',
      title: 'Купить продукты',
      description: 'Молоко, хлеб, масло',
      priority: 2,
      isCompleted: true,
    ),
  ];

  List<Task> getTasks() {
    return List.unmodifiable(_tasks);
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  void updateTask(int index, Task task) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = task;
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
    }
  }

  Task? getTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      return _tasks[index];
    }
    return null;
  }

  int getTaskCount() {
    return _tasks.length;
  }
}

