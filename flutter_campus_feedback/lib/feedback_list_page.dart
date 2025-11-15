import 'package:flutter/material.dart';
import 'feedback_detail_page.dart';
import 'feedback_form_page.dart';
import 'model/feedback_item.dart';

class FeedbackListPage extends StatefulWidget {
  const FeedbackListPage({super.key});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  // List lokal, bukan global
  final List<FeedbackItem> _feedbackItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text('Daftar Feedback Mahasiswa'),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: _feedbackItems.isEmpty
          ? const Center(
              child: Text(
                'Belum ada data feedback.\nSilakan isi form terlebih dahulu.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _feedbackItems.length,
              itemBuilder: (context, index) {
                final item = _feedbackItems[index];
                return _buildFeedbackCard(item);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add),
        onPressed: () async {
          // Buka halaman form dan tunggu hasil feedback baru
          final newFeedback = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FeedbackFormPage()),
          );

          if (newFeedback != null && newFeedback is FeedbackItem) {
            setState(() {
              _feedbackItems.add(newFeedback);
            });
          }
        },
      ),
    );
  }

  Widget _buildFeedbackCard(FeedbackItem item) {
    Color iconColor;
    IconData iconData;

    switch (item.feedbackType) {
      case 'Apresiasi':
        iconColor = Colors.green;
        iconData = Icons.thumb_up_alt_outlined;
        break;
      case 'Keluhan':
        iconColor = Colors.red;
        iconData = Icons.report_problem_outlined;
        break;
      default:
        iconColor = Colors.orange;
        iconData = Icons.lightbulb_outline;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle:
            Text('${item.faculty}\nNilai Kepuasan: ${item.satisfaction}/5'),
        isThreeLine: true,
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FeedbackDetailPage(feedbackItem: item),
            ),
          );
        },
      ),
    );
  }
}
