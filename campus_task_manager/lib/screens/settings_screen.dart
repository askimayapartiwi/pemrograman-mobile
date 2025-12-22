import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/common/custom_appbar.dart';
import '../theme/app_theme.dart';
import 'auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // ================= LOGOUT =================
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              await authProvider.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
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

  // ================= PRIVACY POLICY =================
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kebijakan Privasi'),
        content: const SingleChildScrollView(
          child: Text(
            '''
Campus Task Manager menghargai privasi pengguna.

Aplikasi ini mengumpulkan data berikut:
- Email pengguna untuk autentikasi
- Data tugas (judul, deskripsi, deadline)

Data disimpan menggunakan Firebase dan hanya dapat diakses oleh pengguna terkait.

Kami tidak membagikan data pengguna kepada pihak ketiga mana pun.

Dengan menggunakan aplikasi ini, Anda menyetujui kebijakan privasi ini.
            ''',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('TUTUP'),
          ),
        ],
      ),
    );
  }

  // ================= TERMS =================
  void _showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Syarat & Ketentuan'),
        content: const SingleChildScrollView(
          child: Text(
            '''
Dengan menggunakan aplikasi Campus Task Manager, pengguna setuju bahwa:

1. Aplikasi digunakan untuk keperluan pengelolaan tugas pribadi
2. Pengguna bertanggung jawab atas data yang dimasukkan
3. Aplikasi tidak menjamin kehilangan data akibat kesalahan pengguna
4. Aplikasi dapat diperbarui sewaktu-waktu

Aplikasi ini dibuat sebagai Final Project UAS Pemrograman Mobile.
            ''',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('TUTUP'),
          ),
        ],
      ),
    );
  }

  // ================= CLEAR CACHE =================
  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Cache'),
        content: const Text('Yakin ingin menghapus semua data cache?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache berhasil dihapus'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Pengaturan'),
      body: ListView(
        children: [
          // PROFILE
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryDark,
                    radius: 30,
                    child: Text(
                      authProvider.user?.email
                              ?.substring(0, 1)
                              .toUpperCase() ??
                          'U',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      authProvider.user?.email ?? 'Pengguna',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    onPressed: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            ),
          ),

          // THEME
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Ubah tema aplikasi'),
              value: themeProvider.isDarkMode,
              onChanged: themeProvider.toggleTheme,
              secondary: Icon(
                themeProvider.isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            ),
          ),

          // ABOUT
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text('Versi Aplikasi'),
              subtitle: Text('1.0.0'),
            ),
          ),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading:
                  const Icon(Icons.description, color: Colors.green),
              title: const Text('Kebijakan Privasi'),
              onTap: () => _showPrivacyPolicy(context),
            ),
          ),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading:
                  const Icon(Icons.security, color: Colors.orange),
              title: const Text('Syarat & Ketentuan'),
              onTap: () => _showTerms(context),
            ),
          ),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading:
                  const Icon(Icons.delete_sweep, color: Colors.red),
              title: const Text('Hapus Data Cache'),
              subtitle: const Text('Hapus semua data lokal'),
              onTap: () => _showClearCacheDialog(context),
            ),
          ),
        ],
      ),
    );
  }
}