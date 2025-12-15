import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/category_model.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final TaskCategory? category;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onTap,
    this.category,
  });

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icons.priority_high;
      case 2:
        return Icons.flag;
      case 3:
        return Icons.low_priority;
      default:
        return Icons.help_outline;
    }
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'yellow':
        return Colors.yellow;
      case 'pink':
        return Colors.pink;
      case 'teal':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          _getPriorityIcon(task.priority),
          color: _getPriorityColor(task.priority),
          size: 32,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: category != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getColorFromString(category!.color),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category!.name,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            : null,
        trailing: task.isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.circle_outlined, color: Colors.grey),
      ),
    );
  }
}

