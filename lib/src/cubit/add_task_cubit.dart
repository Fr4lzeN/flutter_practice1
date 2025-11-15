import 'package:flutter_bloc/flutter_bloc.dart';

class AddTaskState {
  final String title;
  final String description;
  final int priority;

  AddTaskState({
    required this.title,
    required this.description,
    required this.priority,
  });

  AddTaskState copyWith({
    String? title,
    String? description,
    int? priority,
  }) {
    return AddTaskState(
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
    );
  }
}

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit()
      : super(AddTaskState(
          title: '',
          description: '',
          priority: 2,
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

  void reset() {
    emit(AddTaskState(
      title: '',
      description: '',
      priority: 2,
    ));
  }
}

