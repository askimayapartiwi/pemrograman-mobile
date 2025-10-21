import 'package:flutter/material.dart';

void main() {
  runApp(const ProfilPribadiApp());
}

class ProfilPribadiApp extends StatelessWidget {
  const ProfilPribadiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Pribadi App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.pink[50], // warna latar belakang pink muda
        appBar: AppBar(
          title: const Text('Profil Pribadi'),
          backgroundColor: Colors.pinkAccent,
          centerTitle: true,
        ),
        body: const ProfilPribadiPage(),
      ),
    );
  }
}

class ProfilPribadiPage extends StatelessWidget {
  const ProfilPribadiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // supaya bisa discroll kalau konten panjang
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // =====================
              // BAGIAN PROFIL UTAMA
              // =====================
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/tiwiniy.jpg'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Aski Maya Partiwi',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Mahasiswa Sistem Informasi',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Universitas Islam Negeri Sulthan Thaha Syaifuddin Jambi',
                textAlign: TextAlign.center, // supaya teks universitas tetap rapi
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 30),

              // =====================
              // BAGIAN BIODATA DETAIL
              // =====================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Biodata',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Gunakan kombinasi Column + Row
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.perm_identity, color: Colors.pinkAccent),
                            SizedBox(width: 8),
                            Text('NIM: 701230027'),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: const [
                            Icon(Icons.class_, color: Colors.pinkAccent),
                            SizedBox(width: 8),
                            Text('Kelas: 5C Sistem Informasi'),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: const [
                            Icon(Icons.email, color: Colors.pinkAccent),
                            SizedBox(width: 8),
                            Text('Email: askimayaprtiwi@gmail.com'),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Alamat panjang → pakai Expanded agar tidak keluar layar
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.location_on, color: Colors.pinkAccent),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Alamat: Jl. Mayor Brury Mansyur RT 11 Kel. Paal Lima, Kec. Kota Baru, Kota Jambi',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Hobi panjang → pakai Expanded juga
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.star, color: Colors.pinkAccent),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Hobi: Desain, Berkemah, dan Mendengarkan Musik',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // =====================
              // TOMBOL AKSI
              // =====================
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Halo, ini profil saya! 😊'),
                      backgroundColor: Colors.pinkAccent,
                    ),
                  );
                },
                icon: const Icon(Icons.favorite),
                label: const Text('Yuk, Lihat Profil Aku!'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
