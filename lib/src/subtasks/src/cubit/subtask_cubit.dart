import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/subtask_model.dart';

class SubtaskCubit extends Cubit<List<Subtask>> {
  SubtaskCubit()
      : super([
          Subtask(
            id: '1',
            taskId: '1',
            title: 'Изучить документацию',
            isCompleted: true,
            orderIndex: 0,
          ),
          Subtask(
            id: '2',
            taskId: '1',
            title: 'Написать код',
            isCompleted: false,
            orderIndex: 1,
          ),
          Subtask(
            id: '3',
            taskId: '1',
            title: 'Протестировать',
            isCompleted: false,
            orderIndex: 2,
          ),
          Subtask(
            id: '4',
            taskId: '2',
            title: 'Купить продукты',
            isCompleted: true,
            orderIndex: 0,
          ),
          Subtask(
            id: '5',
            taskId: '2',
            title: 'Приготовить ужин',
            isCompleted: false,
            orderIndex: 1,
          ),
        ]);

  List<Subtask> getSubtasksForTask(String taskId) {
    return state
        .where((subtask) => subtask.taskId == taskId)
        .toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  }

  void addSubtask(Subtask subtask) {
    emit([...state, subtask]);
  }

  void updateSubtask(String id, Subtask updatedSubtask) {
    emit(state
        .map((subtask) => subtask.id == id ? updatedSubtask : subtask)
        .toList());
  }

  void deleteSubtask(String id) {
    emit(state.where((subtask) => subtask.id != id).toList());
  }

  void toggleSubtask(String id) {
    emit(state.map((subtask) {
      if (subtask.id == id) {
        return subtask.copyWith(isCompleted: !subtask.isCompleted);
      }
      return subtask;
    }).toList());
  }

  void deleteSubtasksForTask(String taskId) {
    emit(state.where((subtask) => subtask.taskId != taskId).toList());
  }

  int getCompletedCount(String taskId) {
    return state
        .where((s) => s.taskId == taskId && s.isCompleted)
        .length;
  }

  int getTotalCount(String taskId) {
    return state.where((s) => s.taskId == taskId).length;
  }
}
