class AppConstants {
  // ============ APP INFO ============
  static const String appName = 'Campus Task Manager';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Aplikasi Manajemen Tugas Kuliah';
  static const String developer = 'Tim Mahasiswa';
  static const String supportEmail = 'support@campustaskmanager.com';
  
  // ============ TASK CONSTRAINTS ============
  static const int maxTaskTitleLength = 100;
  static const int maxTaskDescriptionLength = 500;
  static const int minTaskTitleLength = 3;
  static const int minTaskDescriptionLength = 10;
  static const int maxTasksPerDay = 20; // Batasan jumlah tugas per hari
  static const int maxPriorityLevel = 5; // Skala prioritas 1-5
  
  // ============ API & NETWORK ============
  static const String quoteApiUrl = 'https://api.quotable.io/random';
  static const String quoteApiAlternative = 'https://zenquotes.io/api/random';
  static const List<String> quoteTags = ['inspirational', 'motivational', 'education', 'success', 'wisdom'];
  static const Duration apiTimeout = Duration(seconds: 5);
  static const int maxRetryAttempts = 2;
  
  // ============ FALLBACK QUOTES ============
  static const List<String> fallbackQuotes = [
    'Konsistensi belajar hari ini adalah investasi sukses esok hari.',
    'Tugas yang diselesaikan tepat waktu adalah langkah menuju IPK tinggi.',
    'Semangat mahasiswa! Setiap tugas yang selesai adalah kemenangan kecil.',
    'Manajemen waktu yang baik adalah kunci kesuksesan akademik.',
    'Belajar hari ini, sukses esok hari.',
    'Konsistensi adalah kunci kesuksesan akademik.',
    'Jangan tunda apa yang bisa dikerjakan hari ini.',
    'Mimpi besar dimulai dengan langkah kecil yang konsisten.',
    'Kualitas lebih penting dari kuantitas dalam belajar.',
    'Disiplin diri membawa kebebasan akademik.'
  ];
  
  static String get defaultQuote => fallbackQuotes.first;
  
  // ============ UI & THEME ============
  static const String primaryColorHex = '#2E294E';
  static const String secondaryColorHex = '#9055A2';
  static const String accentColorHex = '#D8B4E2';
  static const String successColorHex = '#4CAF50';
  static const String warningColorHex = '#FF9800';
  static const String errorColorHex = '#F44336';
  static const String infoColorHex = '#2196F3';
  
  // Padding & Spacing
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 8.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 48.0;
  
  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackbarDuration = Duration(seconds: 3);
  
  // ============ STORAGE KEYS ============
  static const String themeModeKey = 'theme_mode';
  static const String lastEmailKey = 'last_email';
  static const String rememberMeKey = 'remember_me';
  static const String firstLaunchKey = 'first_launch';
  static const String userTasksKey = 'user_tasks';
  static const String appSettingsKey = 'app_settings';
  static const String notificationPrefsKey = 'notification_preferences';
  
  // ============ NOTIFICATIONS ============
  static const String defaultNotificationChannel = 'task_reminders';
  static const String notificationChannelName = 'Task Reminders';
  static const String notificationChannelDescription = 'Reminders for upcoming tasks';
  
  // Default reminder times (in minutes before deadline)
  static const List<int> defaultReminderTimes = [1440, 720, 360, 60]; // 1 hari, 12 jam, 6 jam, 1 jam
  
  // ============ VALIDATION MESSAGES ============
  static const String taskTitleEmptyError = 'Judul tugas tidak boleh kosong';
  static const String taskTitleTooShortError = 'Judul terlalu pendek (min. $minTaskTitleLength karakter)';
  static const String taskTitleTooLongError = 'Judul terlalu panjang (max. $maxTaskTitleLength karakter)';
  static const String taskDescriptionTooShortError = 'Deskripsi terlalu pendek (min. $minTaskDescriptionLength karakter)';
  static const String taskDescriptionTooLongError = 'Deskripsi terlalu panjang (max. $maxTaskDescriptionLength karakter)';
  
  // ============ DATE FORMATS ============
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String dayDateFormat = 'EEEE, dd MMMM yyyy';
  
  // ============ ACADEMIC PERIODS ============
  static const List<String> academicPeriods = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8',
    'Tugas Akhir',
  ];
  
  // ============ TASK CATEGORIES ============
  static const List<String> taskCategories = [
    'Tugas',
    'UTS',
    'UAS',
    'Proyek',
    'Presentasi',
    'Laporan',
    'Praktikum',
    'Kuis',
    'Lainnya',
  ];
  
  // ============ PRIORITY LABELS ============
  static const Map<int, String> priorityLabels = {
    1: 'Sangat Rendah',
    2: 'Rendah',
    3: 'Sedang',
    4: 'Tinggi',
    5: 'Sangat Tinggi',
  };
  
  // Helper method untuk mendapatkan color dari priority
  static String getPriorityColorHex(int priority) {
    switch (priority) {
      case 1:
        return '#4CAF50'; // Hijau
      case 2:
        return '#8BC34A'; // Hijau muda
      case 3:
        return '#FFC107'; // Kuning
      case 4:
        return '#FF9800'; // Orange
      case 5:
        return '#F44336'; // Merah
      default:
        return '#9E9E9E'; // Abu-abu
    }
  }
}