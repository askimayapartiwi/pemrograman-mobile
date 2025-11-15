import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State untuk switch toggle - ✅ SUDAH DIPERBAIKI
  bool _notificationsEnabled = true;
  bool _darkThemeEnabled = false;
  bool _autoSaveEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferensi Aplikasi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingSwitch(
                    context,
                    'Notifikasi',
                    'Aktifkan notifikasi aplikasi',
                    Icons.notifications,
                    _notificationsEnabled, // ✅ PAKAI VARIABLE YANG BENAR
                    (value) {
                      setState(() {
                        _notificationsEnabled = value; // ✅ PAKAI VARIABLE YANG BENAR
                      });
                      _showSnackbar(context, 
                        value ? 'Notifikasi diaktifkan' : 'Notifikasi dimatikan');
                    },
                  ),
                  _buildSettingSwitch(
                    context,
                    'Tema Gelap',
                    'Gunakan tema gelap',
                    Icons.dark_mode,
                    _darkThemeEnabled,
                    (value) {
                      setState(() {
                        _darkThemeEnabled = value;
                      });
                      _showSnackbar(context, 
                        value ? 'Tema gelap diaktifkan' : 'Tema gelap dimatikan');
                    },
                  ),
                  _buildSettingSwitch(
                    context,
                    'Auto-save',
                    'Simpan otomatis perubahan',
                    Icons.save,
                    _autoSaveEnabled,
                    (value) {
                      setState(() {
                        _autoSaveEnabled = value;
                      });
                      _showSnackbar(context, 
                        value ? 'Auto-save diaktifkan' : 'Auto-save dimatikan');
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privasi & Keamanan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingItem(
                    context,
                    'Ubah Password',
                    Icons.lock,
                    () {
                      _showComingSoonDialog(context, 'Ubah Password');
                    },
                  ),
                  _buildSettingItem(
                    context,
                    'Privasi Data',
                    Icons.security,
                    () {
                      _showComingSoonDialog(context, 'Privasi Data');
                    },
                  ),
                  _buildSettingItem(
                    context,
                    'Izin Aplikasi',
                    Icons.admin_panel_settings,
                    () {
                      _showComingSoonDialog(context, 'Izin Aplikasi');
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tentang Aplikasi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildAboutItem(
                    context,
                    'Versi',
                    '1.0.0',
                    Icons.info,
                  ),
                  _buildAboutItem(
                    context,
                    'Developer',
                    'Tim Flutter',
                    Icons.code,
                  ),
                  _buildAboutItem(
                    context,
                    'Lisensi',
                    'MIT License',
                    Icons.description,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              _showLogoutDialog(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout),
                SizedBox(width: 8),
                Text('Keluar Aplikasi'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Icon(icon),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  Widget _buildAboutItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
      onTap: () {
        _showSnackbar(context, '$title: $value');
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _showSnackbar(context, 'Berhasil keluar aplikasi');
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fitur Dalam Pengembangan'),
          content: Text('Fitur "$feature" sedang dalam pengembangan.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}