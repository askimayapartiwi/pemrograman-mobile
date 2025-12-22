import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import '../constants/firestore_constants.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ====================== AUTH METHODS ======================
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  Future<String?> getCurrentUserId() async {
    return _auth.currentUser?.uid;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ====================== USER METHODS ======================
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(userId)
          .update({
        ...data,
        FirestoreConstants.userUpdatedAt: FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user data: $e');
      throw Exception('Gagal update data user');
    }
  }

  Future<void> createUserData(String userId, String email, String name) async {
    try {
      await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(userId)
          .set({
        FirestoreConstants.userId: userId,
        FirestoreConstants.userEmail: email,
        FirestoreConstants.userName: name,
        FirestoreConstants.userCreatedAt: FieldValue.serverTimestamp(),
        FirestoreConstants.userUpdatedAt: FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating user data: $e');
      throw Exception('Gagal membuat data user');
    }
  }

  // ====================== TASK METHODS ======================
  
  // Get all tasks for a user
  Future<List<Task>> getTasks(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.tasksCollection)
          .where(FirestoreConstants.taskUserId, isEqualTo: userId)
          .orderBy(FirestoreConstants.taskDeadline)
          .get();

      return snapshot.docs
          .map((doc) => Task.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting tasks: $e');
      return [];
    }
  }

  // Get tasks stream for real-time updates
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

  // Add new task
  Future<String> addTask(Task task) async {
    try {
      final docRef = await _firestore
          .collection(FirestoreConstants.tasksCollection)
          .add(task.toMap());
      
      return docRef.id;
    } catch (e) {
      print('Error adding task: $e');
      throw Exception('Gagal menambah tugas');
    }
  }

  // Update existing task
  Future<void> updateTask(Task task) async {
    try {
      await _firestore
          .collection(FirestoreConstants.tasksCollection)
          .doc(task.id)
          .update(task.toMap());
    } catch (e) {
      print('Error updating task: $e');
      throw Exception('Gagal mengupdate tugas');
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore
          .collection(FirestoreConstants.tasksCollection)
          .doc(taskId)
          .delete();
    } catch (e) {
      print('Error deleting task: $e');
      throw Exception('Gagal menghapus tugas');
    }
  }

  // ====================== QUERY METHODS ======================
  
  // Get tasks by status (completed/incomplete)
  Future<List<Task>> getTasksByStatus(String userId, bool isCompleted) async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.tasksCollection)
          .where(FirestoreConstants.taskUserId, isEqualTo: userId)
          .where(FirestoreConstants.taskIsCompleted, isEqualTo: isCompleted)
          .orderBy(FirestoreConstants.taskDeadline)
          .get();

      return snapshot.docs
          .map((doc) => Task.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting tasks by status: $e');
      return [];
    }
  }

  // Get overdue tasks
  Future<List<Task>> getOverdueTasks(String userId) async {
    try {
      final now = DateTime.now().toIso8601String();
      final snapshot = await _firestore
          .collection(FirestoreConstants.tasksCollection)
          .where(FirestoreConstants.taskUserId, isEqualTo: userId)
          .where(FirestoreConstants.taskDeadline, isLessThan: now)
          .where(FirestoreConstants.taskIsCompleted, isEqualTo: false)
          .orderBy(FirestoreConstants.taskDeadline)
          .get();

      return snapshot.docs
          .map((doc) => Task.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting overdue tasks: $e');
      return [];
    }
  }

  // Get today's tasks
  Future<List<Task>> getTodayTasks(String userId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection(FirestoreConstants.tasksCollection)
          .where(FirestoreConstants.taskUserId, isEqualTo: userId)
          .where(FirestoreConstants.taskDeadline,
              isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where(FirestoreConstants.taskDeadline,
              isLessThan: endOfDay.toIso8601String())
          .where(FirestoreConstants.taskIsCompleted, isEqualTo: false)
          .orderBy(FirestoreConstants.taskDeadline)
          .get();

      return snapshot.docs
          .map((doc) => Task.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting today tasks: $e');
      return [];
    }
  }

  // Get upcoming tasks (next 7 days)
  Future<List<Task>> getUpcomingTasks(String userId, {int days = 7}) async {
    try {
      final now = DateTime.now();
      final endDate = now.add(Duration(days: days));

      final snapshot = await _firestore
          .collection(FirestoreConstants.tasksCollection)
          .where(FirestoreConstants.taskUserId, isEqualTo: userId)
          .where(FirestoreConstants.taskDeadline,
              isGreaterThanOrEqualTo: now.toIso8601String())
          .where(FirestoreConstants.taskDeadline,
              isLessThanOrEqualTo: endDate.toIso8601String())
          .where(FirestoreConstants.taskIsCompleted, isEqualTo: false)
          .orderBy(FirestoreConstants.taskDeadline)
          .get();

      return snapshot.docs
          .map((doc) => Task.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error getting upcoming tasks: $e');
      return [];
    }
  }

  // ====================== STATISTICS METHODS ======================
  
  Future<Map<String, int>> getTaskStatistics(String userId) async {
    try {
      // Get all tasks
      final tasks = await getTasks(userId);
      
final now = DateTime.now();

// Total semua tugas
int total = tasks.length;

// Tugas yang selesai
int completed = tasks.where((task) => task.isCompleted).length;

// Tugas yang belum selesai
int pending = tasks.where((task) => !task.isCompleted).length;

// Tugas yang melewati deadline dan belum selesai
int overdue = tasks
    .where((task) => task.deadline != null && now.isAfter(task.deadline!) && !task.isCompleted)
    .length;

// Tugas yang deadline-nya hari ini dan belum selesai
int today = tasks
    .where((task) => task.deadline != null && task.isDueToday && !task.isCompleted)
    .length;


      return {
        'total': total,
        'completed': completed,
        'pending': pending,
        'overdue': overdue,
        'today': today,
      };
    } catch (e) {
      print('Error getting statistics: $e');
      return {
        'total': 0,
        'completed': 0,
        'pending': 0,
        'overdue': 0,
        'today': 0,
      };
    }
  }

  // ====================== SEARCH METHODS ======================
  
  Future<List<Task>> searchTasks(String userId, String query) async {
    try {
      if (query.isEmpty) {
        return await getTasks(userId);
      }

      final snapshot = await _firestore
          .collection(FirestoreConstants.tasksCollection)
          .where(FirestoreConstants.taskUserId, isEqualTo: userId)
          .orderBy(FirestoreConstants.taskDeadline)
          .get();

      final allTasks = snapshot.docs
          .map((doc) => Task.fromMap(doc.id, doc.data()))
          .toList();

      // Filter locally (Firestore doesn't support case-insensitive search easily)
      return allTasks
          .where((task) =>
              task.title.toLowerCase().contains(query.toLowerCase()) ||
              task.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print('Error searching tasks: $e');
      return [];
    }
  }

  // ====================== BATCH OPERATIONS ======================
  
  Future<void> markAllAsCompleted(String userId) async {
    try {
      final tasks = await getTasks(userId);
      final batch = _firestore.batch();

      for (final task in tasks.where((t) => !t.isCompleted)) {
        final updatedTask = Task(
          id: task.id,
          title: task.title,
          description: task.description,
          deadline: task.deadline,
          isCompleted: true,
          createdAt: task.createdAt,
          userId: task.userId,
        );

        final taskRef = _firestore
            .collection(FirestoreConstants.tasksCollection)
            .doc(task.id);

        batch.update(taskRef, updatedTask.toMap());
      }

      await batch.commit();
    } catch (e) {
      print('Error marking all as completed: $e');
      throw Exception('Gagal menandai semua tugas sebagai selesai');
    }
  }

  Future<void> deleteCompletedTasks(String userId) async {
    try {
      final completedTasks = await getTasksByStatus(userId, true);
      final batch = _firestore.batch();

      for (final task in completedTasks) {
        final taskRef = _firestore
            .collection(FirestoreConstants.tasksCollection)
            .doc(task.id);
        batch.delete(taskRef);
      }

      await batch.commit();
    } catch (e) {
      print('Error deleting completed tasks: $e');
      throw Exception('Gagal menghapus tugas yang sudah selesai');
    }
  }

  // ====================== TEST CONNECTION ======================
  
  Future<bool> testConnection() async {
    try {
      // Test Firestore write
      final testRef = _firestore.collection('test_connection').doc('ping');
      await testRef.set({
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'connected',
      });

      // Test Firestore read
      final doc = await testRef.get();
      
      // Cleanup
      await testRef.delete();

      return doc.exists;
    } catch (e) {
      print('Firebase connection test failed: $e');
      return false;
    }
  }

  // ====================== ERROR HANDLING ======================
  
  String getFirestoreError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'Izin ditolak. Periksa rules Firestore.';
        case 'unavailable':
          return 'Firestore tidak tersedia. Periksa koneksi internet.';
        case 'not-found':
          return 'Dokumen tidak ditemukan.';
        case 'already-exists':
          return 'Data sudah ada.';
        case 'invalid-argument':
          return 'Data tidak valid.';
        case 'deadline-exceeded':
          return 'Timeout. Coba lagi.';
        default:
          return 'Error Firestore: ${error.message}';
      }
    }
    return 'Terjadi kesalahan: $error';
  }
}