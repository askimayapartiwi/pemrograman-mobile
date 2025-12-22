import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/task/deadline_indicator.dart';

class UpcomingTasks extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback onViewAll;
  final Function(Task) onTaskTap;

  const UpcomingTasks({
    super.key,
    required this.tasks,
    required this.onViewAll,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tugas Mendatang',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: onViewAll,
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...tasks.take(3).map(
              (task) => _buildTaskItem(context, task),
            ),
      ],
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: DeadlineIndicator(
          deadline: task.deadline ?? DateTime.now(),
          isCompleted: task.isCompleted,
          size: 32,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration:
                task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description.truncate(50),
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 12,
                  color: task.deadlineColor,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormatter.formatDateTime(task.deadline),
                  style: TextStyle(
                    fontSize: 11,
                    color: task.deadlineColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Chip(
          label: Text(task.deadlineStatus),
          backgroundColor: task.deadlineColor.withOpacity(0.1),
          labelStyle: TextStyle(
            color: task.deadlineColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => onTaskTap(task), // ✅ FIX UTAMA
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.assignment,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            const Text(
              'Tidak ada tugas mendatang',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tugas yang akan datang akan muncul di sini',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/* ===========================
   STRING EXTENSION
   =========================== */
extension StringExtensions on String {
  String truncate(int length) {
    if (length >= this.length) return this;
    return '${substring(0, length)}...';
  }
}
