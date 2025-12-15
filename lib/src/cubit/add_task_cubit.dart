import 'package:flutter_bloc/flutter_bloc.dart';

class AddTaskState {
  final String title;
  final String description;
  final int priority;
  final String? categoryId;

  AddTaskState({
    required this.title,
    required this.description,
    required this.priority,
    this.categoryId,
  });

  AddTaskState copyWith({
    String? title,
    String? description,
    int? priority,
    String? categoryId,
    bool clearCategory = false,
  }) {
    return AddTaskState(
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
    );
  }
}

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit()
      : super(AddTaskState(
          title: '',
          description: '',
          priority: 2,
          categoryId: null,
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

  void reset() {
    emit(AddTaskState(
      title: '',
      description: '',
      priority: 2,
      categoryId: null,
    ));
  }
}

