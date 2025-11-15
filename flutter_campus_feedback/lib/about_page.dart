import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FF),
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 3,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo kampus
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage('assets/images/uin_logo.png'),
              ),
              const SizedBox(height: 20),

              const Text(
                'Aplikasi Campus Feedback',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Dikembangkan untuk mempermudah mahasiswa dalam memberikan umpan balik terhadap fasilitas kampus secara digital dan efisien.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
              ),

              const SizedBox(height: 25),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '📚 Mata Kuliah: Rekayasa Perangkat Lunak',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '👨‍🏫 Dosen Pengampu: Bapak/Ibu [Nama Dosen]',
                        style:
                            TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '🏫 Program Studi: Sistem Informasi',
                        style:
                            TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Colors.blue.shade50,
                elevation: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    children: const [
                      Text(
                        '👩‍💻 Pengembang:',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A)),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Aski Ramadhani\nMahasiswa Sistem Informasi\nUIN Sulthan Thaha Saifuddin Jambi',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                '© 2025 UIN STS Jambi - All Rights Reserved',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
