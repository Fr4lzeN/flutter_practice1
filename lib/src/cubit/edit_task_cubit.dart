import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/task_list/src/models/task_model.dart';

class EditTaskState {
  final String title;
  final String description;
  final int priority;
  final String? categoryId;
  final Task originalTask;

  EditTaskState({
    required this.title,
    required this.description,
    required this.priority,
    required this.categoryId,
    required this.originalTask,
  });

  EditTaskState copyWith({
    String? title,
    String? description,
    int? priority,
    String? categoryId,
    bool clearCategory = false,
    Task? originalTask,
  }) {
    return EditTaskState(
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
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
          categoryId: task.categoryId,
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

  void updateCategoryId(String? categoryId) {
    if (categoryId == null) {
      emit(state.copyWith(clearCategory: true));
    } else {
      emit(state.copyWith(categoryId: categoryId));
    }
  }

  Task getUpdatedTask() {
    return state.originalTask.copyWith(
      title: state.title,
      description: state.description,
      priority: state.priority,
      categoryId: state.categoryId,
      clearCategory: state.categoryId == null,
    );
  }
}

