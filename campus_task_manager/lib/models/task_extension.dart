import 'package:flutter/material.dart';
import 'task.dart';

extension TaskDeadlineExtension on Task {
  Color get deadlineColor {
    if (deadline == null) return Colors.grey;
    if (isCompleted) return Colors.green;
    if (isOverdue) return Colors.red;
    if (isDueToday) return Colors.orange;
    return Colors.blue;
  }

  String get deadlineStatus {
    if (deadline == null) return 'Tanpa Deadline';
    if (isCompleted) return 'Selesai';
    if (isOverdue) return 'Terlambat';
    if (isDueToday) return 'Hari Ini';
    return 'Aktif';
  }

  String toRelativeString() {
    if (deadline == null) return 'Tidak ada deadline';

    final diff = deadline!.difference(DateTime.now());

    if (diff.isNegative) {
      return 'Lewat ${diff.inDays.abs()} hari';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lagi';
    } else {
      return '${diff.inDays} hari lagi';
    }
  }
}
