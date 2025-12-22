import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import '../constants/firestore_constants.dart';

class TaskProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<Task> _tasks = [];
  String _currentFilter = 'Semua';
  String _currentSort = 'deadline';
  bool _isLoading = false;
  String? _error;
  
  List<Task> get tasks => _getFilteredAndSortedTasks();
  List<Task> get allTasks => List.from(_tasks);
  String get currentFilter => _currentFilter;
  String get currentSort => _currentSort;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Statistics
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((task) => task.isCompleted).length;
  int get pendingTasks => _tasks.where((task) => !task.isCompleted).length;
  int get overdueTasks => _tasks.where((task) => task.isOverdue).length;
  int get todayTasks => _tasks.where((task) => task.isDueToday && !task.isCompleted).length;
  
  Future<void> fetchTasks(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final snapshot = await _firestore
          .collection(FirestoreConstants.tasksCollection)
          .where(FirestoreConstants.taskUserId, isEqualTo: userId)
          .orderBy(FirestoreConstants.taskDeadline)
          .get();
      
      _tasks = snapshot.docs
          .map((doc) => Task.fromMap(doc.id, doc.data()))
          .toList();
      
    } catch (e) {
      _error = 'Gagal memuat tugas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Stream<List<Task>> getTasksStream(String userId) {
    return _firestore
        .collection(FirestoreConstants.tasksCollection)
        .where(FirestoreConstants.taskUserId, isEqualTo: userId)
        .orderBy(FirestoreConstants.taskDeadline)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Task.fromMap(doc.id, doc.data()))
              .toList();
        });
  }
  
  Future<void> addTask(Task task) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final docRef = await _firestore
          .collection(FirestoreConstants.tasksCollection)
          .add(task.toMap());
      
      task.id = docRef.id;
      _tasks.add(task);
      
    } catch (e) {
      throw Exception('Gagal menambah tugas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> updateTask(Task updatedTask) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _firestore
          .collection(FirestoreConstants.tasksCollection)
          .doc(updatedTask.id)
          .update(updatedTask.toMap());
      
      final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
      
    } catch (e) {
      throw Exception('Gagal mengupdate tugas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> deleteTask(String taskId) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _firestore
          .collection(FirestoreConstants.tasksCollection)
          .doc(taskId)
          .delete();
      
      _tasks.removeWhere((task) => task.id == taskId);
      
    } catch (e) {
      throw Exception('Gagal menghapus tugas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }
  
  void setSort(String sort) {
    _currentSort = sort;
    notifyListeners();
  }
  
  List<Task> _getFilteredAndSortedTasks() {
    List<Task> filteredTasks = List.from(_tasks);
    
    // Apply filter
    switch (_currentFilter) {
      case 'Hari Ini':
        filteredTasks = filteredTasks
            .where((task) => task.isDueToday && !task.isCompleted)
            .toList();
        break;
      case 'Selesai':
        filteredTasks = filteredTasks
            .where((task) => task.isCompleted)
            .toList();
        break;
      case 'Terlambat':
        filteredTasks = filteredTasks
            .where((task) => task.isOverdue)
            .toList();
        break;
      case 'Belum Selesai':
        filteredTasks = filteredTasks
            .where((task) => !task.isCompleted)
            .toList();
        break;
    }
    
    // Apply sort
    filteredTasks.sort((a, b) {
  final DateTime aDeadline = a.deadline ?? DateTime(9999, 12, 31);
  final DateTime bDeadline = b.deadline ?? DateTime(9999, 12, 31);

  if (_currentSort == 'deadline') {
    return aDeadline.compareTo(bDeadline);
  } else if (_currentSort == 'title') {
    return a.title.compareTo(b.title);
  } else if (_currentSort == 'status') {
    if (a.isCompleted == b.isCompleted) {
      return aDeadline.compareTo(bDeadline);
    }
    return a.isCompleted ? 1 : -1;
  }
  return 0;
});
    
    return filteredTasks;
  }
  
  // Get tasks for dashboard (limit 5)
  List<Task> get upcomingTasks {
    return _tasks
        .where((task) => !task.isCompleted)
        .take(5)
        .toList();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}