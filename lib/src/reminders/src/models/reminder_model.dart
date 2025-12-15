enum RepeatType { none, daily, weekly, monthly }

class Reminder {
  final String id;
  final String taskId;
  final String taskTitle;
  final DateTime reminderTime;
  final bool isActive;
  final String? note;
  final RepeatType repeatType;

  Reminder({
    required this.id,
    required this.taskId,
    required this.taskTitle,
    required this.reminderTime,
    this.isActive = true,
    this.note,
    this.repeatType = RepeatType.none,
  });

  Reminder copyWith({
    String? id,
    String? taskId,
    String? taskTitle,
    DateTime? reminderTime,
    bool? isActive,
    String? note,
    RepeatType? repeatType,
  }) {
    return Reminder(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      taskTitle: taskTitle ?? this.taskTitle,
      reminderTime: reminderTime ?? this.reminderTime,
      isActive: isActive ?? this.isActive,
      note: note ?? this.note,
      repeatType: repeatType ?? this.repeatType,
    );
  }

  String get repeatTypeText {
    switch (repeatType) {
      case RepeatType.none:
        return 'Без повтора';
      case RepeatType.daily:
        return 'Ежедневно';
      case RepeatType.weekly:
        return 'Еженедельно';
      case RepeatType.monthly:
        return 'Ежемесячно';
    }
  }
}
