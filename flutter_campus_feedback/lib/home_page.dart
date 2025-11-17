import 'package:flutter/material.dart';
import 'feedback_form_page.dart';
import 'feedback_list_page.dart';
import 'about_page.dart';

class HomePage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  
  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  // ✅ ANIMASI SLIDE FROM RIGHT
  void _navigateWithSlideAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  // ✅ ANIMASI FADE
  void _navigateWithFadeAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  // ✅ ANIMASI SCALE
  void _navigateWithScaleAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Feedback'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: isDarkMode ? Colors.yellow : Colors.blue,
                ),
                const SizedBox(width: 8),
                Switch(
                  value: isDarkMode,
                  onChanged: onThemeChanged,
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ LOGO FLUTTER 
            Container(
              width: 120,
              height: 120,
              child: Image.asset(
                'assets/images/flutter_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback jika gambar tidak ditemukan
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.flutter_dash,
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Flutter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            
            // Nama Aplikasi
            Text(
              'Campus Feedback',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            
            const SizedBox(height: 10),
            Text(
              'Kuesioner Kepuasan Mahasiswa terhadap Fasilitas dan Layanan Kampus.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Tombol Form Feedback - SLIDE ANIMATION
            ElevatedButton.icon(
              onPressed: () {
                _navigateWithSlideAnimation(context, const FeedbackFormPage());
              },
              icon: const Icon(Icons.feedback),
              label: const Text('Formulir Feedback Mahasiswa'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            
            const SizedBox(height: 15),
            
            // Tombol Daftar Feedback - SCALE ANIMATION
            ElevatedButton.icon(
              onPressed: () {
                _navigateWithScaleAnimation(context, const FeedbackListPage());
              },
              icon: const Icon(Icons.list),
              label: const Text('Daftar Feedback'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            
            const SizedBox(height: 15),
            
            // Tombol Profil Aplikasi - FADE ANIMATION
            ElevatedButton.icon(
              onPressed: () {
                _navigateWithFadeAnimation(context, const AboutPage());
              },
              icon: const Icon(Icons.info),
              label: const Text('Tentang Aplikasi'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            
            const Spacer(),
            
            // Teks Motivasi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '“Coding adalah seni memecahkan masalah dengan logika dan kreativitas.”',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}