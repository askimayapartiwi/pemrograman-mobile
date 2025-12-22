import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../constants/firestore_constants.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _user;
  bool _isLoading = false;
  String? _error;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }
  
  Future<void> login(String email, String password, bool rememberMe) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      _user = userCredential.user;
      
      // Simpan email jika remember me aktif
      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.lastEmailKey, email);
        await prefs.setBool(AppConstants.rememberMeKey, true);
      }
      
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> register(String email, String password, String name) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // Simpan data user tambahan di Firestore
      await _firestore
          .collection(FirestoreConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .set({
        FirestoreConstants.userId: userCredential.user!.uid,
        FirestoreConstants.userEmail: email,
        FirestoreConstants.userName: name,
        FirestoreConstants.userCreatedAt: FieldValue.serverTimestamp(),
      });
      
      _user = userCredential.user;
      
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> logout() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = 'Gagal logout: $e';
      notifyListeners();
    }
  }
  
  Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.lastEmailKey);
  }
  
  Future<bool> getRememberMeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.rememberMeKey) ?? false;
  }
  
  void _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        _error = 'Email tidak ditemukan';
        break;
      case 'wrong-password':
        _error = 'Password salah';
        break;
      case 'email-already-in-use':
        _error = 'Email sudah terdaftar';
        break;
      case 'weak-password':
        _error = 'Password terlalu lemah (minimal 6 karakter)';
        break;
      case 'invalid-email':
        _error = 'Format email tidak valid';
        break;
      case 'network-request-failed':
        _error = 'Koneksi internet bermasalah';
        break;
      default:
        _error = 'Terjadi kesalahan: ${e.message}';
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}