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

  // controllers
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _pesanController = TextEditingController();

  // state
  String _fakultas = 'Fakultas Sains dan Teknologi';
  final List<String> _fasilitas = [];
  double _nilaiKepuasan = 3.0;
  String _jenisFeedback = 'Saran';
  bool _setujuSyarat = false;

  // list fakultas
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

  // list fasilitas
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

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackListPage(feedbackItem: feedbackItem),
        ),
        (route) => false,
      );

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
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text(
            'Anda harus menyetujui syarat dan ketentuan sebelum menyimpan feedback.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
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

              // Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Mahasiswa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama wajib diisi' : null,
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
                  if (value == null || value.isEmpty) return 'NIM wajib diisi';
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'NIM harus berupa angka';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Fakultas (fixed no overflow)
              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  value: _fakultas,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Fakultas',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school),
                  ),
                  items: _listFakultas.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _fakultas = value!),
                  validator: (value) =>
                      value == null ? 'Pilih fakultas' : null,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Fasilitas yang Dinilai:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              ..._listFasilitas.map((fasilitas) {
                return CheckboxListTile(
                  title: Text(fasilitas),
                  value: _fasilitas.contains(fasilitas),
                  onChanged: (value) {
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

              Text(
                'Nilai Kepuasan: ${_nilaiKepuasan.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              Slider(
                value: _nilaiKepuasan,
                min: 1,
                max: 5,
                divisions: 4,
                label: _nilaiKepuasan.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() => _nilaiKepuasan = value);
                },
              ),

              const SizedBox(height: 16),

              const Text(
                'Jenis Feedback:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              RadioListTile(
                title: const Text('Saran'),
                value: 'Saran',
                groupValue: _jenisFeedback,
                onChanged: (value) => setState(() => _jenisFeedback = value!),
              ),

              RadioListTile(
                title: const Text('Keluhan'),
                value: 'Keluhan',
                groupValue: _jenisFeedback,
                onChanged: (value) => setState(() => _jenisFeedback = value!),
              ),

              RadioListTile(
                title: const Text('Apresiasi'),
                value: 'Apresiasi',
                groupValue: _jenisFeedback,
                onChanged: (value) => setState(() => _jenisFeedback = value!),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _pesanController,
                decoration: const InputDecoration(
                  labelText: 'Pesan Tambahan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('Saya Menyetujui Syarat dan Ketentuan'),
                value: _setujuSyarat,
                onChanged: (value) =>
                    setState(() => _setujuSyarat = value),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanFeedback,
                  child: const Text('Simpan Feedback'),
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