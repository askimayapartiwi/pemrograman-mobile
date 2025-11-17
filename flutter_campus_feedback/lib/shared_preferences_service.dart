import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences _prefs;
  static bool _isInitialized = false;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
    print('✅ SharedPreferences initialized');
  }

  // Feedback Data - DENGAN DEBUG PRINT
  static Future<void> saveFeedbackList(List<Map<String, dynamic>> feedbackList) async {
    if (!_isInitialized) await init();
    
    try {
      print('💾 Menyimpan ${feedbackList.length} data feedback');
      
      final List<String> feedbackStringList = feedbackList.map((feedback) {
        // ✅ PERBAIKI: Simpan tanggal sebagai millisecondsSinceEpoch
        String data = '${feedback['id']}|${feedback['nama']}|${feedback['nim']}|${feedback['fakultas']}|${feedback['fasilitas'].join(',')}|${feedback['nilaiKepuasan']}|${feedback['jenisFeedback']}|${feedback['pesanTambahan']}|${feedback['setujuSyarat']}|${(feedback['tanggal'] as DateTime).millisecondsSinceEpoch}';
        print('📝 Data yang disimpan: $data');
        return data;
      }).toList();
      
      await _prefs.setStringList('feedbackList', feedbackStringList);
      print('✅ Data berhasil disimpan ke SharedPreferences');
    } catch (e) {
      print('❌ Error saving to SharedPreferences: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getFeedbackList() async {
    if (!_isInitialized) await init();
    
    try {
      final List<String>? feedbackStringList = _prefs.getStringList('feedbackList');
      print('📖 Membaca data dari SharedPreferences: ${feedbackStringList?.length ?? 0} items');
      
      // ✅ TAMBAH: BUAT DATA MANUAL JIKA BELUM ADA DATA
      if (feedbackStringList == null || feedbackStringList.isEmpty) {
        print('🎯 Tidak ada data, membuat data manual...');
        return await _createManualData();
      }

      final List<Map<String, dynamic>> feedbackList = [];
      
      for (String feedbackString in feedbackStringList) {
        try {
          final List<String> parts = feedbackString.split('|');
          print('🔍 Parsing data: $feedbackString');
          
          if (parts.length == 10) {
            feedbackList.add({
              'id': parts[0],
              'nama': parts[1],
              'nim': parts[2],
              'fakultas': parts[3],
              'fasilitas': parts[4].split(','),
              'nilaiKepuasan': double.parse(parts[5]),
              'jenisFeedback': parts[6],
              'pesanTambahan': parts[7],
              'setujuSyarat': parts[8] == 'true',
              // ✅ PERBAIKI: Parse dari millisecondsSinceEpoch
              'tanggal': DateTime.fromMillisecondsSinceEpoch(int.parse(parts[9])),
            });
            print('✅ Data berhasil di-parse: ${parts[1]}');
          } else {
            print('❌ Format data tidak valid, expected 10 parts, got ${parts.length}');
          }
        } catch (e) {
          print('❌ Error parsing feedback string: $e');
        }
      }
      
      print('📊 Total data yang berhasil di-load: ${feedbackList.length}');
      return feedbackList;
    } catch (e) {
      print('❌ Error reading from SharedPreferences: $e');
      return [];
    }
  }

  // ✅ TAMBAH: METHOD UNTUK BUAT DATA MANUAL
  static Future<List<Map<String, dynamic>>> _createManualData() async {
    print('🎯 Membuat data manual untuk testing...');
    
    final List<Map<String, dynamic>> manualData = [
      {
        'id': 'manual_1',
        'nama': 'Jihan Nabillah',
        'nim': '701230022',
        'fakultas': 'Sains dan Teknologi',
        'jenisFeedback': 'Apresiasi',
        'nilaiKepuasan': 4.8,
        'fasilitas': ['Perpustakaan', 'Laboratorium', 'WiFi'],
        'pesanTambahan': 'Fasilitas kampus sangat lengkap dan nyaman',
        'setujuSyarat': true,
        'tanggal': DateTime(2024, 2, 1),
      },
      {
        'id': 'manual_2',
        'nama': 'Nadhif Pandya Supriadi',
        'nim': '701230024',
        'fakultas': 'Sains dan Teknologi',
        'jenisFeedback': 'Saran',
        'nilaiKepuasan': 3.2,
        'fasilitas': ['Laboratorium'],
        'pesanTambahan': 'Mohon tambah peralatan di lab komputer',
        'setujuSyarat': true,
        'tanggal': DateTime(2024, 1, 25),
      },
      {
        'id': 'manual_3',
        'nama': 'Aldi Darmawan',
        'nim': '701230026',
        'fakultas': 'Sains dan Teknologi',
        'jenisFeedback': 'Keluhan',
        'nilaiKepuasan': 2.5,
        'fasilitas': ['Ruang Kelas'],
        'pesanTambahan': 'AC di ruang belajar sering tidak dingin',
        'setujuSyarat': true,
        'tanggal': DateTime(2024, 1, 20),
      }
    ];

    // Simpan data manual ke SharedPreferences
    await saveFeedbackList(manualData);
    print('✅ Data manual berhasil dibuat: ${manualData.length} items');
    
    return manualData;
  }

  // ✅ TAMBAH: METHOD UNTUK TAMBAH DATA BARU
  static Future<void> addNewFeedback(Map<String, dynamic> newFeedback) async {
    final List<Map<String, dynamic>> currentData = await getFeedbackList();
    currentData.insert(0, newFeedback);
    await saveFeedbackList(currentData);
    print('➕ Data baru ditambahkan: ${newFeedback['nama']}');
  }

  // Dark Mode
  static Future<bool> isDarkMode() async {
    if (!_isInitialized) await init();
    return _prefs.getBool('isDarkMode') ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    if (!_isInitialized) await init();
    await _prefs.setBool('isDarkMode', value);
  }

  // Clear all data (for testing)
  static Future<void> clearAllData() async {
    if (!_isInitialized) await init();
    await _prefs.clear();
    print('🗑️ Semua data dihapus');
  }
}