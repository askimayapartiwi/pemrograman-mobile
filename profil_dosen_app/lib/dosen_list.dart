import 'package:flutter/material.dart';
import 'dosen_detail.dart';

class Dosen {
  final String nama;
  final String nip;
  final String mataKuliah;
  final String waktuMengajar;
  final String jabatan;
  final String noHp;

  Dosen({
    required this.nama,
    required this.nip,
    required this.mataKuliah,
    required this.waktuMengajar,
    required this.jabatan,
    required this.noHp,
  });
}

class DosenListPage extends StatelessWidget {
  DosenListPage({super.key});

  final List<Dosen> daftarDosen = [
    Dosen(
      nama: 'Hery Afriyadi, SE., S.Kom., M.Si',
      nip: '197104152000121001',
      mataKuliah: 'Testing dan Implementasi Sistem',
      waktuMengajar: 'Senin, 08.00 - 10.30',
      jabatan: 'Ketua Program Studi',
      noHp: '+62 811-7447-115',
    ),
    Dosen(
      nama: 'Pol Metra, M.Kom',
      nip: '19910615010122045',
      mataKuliah: 'Multimedia',
      waktuMengajar: 'Senin, 13.00 - 15.30',
      jabatan: 'Sekretasi Program Studi',
      noHp: '+62 822-8345-5804',
    ),
    Dosen(
      nama: 'Ahmad Nasukha, S.Hum., M.S.I',
      nip: '1988072220171009',
      mataKuliah: 'Pemrograman Mobile',
      waktuMengajar: 'Selasa, 08.30 - 11.00',
      jabatan: 'Dosen Tetap',
      noHp: '+62 852-6666-2666',
    ),
    Dosen(
      nama: 'M. Yusuf, S.Kom., M.S.I',
      nip: '1988021420191007',
      mataKuliah: 'Technopreneurship',
      waktuMengajar: 'Rabu, 13.00 - 15.30',
      jabatan: 'Dosen Tetap',
      noHp: '+62 813-6776-8297',
    ),
    Dosen(
      nama: 'Wahyu Anggoro, M.Kom',
      nip: '-',
      mataKuliah: 'Manajemen Risiko',
      waktuMengajar: 'Rabu, 08.30 - 11.00',
      jabatan: 'Dosen Luar Biasa',
      noHp: '+62 812-5555-6666',
    ),
    Dosen(
      nama: 'Dila Nurlaila, M.Kom',
      nip: '-',
      mataKuliah: 'Rekayasa Perangkat Lunak',
      waktuMengajar: 'Selasa, 13.00 - 15.30',
      jabatan: 'Dosen Luar Biasa',
      noHp: '+62 895-3668-48906',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Dosen'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: daftarDosen.length,
        itemBuilder: (context, index) {
          final dosen = daftarDosen[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (_, __, ___) => DosenDetailPage(dosen: dosen),
                  transitionsBuilder:
                      (_, animation, __, child) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: ListTile(
                leading: Hero(
                  tag: dosen.nama,
                  child: const CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                title: Text(
                  dosen.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dosen.mataKuliah),
                    Text(
                      dosen.waktuMengajar,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
