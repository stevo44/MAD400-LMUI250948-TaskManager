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
  String _selectedFilter = 'All';
  String _selectedSort = 'None';
  final List<Task> _tasks = [
    Task(
      title: 'Submit Flutter assignment',
      description: 'Complete and submit the major Flutter exercise.',
      category: 'School',
      priority: 'High',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
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
   
   List<Task> get _filteredTasks {
  switch (_selectedFilter) {
    case 'Pending':
      return _tasks.where((task) => !task.isCompleted).toList();
    case 'Completed':
      return _tasks.where((task) => task.isCompleted).toList();
    default:
      return _tasks;
  }
}

     List<Task> get _sortedAndFilteredTasks {
        final filtered = _filteredTasks;
        final sorted = List<Task>.from(filtered);

        if (_selectedSort == 'Due Date') {
          sorted.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        } else if (_selectedSort == 'Priority') {
          const order = {'High': 0, 'Medium': 1, 'Low': 2};
          sorted.sort((a, b) => order[a.priority]!.compareTo(order[b.priority]!));
         }

        return sorted;
      }

      void _showSortDialog() {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sort Tasks'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['None', 'Due Date', 'Priority'].map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: _selectedSort,
                  onChanged: (value) {
                    setState(() {
                      _selectedSort = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      }
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'School';
  String _selectedPriority = 'Medium';
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedCategory = 'School';
    _selectedPriority = 'Medium';
    _selectedDate = null;
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showAddTaskSheet({Task? existingTask, int? taskIndex}) {
    // If editing, pre-fill the form
    if (existingTask != null) {
      _titleController.text = existingTask.title;
      _descriptionController.text = existingTask.description;
      _selectedCategory = existingTask.category;
      _selectedPriority = existingTask.priority;
      _selectedDate = existingTask.dueDate;
    } else {
      _resetForm();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Sheet title
                      Text(
                        existingTask != null ? 'Edit Task' : 'New Task',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title field
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Title is required'
                                : null,
                      ),
                      const SizedBox(height: 14),

                      // Description field
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Description is required'
                                : null,
                      ),
                      const SizedBox(height: 14),

                      // Category dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: ['School', 'Personal', 'Health']
                            .map((cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setSheetState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 14),

                      // Priority dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedPriority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Low', 'Medium', 'High']
                            .map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setSheetState(() {
                            _selectedPriority = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 14),

                      // Date picker button
                      GestureDetector(
                        onTap: () async {
                          await _pickDate(context);
                          setSheetState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18),
                              const SizedBox(width: 10),
                              Text(
                                _selectedDate == null
                                    ? 'Pick a due date'
                                    : 'Due: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: _selectedDate == null
                                      ? Colors.grey[600]
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _selectedDate != null) {
                              final newTask = Task(
                                title: _titleController.text.trim(),
                                description:
                                    _descriptionController.text.trim(),
                                category: _selectedCategory,
                                priority: _selectedPriority,
                                dueDate: _selectedDate!,
                                isCompleted: existingTask?.isCompleted ?? false,
                              );

                              setState(() {
                                if (taskIndex != null) {
                                  // Editing existing task
                                  _tasks[taskIndex] = newTask;
                                } else {
                                  // Adding new task
                                  _tasks.add(newTask);
                                }
                              });

                              Navigator.pop(context);
                            } else if (_selectedDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please pick a due date'),
                                ),
                              );
                            }
                          },
                          child: Text(
                            existingTask != null ? 'Save Changes' : 'Add Task',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortDialog,
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      },
    ),
  ],
),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsBar(),  
          _buildFilterBar(),
          Expanded(
            child: _filteredTasks.isEmpty && _tasks.isEmpty   
                ? _buildEmptyState()
                : _filteredTasks.isEmpty
                ? Center(
                    child: Text(
                      'No $_selectedFilter tasks',
                      style: TextStyle(color: Colors.grey[500], fontSize: 15),
                    ),
                  )
                : _buildTaskList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(),
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

  Widget _buildFilterBar() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: Row(
      children: ['All', 'Pending', 'Completed'].map((filter) {
        final bool isSelected = _selectedFilter == filter;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
        );
      }).toList(),
    ),
  );
  }

  Widget _buildStatsBar() {
  final total = _tasks.length;
  final completed = _tasks.where((t) => t.isCompleted).length;
  final pending = total - completed;
  final progress = total == 0 ? 0.0 : completed / total;

  return Container(
    margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.green[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.green.shade100),
    ),
    child: Column(
      children: [
        Row(
          children: [
            _buildStatItem('Total', total, Colors.blueGrey),
            _buildDivider(),
            _buildStatItem('Completed', completed, Colors.green),
            _buildDivider(),
            _buildStatItem('Pending', pending, Colors.orange),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.green[100],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${(progress * 100).toStringAsFixed(0)}% complete',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ),
      ],
    ),
  );
}

Widget _buildStatItem(String label, int count, Color color) {
  return Expanded(
    child: Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    ),
  );
}

Widget _buildDivider() {
  return Container(
    height: 36,
    width: 1,
    color: Colors.green[200],
  );
}
 
  Widget _buildTaskList() {
  final tasks = _sortedAndFilteredTasks;       
  return ListView.builder(
    padding: const EdgeInsets.only(top: 8, bottom: 80),
    itemCount: tasks.length,           
    itemBuilder: (context, index) {
      final task = tasks[index];      
      final actualIndex = _tasks.indexOf(task);  
      return Dismissible(
        key: Key(task.title + actualIndex.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 28),
        ),
        onDismissed: (direction) {
          setState(() {
            _tasks.removeAt(actualIndex);   // ← remove from real list
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${task.title} deleted'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: TaskCard(
          task: task,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(
                  task: task,
                  taskIndex: actualIndex,
                  onUpdate: (updatedTask) {
                    setState(() {
                      _tasks[actualIndex] = updatedTask;
                    });
                  },
                  onDelete: () {
                    setState(() {
                      _tasks.removeAt(actualIndex);
                    });
                  },
                  onEdit: () {
                    Navigator.pop(context);
                    _showAddTaskSheet(
                      existingTask: task,
                      taskIndex: actualIndex,
                    );
                  },
                ),
              ),
            );
          },
        ),
      );
    },
  );
  }

}