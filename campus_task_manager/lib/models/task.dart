import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime? deadline;
  bool isCompleted;
  String userId;
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.deadline,
    required this.isCompleted,
    required this.userId,
    required this.createdAt,
  });

  bool get isOverdue =>
      deadline != null &&
      deadline!.isBefore(DateTime.now()) &&
      !isCompleted;

  bool get isDueToday {
    if (deadline == null) return false;
    final now = DateTime.now();
    return deadline!.day == now.day &&
        deadline!.month == now.month &&
        deadline!.year == now.year;
  }

  Color get deadlineColor {
    final now = DateTime.now();
    if (isCompleted) return Colors.green;
    if (deadline == null) return Colors.grey;
    if (now.isAfter(deadline!)) return Colors.red;
    final difference = deadline!.difference(now).inDays;
    if (difference <= 2) return Colors.orange;
    return Colors.green;
  }

  String get deadlineStatus {
    final now = DateTime.now();
    if (isCompleted) return 'Selesai';
    if (deadline == null) return 'Tanpa deadline';
    if (now.isAfter(deadline!)) return 'Telat';
    final difference = deadline!.difference(now).inDays;
    if (difference == 0) return 'Hari ini';
    if (difference == 1) return 'Besok';
    if (difference <= 2) return 'Mendekati';
    return 'Masih ada waktu';
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'isCompleted': isCompleted,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      deadline: map['deadline'] != null
          ? (map['deadline'] as Timestamp).toDate()
          : null,
      isCompleted: map['isCompleted'] ?? false,
      userId: map['userId'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
