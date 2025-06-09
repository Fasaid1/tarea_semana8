import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (_) => onToggle(),
      ),
      title: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      '${task.title} (${task.marca})',
      style: TextStyle(
        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        fontWeight: FontWeight.bold,
      ),
    ),
    Text(
      task.isCompleted ? '✔ Completada' : '⏳ Incompleta',
      style: TextStyle(
        color: task.isCompleted ? Colors.green : Colors.red,
        fontSize: 12,
      ),
    ),
  ],
),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}