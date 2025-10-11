class TaskCategory {
  final String id;
  final String name;
  final String description;
  final String color;
  final int taskCount;

  TaskCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    this.taskCount = 0,
  });

  TaskCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? color,
    int? taskCount,
  }) {
    return TaskCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      taskCount: taskCount ?? this.taskCount,
    );
  }
}
