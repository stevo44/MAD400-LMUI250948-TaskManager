import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final int taskIndex;
  final Function(Task updatedTask) onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onEdit; 

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.taskIndex,
    required this.onUpdate,
    required this.onDelete,
    required this.onEdit,  
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  Color _priorityColor() {
    switch (_task.priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _categoryIcon() {
    switch (_task.category) {
      case 'School':
        return Icons.school;
      case 'Personal':
        return Icons.person;
      case 'Health':
        return Icons.favorite;
      default:
        return Icons.label;
    }
  }

  void _toggleComplete() {
    setState(() {
      _task = Task(
        title: _task.title,
        description: _task.description,
        category: _task.category,
        priority: _task.priority,
        dueDate: _task.dueDate,
        isCompleted: !_task.isCompleted,
      );
    });
    widget.onUpdate(_task);
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${_task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              widget.onDelete();
              Navigator.pop(context); // go back to list
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isOverdue =
        !_task.isCompleted && _task.dueDate.isBefore(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                Icon(_categoryIcon(), color: Colors.grey[600], size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _task.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      decoration: _task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: _task.isCompleted ? Colors.grey : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Info cards row
            Row(
              children: [
                _buildInfoChip(
                  label: _task.priority,
                  color: _priorityColor(),
                  icon: Icons.flag,
                ),
                const SizedBox(width: 10),
                _buildInfoChip(
                  label: _task.category,
                  color: Colors.blue,
                  icon: _categoryIcon(),
                ),
                const SizedBox(width: 10),
                _buildInfoChip(
                  label: _task.isCompleted ? 'Done' : 'Pending',
                  color: _task.isCompleted ? Colors.green : Colors.orange,
                  icon: _task.isCompleted ? Icons.check_circle : Icons.schedule,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Due date
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Due Date',
              value:
                  '${_task.dueDate.day}/${_task.dueDate.month}/${_task.dueDate.year}',
              valueColor: isOverdue ? Colors.red : null,
            ),
            if (isOverdue)
              const Padding(
                padding: EdgeInsets.only(left: 32, top: 4),
                child: Text(
                  'This task is overdue',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _task.description,
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
            ),
            const SizedBox(height: 32),

            // Mark complete button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  _task.isCompleted ? Icons.undo : Icons.check_circle_outline,
                ),
                label: Text(
                  _task.isCompleted ? 'Mark as Incomplete' : 'Mark as Complete',
                  style: const TextStyle(fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor:
                      _task.isCompleted ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _toggleComplete,
              ),
            ),
            const SizedBox(height: 12),

            // Delete button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text(
                  'Delete Task',
                  style: TextStyle(fontSize: 15),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _confirmDelete,
              ),
            ),
            const SizedBox(height: 12),

            // Edit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit_outlined),
                label: const Text(
                  'Edit Task',
                  style: TextStyle(fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            onPressed: widget.onEdit,
          ),
        ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}