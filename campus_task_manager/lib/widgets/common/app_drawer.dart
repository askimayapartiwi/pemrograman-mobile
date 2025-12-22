import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Drawer(
      child: Column(
        children: [
          // Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryDark,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryDark,
                  AppTheme.primaryLight,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.school,
                    size: 30,
                    color: AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  authProvider.user?.email ?? 'Pengguna',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mahasiswa',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, AppRoutes.dashboard);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('Daftar Tugas'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, AppRoutes.taskList);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_circle),
                  title: const Text('Tambah Tugas'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, AppRoutes.taskForm);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  title: Text(
                    themeProvider.isDarkMode
                        ? 'Mode Terang'
                        : 'Mode Gelap',
                  ),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                    activeColor: AppTheme.primaryLight,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Pengaturan'),
                  onTap: () {
                    Navigator.popAndPushNamed(context, AppRoutes.settings);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.blue),
                  title: const Text('Tentang'),
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout'),
                  onTap: () {
                    _showLogoutDialog(context, authProvider);
                  },
                ),
              ],
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: const Column(
              children: [
                Text(
                  'Campus Task Manager',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'v1.0.0 • UAS Mobile Programming',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Aplikasi'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Campus Task Manager'),
            SizedBox(height: 8),
            Text('Aplikasi manajemen tugas kuliah yang dirancang khusus untuk mahasiswa.'),
            SizedBox(height: 12),
            Text('Fitur:'),
            Text('• Smart Deadline Indicator'),
            Text('• Auto Task Status'),
            Text('• Filter & Sort Tugas'),
            Text('• Dark/Light Mode'),
            SizedBox(height: 12),
            Text('Dibuat untuk Final Project UAS Pemrograman Mobile.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
  
  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close drawer
              await authProvider.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}