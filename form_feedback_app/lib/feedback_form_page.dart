
import 'package:flutter/material.dart';
import 'feedback_result_page.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  int _rating = 1; // nilai awal rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartFeedback'),
        backgroundColor: Colors.teal.shade400,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    '📝 Beri Kami Feedback!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Input Nama
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Anda',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Komentar
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Komentar',
                      prefixIcon: Icon(Icons.comment_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Input Rating (Bintang) — versi anti overflow
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Hitung ukuran bintang berdasarkan lebar layar
                      double screenWidth = constraints.maxWidth;
                      double starSize = screenWidth < 340
                          ? 24
                          : screenWidth < 400
                          ? 28
                          : 32;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Rating:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(5, (index) {
                                int starIndex = index + 1;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _rating = starIndex;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Icon(
                                      Icons.star,
                                      size: starSize,
                                      color: _rating >= starIndex
                                          ? Colors.amber
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Tombol Kirim
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_nameController.text.isEmpty ||
                          _commentController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Harap isi semua kolom terlebih dahulu!'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedbackResultPage(
                              name: _nameController.text,
                              comment: _commentController.text,
                              rating: _rating,
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.send),
                    label: const Text(
                      'Kirim Feedback',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade400,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
