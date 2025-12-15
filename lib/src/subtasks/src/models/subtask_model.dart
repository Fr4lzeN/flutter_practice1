class Subtask {
  final String id;
  final String taskId;
  final String title;
  final bool isCompleted;
  final int orderIndex;

  Subtask({
    required this.id,
    required this.taskId,
    required this.title,
    this.isCompleted = false,
    this.orderIndex = 0,
  });

  Subtask copyWith({
    String? id,
    String? taskId,
    String? title,
    bool? isCompleted,
    int? orderIndex,
  }) {
    return Subtask(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
