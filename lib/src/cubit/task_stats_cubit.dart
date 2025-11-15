import 'package:flutter_bloc/flutter_bloc.dart';

class TaskStatsCubit extends Cubit<String> {
  TaskStatsCubit() : super('all');

  void setFilter(String filter) {
    emit(filter);
  }
}

