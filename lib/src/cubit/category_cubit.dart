import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/task_list/src/models/category_model.dart';

class CategoryCubit extends Cubit<List<TaskCategory>> {
  CategoryCubit()
      : super([
          TaskCategory(
            id: '1',
            name: 'Работа',
            description: 'Задачи связанные с работой',
            color: 'blue',
            taskCount: 5,
          ),
          TaskCategory(
            id: '2',
            name: 'Личные',
            description: 'Личные дела и планы',
            color: 'green',
            taskCount: 3,
          ),
          TaskCategory(
            id: '3',
            name: 'Учеба',
            description: 'Образовательные задачи',
            color: 'purple',
            taskCount: 2,
          ),
          TaskCategory(
            id: '4',
            name: 'Здоровье',
            description: 'Задачи по здоровью и спорту',
            color: 'red',
            taskCount: 1,
          ),
          TaskCategory(
            id: '5',
            name: 'Покупки',
            description: 'Список покупок и расходов',
            color: 'orange',
            taskCount: 4,
          ),
        ]);

  void addCategory(TaskCategory category) {
    emit([...state, category]);
  }

  void deleteCategory(int index) {
    if (index >= 0 && index < state.length) {
      final newState = [...state];
      newState.removeAt(index);
      emit(newState);
    }
  }

  void insertCategory(int index, TaskCategory category) {
    if (index >= 0 && index <= state.length) {
      final newState = [...state];
      newState.insert(index, category);
      emit(newState);
    }
  }
}

