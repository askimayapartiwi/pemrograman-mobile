import 'package:flutter/material.dart';

class AcademicScreen extends StatelessWidget {
  const AcademicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Akademik'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IP dan SKS Mahasiswa
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'IP dan SKS Mahasiswa',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('IPK', '3.91'),
                    _buildInfoRow('SKS Kumulatif', '87'),
                    _buildInfoRow('SKS Ambil', '20'),
                    _buildInfoRow('IPS Lalu', '3.84'),
                    _buildInfoRow('Jatah SKS', '24'),
                    _buildInfoRow('Sisa SKS', '4'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Daftar Kelas Mata Kuliah
            Text(
              'Daftar Kelas Mata Kuliah yang Diambil',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            _buildCourseCard(
              context,
              'Manajemen Resiko',
              'SIF65002',
              'C',
              '3',
              'Rabu, 08:30-11:00',
              'B-603',
              'Wahyu Anggoro, M.Kom',
            ),
            _buildCourseCard(
              context,
              'Multimedia',
              'SIF65006',
              'C',
              '4',
              'Senin, 13.00-15.30',
              'B-603',
              'Pol Metra, M.Kom',
            ),
            _buildCourseCard(
              context,
              'Pemrograman Mobile',
              'SIF65005',
              'C',
              '4',
              'Selasa, 08:30-11:30',
              'B-603',
              'Ahmad Nasukha, S.Hum., M.S.I',
            ),
            _buildCourseCard(
              context,
              'Rekayasa Perangkat Lunak',
              'SIF65003',
              'C',
              '3',
              'Selasa, 13:00-15:30',
              'B-603',
              'Dila Nurlalla, M.Kom',
            ),
            _buildCourseCard(
              context,
              'Technopreneurship',
              'SIF65001',
              'C',
              '3',
              'Rabu, 13:00-15:30',
              'B-603',
              'M. Yusuf, S.Kom., M.S.I',
            ),
            _buildCourseCard(
              context,
              'Testing dan Implementasi System',
              'SIF65004',
              'C',
              '3',
              'Senin, 08:00-10:30',
              'B-603',
              'Hery Afriyadi, SE., S.Kom, M.Si',
            ),

            const SizedBox(height: 20),

            // Total SKS
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total SKS Semester Ini',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    Text(
                      '20 SKS',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(
    BuildContext context,
    String courseName,
    String code,
    String kelas,
    String sks,
    String jadwal,
    String ruang,
    String dosen,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan Kode dan Nama MK
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        code,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        courseName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$sks SKS',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Informasi Detail
            _buildCourseDetailItem(Icons.class_, 'Kelas: $kelas'),
            _buildCourseDetailItem(Icons.schedule, 'Jadwal: $jadwal'),
            _buildCourseDetailItem(Icons.location_on, 'Ruang: $ruang'),
            _buildCourseDetailItem(Icons.school, 'Dosen: $dosen'),
            _buildCourseDetailItem(Icons.bookmark, 'Jenis: WAJIB'),

            const SizedBox(height: 8),

            // Tombol Detail
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  _showCourseDetail(
                    context,
                    courseName,
                    code,
                    kelas,
                    sks,
                    jadwal,
                    ruang,
                    dosen,
                  );
                },
                child: const Text('Lihat Detail'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showCourseDetail(
    BuildContext context,
    String courseName,
    String code,
    String kelas,
    String sks,
    String jadwal,
    String ruang,
    String dosen,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(courseName),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailItem('Kode MK', code),
                _buildDetailItem('Kelas', kelas),
                _buildDetailItem('SKS', '$sks SKS'),
                _buildDetailItem('Jadwal', jadwal),
                _buildDetailItem('Ruang', ruang),
                _buildDetailItem('Jenis MK', 'WAJIB'),
                _buildDetailItem('Dosen Pengampu', dosen),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}