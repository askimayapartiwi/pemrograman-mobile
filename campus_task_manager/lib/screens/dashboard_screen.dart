import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

import '../widgets/dashboard/stats_card.dart';
import '../widgets/dashboard/quote_card.dart';
import '../widgets/dashboard/upcoming_tasks.dart';
import '../widgets/common/loading_indicator.dart';
import '../theme/app_theme.dart';

import 'task/task_detail_screen.dart';
import 'task/task_list_screen.dart';
import '../widgets/common/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();

  String _quote = 'Memuat motivasi...';
  String _author = '';
  bool _isLoadingQuote = false;

  @override
  void initState() {
    super.initState();
    _loadQuote();
    _loadTasks();
  }

  // ======================
  // LOAD MOTIVATIONAL QUOTE
  // ======================
  Future<void> _loadQuote() async {
    setState(() => _isLoadingQuote = true);

    try {
      final data = await _apiService.fetchRandomQuote();

      if (data != null && data.isNotEmpty) {
        setState(() {
          _quote = data[0]['q'] ?? 'Tetap semangat belajar!';
          _author = data[0]['a'] ?? 'Unknown';
        });
      } else {
        _setFallbackQuote();
      }
    } catch (e) {
      _setFallbackQuote();
    } finally {
      setState(() => _isLoadingQuote = false);
    }
  }

  void _setFallbackQuote() {
    setState(() {
      _quote = 'Orang sukses melakukan apa yang tidak dilakukan orang gagal.';
      _author = 'Robert Kiyosaki';
    });
    setState(() {
      _quote = 'Hidup adalah 10% apa yang terjadi pada kita dan 90% bagaimana kita meresponnya.';
      _author = 'Charles R. Swindoll';
    });
  }

  // ======================
  // LOAD TASKS
  // ======================
  Future<void> _loadTasks() async {
    final auth = context.read<AuthProvider>();
    final tasks = context.read<TaskProvider>();

    if (auth.user != null) {
      await tasks.fetchTasks(auth.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final authProvider = context.watch<AuthProvider>();

    if (taskProvider.isLoading) {
      return const Scaffold(
        body: FullScreenLoader(message: 'Memuat dashboard...'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await _loadQuote();
              await _loadTasks();
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadQuote();
          await _loadTasks();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======================
              // GREETING
              // ======================
              Text(
                'Halo, ${authProvider.user?.email?.split('@').first ?? 'Mahasiswa'} 👋',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Selamat datang di Campus Task Manager',
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 24),

              // ======================
              // STATISTIK
              // ======================
              const Text(
                'Statistik Tugas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  StatsCard(
                    title: 'Total',
                    value: taskProvider.totalTasks.toString(),
                    icon: Icons.assignment,
                    color: AppTheme.primaryDark,
                  ),
                  StatsCard(
                    title: 'Selesai',
                    value: taskProvider.completedTasks.toString(),
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  StatsCard(
                    title: 'Pending',
                    value: taskProvider.pendingTasks.toString(),
                    icon: Icons.pending,
                    color: Colors.orange,
                  ),
                  StatsCard(
                    title: 'Terlambat',
                    value: taskProvider.overdueTasks.toString(),
                    icon: Icons.warning,
                    color: Colors.red,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ======================
              // QUOTE
              // ======================
              QuoteCard(
                quote: _quote,
                author: _author,
                isLoading: _isLoadingQuote,
                onRefresh: _loadQuote,
              ),

              const SizedBox(height: 24),

              // ======================
              // UPCOMING TASKS
              // ======================
              UpcomingTasks(
                tasks: taskProvider.upcomingTasks,
                onViewAll: () =>
                    Navigator.pushNamed(context, '/tasks'),
                onTaskTap: (task) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskDetailScreen(task: task),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // ======================
              // QUICK ACTIONS
              // ======================
              const Text(
                'Aksi Cepat',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OpenContainer(
                      openBuilder: (_, __) => const TaskListScreen(),
                      closedBuilder: (_, __) => _quickCard(
                        icon: Icons.add,
                        label: 'Tambah Tugas',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OpenContainer(
                      openBuilder: (_, __) {
                        taskProvider.setFilter('Hari Ini');
                        return const TaskListScreen();
                      },
                      closedBuilder: (_, __) => _quickCard(
                        icon: Icons.today,
                        label: 'Hari Ini',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryDark,
        onPressed: () =>
            Navigator.pushNamed(context, '/task/form'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _quickCard({required IconData icon, required String label}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppTheme.primaryLight),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}