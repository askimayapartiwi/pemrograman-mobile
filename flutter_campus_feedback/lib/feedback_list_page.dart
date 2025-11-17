import 'package:flutter/material.dart';
import 'feedback_detail_page.dart';
import 'feedback_form_page.dart';
import 'model/feedback_item.dart';
import 'shared_preferences_service.dart';
import 'feedback_search_delegate.dart';

class FeedbackListPage extends StatefulWidget {
  final FeedbackItem? feedbackItem;
  
  const FeedbackListPage({super.key, this.feedbackItem});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  List<FeedbackItem> _feedbackList = [];
  bool _isLoading = true;
  DateTime? _lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _loadFeedbackData();
  }

  Future<void> _loadFeedbackData() async {
    setState(() {
      _isLoading = true;
    });

    // Load from SharedPreferences
    final List<Map<String, dynamic>> savedFeedback = await SharedPreferencesService.getFeedbackList();
    
    setState(() {
      _feedbackList = savedFeedback.map((data) => FeedbackItem.fromMap(data)).toList();
      
      // Add new feedback if provided
      if (widget.feedbackItem != null) {
        _feedbackList.insert(0, widget.feedbackItem!);
        _saveFeedbackData();
      }
      
      _isLoading = false;
    });
  }

  Future<void> _saveFeedbackData() async {
    final List<Map<String, dynamic>> feedbackMapList = _feedbackList.map((item) => item.toMap()).toList();
    await SharedPreferencesService.saveFeedbackList(feedbackMapList);
  }

  void _removeFeedback(String id) {
    setState(() {
      _feedbackList.removeWhere((item) => item.id == id);
    });
    _saveFeedbackData();
  }

  void _showSearch() {
    showSearch<FeedbackItem?>(
      context: context,
      delegate: FeedbackSearchDelegate(feedbackList: _feedbackList),
    ).then((result) {
      if (result != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeedbackDetailPage(
              feedback: result,
              onDelete: _removeFeedback,
            ),
          ),
        );
      }
    });
  }

  // ✅ TOMBOL BACK/KELUAR
  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null || 
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tekan back lagi untuk keluar aplikasi'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Keluar Aplikasi'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Tampilkan pesan keluar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gunakan tombol back device untuk keluar'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Keluar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  
  // ✅ WARNA IKON 
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Feedback'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // ✅ TAMBAH TOMBOL BACK/KELUAR DI SAMPING TITLE
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _showExitDialog();
            },
            tooltip: 'Keluar Aplikasi',
          ),
          actions: [
            // ✅ TOMBOL KELUAR (OPSIONAL)
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _showExitDialog,
              tooltip: 'Keluar Aplikasi',
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _showSearch,
              tooltip: 'Cari Feedback',
            ),
            // ✅ TOMBOL REFRESH
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadFeedbackData,
              tooltip: 'Refresh Data',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _feedbackList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.feedback, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum ada feedback',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const Text(
                          'Silakan tambah feedback melalui form',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FeedbackFormPage(),
                              ),
                            );
                          },
                          child: const Text('Tambah Feedback'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _feedbackList.length,
                    itemBuilder: (context, index) {
                      final feedback = _feedbackList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Icon(
                            _getIcon(feedback.jenisFeedback),
                            color: _getIconColor(feedback.jenisFeedback),
                            size: 30,
                          ),
                          title: Text(
                            feedback.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(feedback.fakultas),
                              Text('Nilai: ${feedback.nilaiKepuasan.toStringAsFixed(1)}'),
                              Text(
                                'Jenis: ${feedback.jenisFeedback}',
                                style: TextStyle(
                                  color: _getIconColor(feedback.jenisFeedback),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedbackDetailPage(
                                  feedback: feedback,
                                  onDelete: _removeFeedback,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
        // ✅ FLOATING ACTION BUTTON
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FeedbackFormPage(),
              ),
            );
          },
          child: const Icon(Icons.add),
          tooltip: 'Tambah Feedback Baru',
        ),
      ),
    );
  }
}