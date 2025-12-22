import 'package:flutter/material.dart';

class DeadlineIndicator extends StatelessWidget {
  final DateTime deadline;
  final bool isCompleted;
  final double size;
  
  const DeadlineIndicator({
    super.key,
    required this.deadline,
    required this.isCompleted,
    this.size = 24,
  });
  
  Color get color {
    final now = DateTime.now();
    
    if (isCompleted) return Colors.grey;
    if (now.isAfter(deadline)) return const Color(0xFFFF6B6B); // Merah lembut
    
    final difference = deadline.difference(now).inDays;
    
    if (difference <= 2) return const Color(0xFFFFA726); // Oranye lembut
    return const Color(0xFF66BB6A); // Hijau lembut
  }
  
  IconData get icon {
    final now = DateTime.now();
    
    if (isCompleted) return Icons.check_circle;
    if (now.isAfter(deadline)) return Icons.warning;
    
    final difference = deadline.difference(now).inDays;
    
    if (difference <= 2) return Icons.notification_important;
    return Icons.calendar_today;
  }
  
  String get tooltip {
    final now = DateTime.now();
    
    if (isCompleted) return 'Tugas selesai';
    if (now.isAfter(deadline)) return 'Tugas terlambat';
    
    final difference = deadline.difference(now).inDays;
    
    if (difference == 0) return 'Deadline hari ini';
    if (difference == 1) return 'Deadline besok';
    if (difference <= 2) return 'Deadline mendekati';
    return 'Masih ada waktu';
  }
  
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(size / 2),
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(
          icon,
          size: size * 0.6,
          color: color,
        ),
      ),
    );
  }
}