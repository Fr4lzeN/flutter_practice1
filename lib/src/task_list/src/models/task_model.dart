class Task {
  final String id;
  final String title;
  final String description;
  final int priority;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    int? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

