import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../providers/task_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';
import '../../utils/date_formatter.dart';
import 'package:provider/provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _deadline = DateTime.now().add(const Duration(days: 1));
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _deadline =
          widget.task!.deadline ?? DateTime.now().add(const Duration(days: 1));
    } else {
      final now = DateTime.now().add(const Duration(days: 1));
      _deadline = DateTime(now.year, now.month, now.day, 9, 0);
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final taskProvider = context.read<TaskProvider>();

      final task = Task(
        id: widget.task?.id ?? '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        deadline: _deadline,
        isCompleted: widget.task?.isCompleted ?? false,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        userId: authProvider.user!.uid,
      );

      if (widget.task == null) {
        await taskProvider.addTask(task);
      } else {
        await taskProvider.updateTask(task);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// ✅ DATE & TIME PICKER BAWAAN FLUTTER
  Future<void> _selectDeadline() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('id', 'ID'),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_deadline),
    );

    if (pickedTime == null) return;

    setState(() {
      _deadline = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Color _getDeadlineColor() {
    final now = DateTime.now();

    if (now.isAfter(_deadline)) return Colors.red;
    if (_deadline.difference(now).inDays <= 2) return Colors.orange;
    return Colors.green;
  }

  IconData _getDeadlineIcon() {
    final now = DateTime.now();

    if (now.isAfter(_deadline)) return Icons.warning;
    if (_deadline.difference(now).inDays <= 2) {
      return Icons.notification_important;
    }
    return Icons.calendar_today;
  }

  String _getDeadlineStatus() {
    final now = DateTime.now();

    if (now.isAfter(_deadline)) return '⏰ Telat! Deadline lewat';
    if (_deadline.difference(now).inDays == 0) return '📌 Deadline hari ini';
    if (_deadline.difference(now).inDays == 1) return '⏳ Deadline besok';
    if (_deadline.difference(now).inDays <= 2) return '⚠ Deadline mendekati';
    return '✅ Masih ada waktu';
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;

    return Scaffold(
      appBar: CustomAppBar(
        title: isEdit ? 'Edit Tugas' : 'Tambah Tugas',
        showBackButton: true,
      ),
      body: _isLoading
          ? const FullScreenLoader(message: 'Menyimpan tugas...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Judul Tugas',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      validator: Validators.validateTaskTitle,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Masukkan judul tugas',
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Deskripsi',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      validator: Validators.validateTaskDescription,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Masukkan deskripsi',
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Deadline',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('Pilih tanggal & waktu'),
                        subtitle:
                            Text(DateFormatter.formatDateTime(_deadline)),
                        onTap: _selectDeadline,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getDeadlineColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: _getDeadlineColor(), width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(_getDeadlineIcon(),
                              color: _getDeadlineColor(), size: 30),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormatter.formatDateTime(_deadline),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _getDeadlineColor(),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getDeadlineStatus(),
                                  style:
                                      TextStyle(color: _getDeadlineColor()),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryDark,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          isEdit ? 'UPDATE TUGAS' : 'SIMPAN TUGAS',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
