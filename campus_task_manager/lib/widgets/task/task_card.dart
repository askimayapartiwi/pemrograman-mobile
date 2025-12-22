import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../utils/date_formatter.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final deadline = task.deadline ?? DateTime.now();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: task.deadlineColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: task.deadlineColor),
                    ),
                    child: Text(
                      task.deadlineStatus,
                      style: TextStyle(
                        color: task.deadlineColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Deskripsi
                Text(
                task.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Footer dengan deadline dan actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: task.deadlineColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormatter.formatDateTime(deadline),
                        style: TextStyle(
                          color: task.deadlineColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Action buttons
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          task.isCompleted
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: task.isCompleted ? Colors.green : Colors.grey,
                        ),
                        onPressed: onToggleComplete,
                        tooltip: task.isCompleted
                            ? 'Tandai belum selesai'
                            : 'Tandai selesai',
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: onEdit,
                        tooltip: 'Edit tugas',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: onDelete,
                        color: Colors.red,
                        tooltip: 'Hapus tugas',
                      ),
                    ],
                  ),
                ],
              ),

              // Progress indicator untuk deadline
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _calculateDeadlineProgress(deadline),
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(task.deadlineColor),
                minHeight: 4,
                // borderRadius hanya tersedia di Flutter 3.7+, kalau error hapus
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateDeadlineProgress(DateTime deadline) {
    final now = DateTime.now();
    final createdAt = task.createdAt;

    if (now.isAfter(deadline)) return 1.0;

    final totalDuration = deadline.difference(createdAt);
    final elapsedDuration = now.difference(createdAt);

    if (totalDuration.inSeconds <= 0) return 1.0;

    return elapsedDuration.inSeconds / totalDuration.inSeconds;
  }
}