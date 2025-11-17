import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo UIN STS Jambi - DENGAN FOTO
            Image.asset(
              'assets/images/uin_logo.png',
              height: 120,
              width: 120,
              errorBuilder: (context, error, stackTrace) {
                // Fallback jika gambar tidak ditemukan
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Icon(
                    Icons.school,
                    size: 60,
                    color: Colors.white,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 30),
            
            // Informasi Aplikasi
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Campus Feedback',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Aplikasi Kuesioner Kepuasan Mahasiswa terhadap Fasilitas dan Layanan Kampus',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    const Divider(),
                    
                    const SizedBox(height: 15),
                    
                    // Informasi Dosen
                    _buildInfoRow(
                      'Dosen Pengampu:',
                      'Ahmad Nasukha, S.Hum., M.S.I',
                    ),
                    
                    const SizedBox(height: 10),
                    
                    _buildInfoRow(
                      'Mata Kuliah:',
                      'Pemrograman Mobile',
                    ),
                    
                    const SizedBox(height: 10),
                    
                    _buildInfoRow(
                      'Nama Pengembang:',
                      'Aski Maya Partiwi', 
                    ),
                    
                    const SizedBox(height: 10),
                    
                    _buildInfoRow(
                      'NIM:',
                      '701230027', 
                    ),
                    
                    const SizedBox(height: 10),
                    
                    _buildInfoRow(
                      'Tahun Akademik:',
                      '2024/2025',
                    ),
                    
                    const SizedBox(height: 10),
                    
                    _buildInfoRow(
                      'Semester:',
                      '5',
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Tombol Kembali
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Kembali ke Beranda'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}