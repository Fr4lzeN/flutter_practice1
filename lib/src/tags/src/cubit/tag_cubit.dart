import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/tag_model.dart';

class TagCubit extends Cubit<List<Tag>> {
  TagCubit()
      : super([
          Tag(id: '1', name: 'Срочно', color: 'red', taskIds: ['1']),
          Tag(id: '2', name: 'Важно', color: 'orange', taskIds: ['1', '2']),
          Tag(id: '3', name: 'Дом', color: 'blue', taskIds: ['2']),
          Tag(id: '4', name: 'Работа', color: 'purple', taskIds: ['1']),
          Tag(id: '5', name: 'Учеба', color: 'green', taskIds: []),
        ]);

  void addTag(Tag tag) {
    emit([...state, tag]);
  }

  void updateTag(String id, Tag updatedTag) {
    emit(state.map((tag) => tag.id == id ? updatedTag : tag).toList());
  }

  void deleteTag(String id) {
    emit(state.where((tag) => tag.id != id).toList());
  }

  void addTaskToTag(String tagId, String taskId) {
    emit(state.map((tag) {
      if (tag.id == tagId && !tag.taskIds.contains(taskId)) {
        return tag.copyWith(taskIds: [...tag.taskIds, taskId]);
      }
      return tag;
    }).toList());
  }

  void removeTaskFromTag(String tagId, String taskId) {
    emit(state.map((tag) {
      if (tag.id == tagId) {
        return tag.copyWith(
          taskIds: tag.taskIds.where((id) => id != taskId).toList(),
        );
      }
      return tag;
    }).toList());
  }

  void setTasksForTag(String tagId, List<String> taskIds) {
    emit(state.map((tag) {
      if (tag.id == tagId) {
        return tag.copyWith(taskIds: taskIds);
      }
      return tag;
    }).toList());
  }

  List<Tag> getTagsForTask(String taskId) {
    return state.where((tag) => tag.taskIds.contains(taskId)).toList();
  }
}
