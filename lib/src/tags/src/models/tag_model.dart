class Tag {
  final String id;
  final String name;
  final String color;
  final List<String> taskIds;

  Tag({
    required this.id,
    required this.name,
    required this.color,
    this.taskIds = const [],
  });

  int get taskCount => taskIds.length;

  Tag copyWith({
    String? id,
    String? name,
    String? color,
    List<String>? taskIds,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      taskIds: taskIds ?? this.taskIds,
    );
  }
}
