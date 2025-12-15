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
          ),
          TaskCategory(
            id: '2',
            name: 'Личные',
            description: 'Личные дела и планы',
            color: 'green',
          ),
          TaskCategory(
            id: '3',
            name: 'Учеба',
            description: 'Образовательные задачи',
            color: 'purple',
          ),
          TaskCategory(
            id: '4',
            name: 'Здоровье',
            description: 'Задачи по здоровью и спорту',
            color: 'red',
          ),
          TaskCategory(
            id: '5',
            name: 'Покупки',
            description: 'Список покупок и расходов',
            color: 'orange',
          ),
        ]);

  void addCategory(TaskCategory category) {
    emit([...state, category]);
  }

  void updateCategory(String id, TaskCategory updatedCategory) {
    emit(state.map((cat) => cat.id == id ? updatedCategory : cat).toList());
  }

  void deleteCategory(int index) {
    if (index >= 0 && index < state.length) {
      final newState = [...state];
      newState.removeAt(index);
      emit(newState);
    }
  }

  void deleteCategoryById(String id) {
    emit(state.where((cat) => cat.id != id).toList());
  }

  void insertCategory(int index, TaskCategory category) {
    if (index >= 0 && index <= state.length) {
      final newState = [...state];
      newState.insert(index, category);
      emit(newState);
    }
  }

  TaskCategory? getCategoryById(String? id) {
    if (id == null) return null;
    try {
      return state.firstWhere((cat) => cat.id == id);
    } catch (_) {
      return null;
    }
  }
}

