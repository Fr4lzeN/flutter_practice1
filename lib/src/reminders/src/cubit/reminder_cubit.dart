import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/reminder_model.dart';

class ReminderCubit extends Cubit<List<Reminder>> {
  ReminderCubit()
      : super([
          Reminder(
            id: '1',
            taskId: '1',
            taskTitle: 'Закончить отчет',
            reminderTime: DateTime.now().add(const Duration(hours: 2)),
            note: 'Важно сдать до конца дня',
            repeatType: RepeatType.none,
          ),
          Reminder(
            id: '2',
            taskId: '2',
            taskTitle: 'Позвонить врачу',
            reminderTime: DateTime.now().add(const Duration(days: 1)),
            isActive: true,
            repeatType: RepeatType.none,
          ),
          Reminder(
            id: '3',
            taskId: '3',
            taskTitle: 'Тренировка',
            reminderTime: DateTime.now().add(const Duration(hours: 5)),
            repeatType: RepeatType.daily,
          ),
          Reminder(
            id: '4',
            taskId: '4',
            taskTitle: 'Еженедельный отчет',
            reminderTime: DateTime.now().add(const Duration(days: 3)),
            repeatType: RepeatType.weekly,
            isActive: false,
          ),
        ]);

  void addReminder(Reminder reminder) {
    emit([...state, reminder]);
  }

  void updateReminder(String id, Reminder updatedReminder) {
    emit(state
        .map((reminder) => reminder.id == id ? updatedReminder : reminder)
        .toList());
  }

  void deleteReminder(String id) {
    emit(state.where((reminder) => reminder.id != id).toList());
  }

  void toggleReminder(String id) {
    emit(state.map((reminder) {
      if (reminder.id == id) {
        return reminder.copyWith(isActive: !reminder.isActive);
      }
      return reminder;
    }).toList());
  }

  List<Reminder> getActiveReminders() {
    return state.where((r) => r.isActive).toList()
      ..sort((a, b) => a.reminderTime.compareTo(b.reminderTime));
  }

  List<Reminder> getTodayReminders() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return state
        .where((r) =>
            r.reminderTime.isAfter(today) && r.reminderTime.isBefore(tomorrow))
        .toList()
      ..sort((a, b) => a.reminderTime.compareTo(b.reminderTime));
  }

  List<Reminder> getUpcomingReminders() {
    final now = DateTime.now();
    return state.where((r) => r.reminderTime.isAfter(now) && r.isActive).toList()
      ..sort((a, b) => a.reminderTime.compareTo(b.reminderTime));
  }
}
