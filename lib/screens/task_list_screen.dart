import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';
import 'profile_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Sample tasks to test the UI — we'll replace hardcoded data later
  final List<Task> _tasks = [
    Task(
      title: 'Submit Flutter assignment',
      description: 'Complete and submit the major Flutter exercise.',
      category: 'School',
      priority: 'High',
      dueDate: DateTime.now().subtract(const Duration(days: 1)), // overdue
      isCompleted: false,
    ),
    Task(
      title: 'Go for a morning run',
      description: 'Run 5km before 7am.',
      category: 'Health',
      priority: 'Medium',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      isCompleted: true,
    ),
    Task(
      title: 'Call mum',
      description: 'Catch up and check in.',
      category: 'Personal',
      priority: 'Low',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: _tasks.isEmpty ? _buildEmptyState() : _buildTaskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // We'll wire this up on Day 3
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checklist_rounded, size: 72, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first task',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return TaskCard(
          task: task,
          onTap: () {
            // Navigation to detail screen — Day 4
          },
        );
      },
    );
  }
}