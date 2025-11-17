import 'package:flutter/material.dart';
import 'model/feedback_item.dart';

class FeedbackSearchDelegate extends SearchDelegate<FeedbackItem?> {
  final List<FeedbackItem> feedbackList;

  FeedbackSearchDelegate({required this.feedbackList});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final List<FeedbackItem> searchResults = feedbackList.where((feedback) {
      final String searchLower = query.toLowerCase();
      return feedback.nama.toLowerCase().contains(searchLower) ||
          feedback.nim.toLowerCase().contains(searchLower) ||
          feedback.fakultas.toLowerCase().contains(searchLower) ||
          feedback.jenisFeedback.toLowerCase().contains(searchLower) ||
          feedback.fasilitas.any((fasilitas) => fasilitas.toLowerCase().contains(searchLower));
    }).toList();

    if (searchResults.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada hasil ditemukan',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final feedback = searchResults[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: Icon(
              _getIcon(feedback.jenisFeedback),
              color: _getIconColor(feedback.jenisFeedback), // ✅ WARNA YANG SAMA
            ),
            title: Text(feedback.nama),
            subtitle: Text('${feedback.fakultas} - ${feedback.jenisFeedback}'),
            trailing: Text('Nilai: ${feedback.nilaiKepuasan.toStringAsFixed(1)}'),
            onTap: () {
              close(context, feedback);
            },
          ),
        );
      },
    );
  }

  // ✅ WARNA IKON YANG SAMA
  Color _getIconColor(String jenisFeedback) {
    switch (jenisFeedback) {
      case 'Apresiasi':
        return Colors.green;
      case 'Saran':
        return Colors.amber;
      case 'Keluhan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(String jenisFeedback) {
    switch (jenisFeedback) {
      case 'Apresiasi':
        return Icons.thumb_up;
      case 'Saran':
        return Icons.lightbulb;
      case 'Keluhan':
        return Icons.warning;
      default:
        return Icons.feedback;
    }
  }
}