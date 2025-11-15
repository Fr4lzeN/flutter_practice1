import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/task_list/src/models/task_model.dart';

class EditTaskState {
  final String title;
  final String description;
  final int priority;
  final Task originalTask;

  EditTaskState({
    required this.title,
    required this.description,
    required this.priority,
    required this.originalTask,
  });

  EditTaskState copyWith({
    String? title,
    String? description,
    int? priority,
    Task? originalTask,
  }) {
    return EditTaskState(
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      originalTask: originalTask ?? this.originalTask,
    );
  }
}

class EditTaskCubit extends Cubit<EditTaskState> {
  EditTaskCubit(Task task)
      : super(EditTaskState(
          title: task.title,
          description: task.description,
          priority: task.priority,
          originalTask: task,
        ));

  void updateTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updatePriority(int priority) {
    emit(state.copyWith(priority: priority));
  }

  Task getUpdatedTask() {
    return state.originalTask.copyWith(
      title: state.title,
      description: state.description,
      priority: state.priority,
    );
  }
}

