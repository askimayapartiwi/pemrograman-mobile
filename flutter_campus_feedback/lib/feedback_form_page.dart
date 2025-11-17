import 'package:flutter/material.dart';
import 'feedback_list_page.dart';
import 'model/feedback_item.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();
  
  // Form state
  String _fakultas = 'Fakultas Sains dan Teknologi';
  final List<String> _fasilitas = [];
  double _nilaiKepuasan = 3.0;
  String _jenisFeedback = 'Saran';
  bool _setujuSyarat = false;
  
  // List fakultas
  final List<String> _listFakultas = [
    'Fakultas Ilmu Tarbiyah dan Keguruan',
    'Fakultas Syariah',
    'Fakultas Ushuluddin dan Studi Agama',
    'Fakultas Adab dan Humaniora',
    'Fakultas Ekonomi dan Bisnis Islam',
    'Fakultas Sains dan Teknologi',
    'Fakultas Dakwah',
    'Fakultas Kedokteran',
  ];
  
  // List fasilitas
  final List<String> _listFasilitas = [
    'Perpustakaan',
    'Laboratorium',
    'Ruang Kelas',
    'Wi-Fi Kampus',
    'Kantin',
    'Parkir',
    'Olahraga',
    'Layanan Administrasi',
  ];

  void _simpanFeedback() {
    if (_formKey.currentState!.validate()) {
      if (!_setujuSyarat) {
        _showKonfirmasiDialog();
        return;
      }
      
      if (_fasilitas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih minimal satu fasilitas yang dinilai!'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      // Buat feedback item
      final feedbackItem = FeedbackItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nama: _namaController.text,
        nim: _nimController.text,
        fakultas: _fakultas,
        fasilitas: _fasilitas,
        nilaiKepuasan: _nilaiKepuasan,
        jenisFeedback: _jenisFeedback,
        pesanTambahan: _pesanController.text,
        setujuSyarat: _setujuSyarat,
        tanggal: DateTime.now(),
      );
      
      // Navigasi ke halaman list dengan CLEAR STACK
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackListPage(feedbackItem: feedbackItem),
        ),
        (route) => false,
      );
      
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  void _showKonfirmasiDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Anda harus menyetujui syarat dan ketentuan sebelum menyimpan feedback.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
        title: const Text('Form Feedback Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Mahasiswa
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mahasiswa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama mahasiswa wajib diisi';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // NIM
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIM wajib diisi';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'NIM harus berupa angka';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Fakultas
              DropdownButtonFormField<String>(
                value: _fakultas,
                decoration: const InputDecoration(
                  labelText: 'Fakultas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                items: _listFakultas.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _fakultas = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih fakultas';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Fasilitas yang Dinilai
              const Text(
                'Fasilitas yang Dinilai:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._listFasilitas.map((fasilitas) {
                return CheckboxListTile(
                  title: Text(fasilitas),
                  value: _fasilitas.contains(fasilitas),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        _fasilitas.add(fasilitas);
                      } else {
                        _fasilitas.remove(fasilitas);
                      }
                    });
                  },
                );
              }),
              
              const SizedBox(height: 16),
              
              // Nilai Kepuasan
              Text(
                'Nilai Kepuasan: ${_nilaiKepuasan.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _nilaiKepuasan,
                min: 1,
                max: 5,
                divisions: 4,
                label: _nilaiKepuasan.toStringAsFixed(1),
                onChanged: (double value) {
                  setState(() {
                    _nilaiKepuasan = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('1 (Sangat Buruk)'),
                  Text('5 (Sangat Baik)'),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Jenis Feedback
              const Text(
                'Jenis Feedback:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Saran'),
                    value: 'Saran',
                    groupValue: _jenisFeedback,
                    onChanged: (String? value) {
                      setState(() {
                        _jenisFeedback = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Keluhan'),
                    value: 'Keluhan',
                    groupValue: _jenisFeedback,
                    onChanged: (String? value) {
                      setState(() {
                        _jenisFeedback = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Apresiasi'),
                    value: 'Apresiasi',
                    groupValue: _jenisFeedback,
                    onChanged: (String? value) {
                      setState(() {
                        _jenisFeedback = value!;
                      });
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Pesan Tambahan
              TextFormField(
                controller: _pesanController,
                decoration: const InputDecoration(
                  labelText: 'Pesan Tambahan',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan saran, keluhan, atau apresiasi Anda...',
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 16),
              
              // Setuju Syarat & Ketentuan
              SwitchListTile(
                title: const Text('Saya Menyetujui Syarat dan Ketentuan'),
                value: _setujuSyarat,
                onChanged: (bool value) {
                  setState(() {
                    _setujuSyarat = value;
                  });
                },
              ),
              
              const SizedBox(height: 24),
              
              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanFeedback,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Simpan Feedback',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _pesanController.dispose();
    super.dispose();
  }
}