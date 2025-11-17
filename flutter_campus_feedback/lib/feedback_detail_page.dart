import 'package:flutter/material.dart';
import 'model/feedback_item.dart';

class FeedbackDetailPage extends StatelessWidget {
  final FeedbackItem feedback;
  final Function(String) onDelete;
  
  const FeedbackDetailPage({
    super.key,
    required this.feedback,
    required this.onDelete,
  });
  
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus feedback ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                onDelete(feedback.id);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Feedback berhasil dihapus!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Feedback'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informasi Mahasiswa
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Mahasiswa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Nama', feedback.nama),
                    _buildDetailRow('NIM', feedback.nim),
                    _buildDetailRow('Fakultas', feedback.fakultas),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Detail Feedback
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail Feedback',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Jenis Feedback', feedback.jenisFeedback),
                    _buildDetailRow('Nilai Kepuasan', feedback.nilaiKepuasan.toStringAsFixed(1)),
                    const SizedBox(height: 8),
                    const Text(
                      'Fasilitas yang Dinilai:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 8,
                      children: feedback.fasilitas.map((fasilitas) {
                        return Chip(
                          label: Text(fasilitas),
                          backgroundColor: Colors.blue[50],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Pesan Tambahan:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(feedback.pesanTambahan.isEmpty ? '-' : feedback.pesanTambahan),
                    const SizedBox(height: 12),
                    _buildDetailRow('Status Setuju Syarat', feedback.setujuSyarat ? 'Ya' : 'Tidak'),
                    _buildDetailRow(
                      'Tanggal', 
                      '${feedback.tanggal.day}/${feedback.tanggal.month}/${feedback.tanggal.year}'
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Tombol Aksi
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Kembali'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showDeleteDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Hapus'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}