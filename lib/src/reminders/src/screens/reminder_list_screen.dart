import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice1/src/navigation/app_router.dart';
import 'package:practice1/src/widgets/app_header.dart';
import 'package:practice1/src/cubit/task_list_cubit.dart';
import 'package:practice1/src/task_list/src/models/task_model.dart';
import '../cubit/reminder_cubit.dart';
import '../models/reminder_model.dart';

class ReminderListScreen extends StatelessWidget {
  const ReminderListScreen({super.key});

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final reminderDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (reminderDate == today) {
      dateStr = 'Сегодня';
    } else if (reminderDate == tomorrow) {
      dateStr = 'Завтра';
    } else {
      dateStr = '${dateTime.day}.${dateTime.month}.${dateTime.year}';
    }

    final timeStr =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return '$dateStr в $timeStr';
  }

  void _showAddReminderDialog(BuildContext context) {
    final tasks = context.read<TaskListCubit>().state;
    final noteController = TextEditingController();
    Task? selectedTask;
    DateTime selectedDate = DateTime.now().add(const Duration(hours: 1));
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);
    RepeatType selectedRepeat = RepeatType.none;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Новое напоминание'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Выбор задачи из списка
                DropdownButtonFormField<Task>(
                  value: selectedTask,
                  decoration: const InputDecoration(
                    labelText: 'Выберите задачу',
                    border: OutlineInputBorder(),
                  ),
                  items: tasks.map((task) => DropdownMenuItem(
                    value: task,
                    child: Text(
                      task.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )).toList(),
                  onChanged: (task) {
                    setState(() {
                      selectedTask = task;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Заметка (опционально)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    '${selectedDate.day}.${selectedDate.month}.${selectedDate.year}',
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text(
                    '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setState(() {
                        selectedTime = time;
                        selectedDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                const Text('Повторение:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...RepeatType.values.map((type) => RadioListTile<RepeatType>(
                      title: Text(_getRepeatTypeName(type)),
                      value: type,
                      groupValue: selectedRepeat,
                      onChanged: (value) {
                        setState(() => selectedRepeat = value!);
                      },
                      dense: true,
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedTask == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Выберите задачу')),
                  );
                  return;
                }
                final reminder = Reminder(
                  id: DateTime.now().toString(),
                  taskId: selectedTask!.id,
                  taskTitle: selectedTask!.title,
                  reminderTime: selectedDate,
                  note: noteController.text.isEmpty ? null : noteController.text,
                  repeatType: selectedRepeat,
                );
                context.read<ReminderCubit>().addReminder(reminder);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }

  String _getRepeatTypeName(RepeatType type) {
    switch (type) {
      case RepeatType.none:
        return 'Без повтора';
      case RepeatType.daily:
        return 'Ежедневно';
      case RepeatType.weekly:
        return 'Еженедельно';
      case RepeatType.monthly:
        return 'Ежемесячно';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit, List<Reminder>>(
      builder: (context, reminders) {
        final sortedReminders = List<Reminder>.from(reminders)
          ..sort((a, b) => a.reminderTime.compareTo(b.reminderTime));

        return Scaffold(
          appBar: const AppHeader(currentRoute: AppRouter.remindersRoute),
          body: reminders.isEmpty
              ? const Center(
                  child: Text(
                    'Нет напоминаний',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedReminders.length,
                  itemBuilder: (context, index) {
                    final reminder = sortedReminders[index];
                    final isPast = reminder.reminderTime.isBefore(DateTime.now());

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: isPast ? Colors.grey[100] : null,
                      child: ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              reminder.isActive
                                  ? Icons.notifications_active
                                  : Icons.notifications_off,
                              color: reminder.isActive
                                  ? (isPast ? Colors.orange : Colors.green)
                                  : Colors.grey,
                            ),
                            if (reminder.repeatType != RepeatType.none)
                              Icon(
                                Icons.repeat,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                          ],
                        ),
                        title: Text(
                          reminder.taskTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration:
                                isPast ? TextDecoration.lineThrough : null,
                            color: isPast ? Colors.grey : null,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDateTime(reminder.reminderTime),
                              style: TextStyle(
                                color: isPast ? Colors.grey : Colors.blue,
                              ),
                            ),
                            if (reminder.note != null)
                              Text(
                                reminder.note!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (reminder.repeatType != RepeatType.none)
                              Text(
                                reminder.repeatTypeText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.purple[300],
                                ),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: reminder.isActive,
                              onChanged: (_) {
                                context
                                    .read<ReminderCubit>()
                                    .toggleReminder(reminder.id);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text('Удалить напоминание?'),
                                    content: Text(
                                        'Удалить напоминание "${reminder.taskTitle}"?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(dialogContext).pop(),
                                        child: const Text('Отмена'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<ReminderCubit>()
                                              .deleteReminder(reminder.id);
                                          Navigator.of(dialogContext).pop();
                                        },
                                        child: const Text('Удалить'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddReminderDialog(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
