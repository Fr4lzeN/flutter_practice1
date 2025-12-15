import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/task_list/src/models/task_model.dart';

class TaskListCubit extends Cubit<List<Task>> {
  TaskListCubit()
      : super([
          Task(
            id: '1',
            title: 'Изучить Flutter',
            description: 'Пройти базовый курс по Flutter',
            priority: 1,
            isCompleted: false,
            categoryId: '3', // Учеба
          ),
          Task(
            id: '2',
            title: 'Купить продукты',
            description: 'Молоко, хлеб, масло',
            priority: 2,
            isCompleted: false,
            categoryId: '5', // Покупки
          ),
        ]);

  void addTask(Task task) {
    emit([...state, task]);
  }

  void updateTask(int index, Task task) {
    if (index >= 0 && index < state.length) {
      final newState = [...state];
      newState[index] = task;
      emit(newState);
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < state.length) {
      final newState = [...state];
      newState.removeAt(index);
      emit(newState);
    }
  }

  Task? getTask(int index) {
    if (index >= 0 && index < state.length) {
      return state[index];
    }
    return null;
  }
}

