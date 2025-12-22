import 'package:flutter/material.dart';

class AppTextTheme {
  // Headlines
  static TextStyle headlineLarge(Color color) {
    return TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: color,
      fontFamily: 'Poppins',
    );
  }
  
  static TextStyle headlineMedium(Color color) {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: color,
      fontFamily: 'Poppins',
    );
  }
  
  static TextStyle headlineSmall(Color color) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: color,
      fontFamily: 'Poppins',
    );
  }
  
  // Title
  static TextStyle titleLarge(Color color) {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: color,
      fontFamily: 'Poppins',
    );
  }
  
  static TextStyle titleMedium(Color color) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color,
      fontFamily: 'Poppins',
    );
  }
  
  static TextStyle titleSmall(Color color) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color,
      fontFamily: 'Poppins',
    );
  }
  
  // Body
  static TextStyle bodyLarge(Color color) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color,
      fontFamily: 'Poppins',
    );
  }
  
  static TextStyle bodyMedium(Color color) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color,
      fontFamily: 'Poppins',
    );
  }
  
  static TextStyle bodySmall(Color color) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color,
      fontFamily: 'Poppins',
    );
  }
  
  // Label
  static TextStyle labelLarge(Color color) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
      fontFamily: 'Poppins',
    );
  }
  
  static TextStyle labelMedium(Color color) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color,
      fontFamily: 'Poppins',
    );
  }
  
  static TextStyle labelSmall(Color color) {
    return TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: color,
      fontFamily: 'Poppins',
    );
  }
}