import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/task/task_card.dart';
import '../../widgets/task/task_filter_chip.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../theme/app_theme.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';
import '../../models/task.dart';


class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<String> _filters = [
    'Semua',
    'Hari Ini',
    'Belum Selesai',
    'Selesai',
    'Terlambat',
  ];
  
  final List<Map<String, dynamic>> _sortOptions = [
    {'label': 'Deadline Terdekat', 'value': 'deadline'},
    {'label': 'A-Z', 'value': 'title'},
    {'label': 'Status', 'value': 'status'},
  ];
  
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }
  
  Future<void> _loadTasks() async {
    final authProvider = context.read<AuthProvider>();
    final taskProvider = context.read<TaskProvider>();
    
    if (authProvider.user != null) {
      await taskProvider.fetchTasks(authProvider.user!.uid);
    }
  }
  
  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Urutkan Tugas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._sortOptions.map((option) {
                    final isSelected = taskProvider.currentSort == option['value'];
                    return ListTile(
                      leading: Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppTheme.primaryDark : Colors.grey,
                      ),
                      title: Text(option['label']),
                      onTap: () {
                        taskProvider.setSort(option['value'] as String);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  void _showDeleteDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: Text('Yakin ingin menghapus "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<TaskProvider>().deleteTask(task.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tugas "${task.title}" berhasil dihapus'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal menghapus: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortDialog,
            tooltip: 'Urutkan',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Theme.of(context).colorScheme.surface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  return TaskFilterChip(
                    label: filter,
                    isSelected: taskProvider.currentFilter == filter,
                    onSelected: () => taskProvider.setFilter(filter),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Task Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${taskProvider.tasks.length} Tugas',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (taskProvider.currentFilter != 'Semua')
                  TextButton(
                    onPressed: () => taskProvider.setFilter('Semua'),
                    child: const Text('Reset Filter'),
                  ),
              ],
            ),
          ),
          
          // Task List
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                if (taskProvider.isLoading) {
                  return const LoadingIndicator();
                }
                
                if (taskProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          taskProvider.error!,
                          style: TextStyle(
                            color: Colors.red.shade400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadTasks,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (taskProvider.tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          taskProvider.currentFilter == 'Semua'
                              ? 'Belum ada tugas'
                              : 'Tidak ada tugas ${taskProvider.currentFilter.toLowerCase()}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/task/form');
                          },
                          child: const Text('Tambah Tugas Pertama'),
                        ),
                      ],
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: _loadTasks,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: taskProvider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = taskProvider.tasks[index];
                      return TaskCard(
                        task: task,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(task: task),
                            ),
                          );
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskFormScreen(task: task),
                            ),
                          );
                        },
                        onDelete: () => _showDeleteDialog(task),
                        onToggleComplete: () async {
                          try {
                            final updatedTask = Task(
                              id: task.id,
                              title: task.title,
                              description: task.description,
                              deadline: task.deadline,
                              isCompleted: !task.isCompleted,
                              createdAt: task.createdAt,
                              userId: task.userId,
                            );
                            await taskProvider.updateTask(updatedTask);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal update: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/task/form');
        },
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
