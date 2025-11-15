import 'package:flutter/material.dart';
import 'model/feedback_item.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _facultyController = TextEditingController();
  final _messageController = TextEditingController();
  String _feedbackType = 'Apresiasi';
  double _satisfaction = 3.0;
  bool _isAgreed = false;
  List<String> _selectedFacilities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Feedback Mahasiswa'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(labelText: 'NIM'),
                validator: (value) =>
                    value!.isEmpty ? 'NIM tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _facultyController,
                decoration: const InputDecoration(labelText: 'Fakultas'),
                validator: (value) =>
                    value!.isEmpty ? 'Fakultas tidak boleh kosong' : null,
              ),
              const SizedBox(height: 10),
              const Text('Jenis Feedback:'),
              DropdownButtonFormField<String>(
                value: _feedbackType,
                items: const [
                  DropdownMenuItem(value: 'Apresiasi', child: Text('Apresiasi')),
                  DropdownMenuItem(value: 'Keluhan', child: Text('Keluhan')),
                  DropdownMenuItem(value: 'Saran', child: Text('Saran')),
                ],
                onChanged: (value) => setState(() => _feedbackType = value!),
              ),
              const SizedBox(height: 16),
              const Text('Tingkat Kepuasan:'),
              Slider(
                value: _satisfaction,
                min: 1,
                max: 5,
                divisions: 4,
                label: _satisfaction.toString(),
                onChanged: (value) => setState(() => _satisfaction = value),
              ),
              const SizedBox(height: 16),
              const Text('Pesan Tambahan:'),
              TextFormField(
                controller: _messageController,
                maxLines: 3,
              ),
              CheckboxListTile(
                title: const Text('Saya setuju dengan syarat & ketentuan'),
                value: _isAgreed,
                onChanged: (val) => setState(() => _isAgreed = val ?? false),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final feedbackItem = FeedbackItem(
                      name: _nameController.text,
                      nim: _nimController.text,
                      faculty: _facultyController.text,
                      facilities: _selectedFacilities,
                      satisfaction: _satisfaction,
                      feedbackType: _feedbackType,
                      isAgreed: _isAgreed,
                      additionalMessage: _messageController.text,
                    );

                    // Kirim balik data ke halaman sebelumnya
                    Navigator.pop(context, feedbackItem);
                  }
                },
                child: const Text('Simpan Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
