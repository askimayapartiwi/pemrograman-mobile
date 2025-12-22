class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    
    return null;
  }
  
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    
    if (value != password) {
      return 'Password tidak sama';
    }
    
    return null;
  }
  
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    
    if (value.length < 3) {
      return 'Nama minimal 3 karakter';
    }
    
    return null;
  }
  
  static String? validateTaskTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Judul tugas tidak boleh kosong';
    }
    
    if (value.length < 3) {
      return 'Judul minimal 3 karakter';
    }
    
    if (value.length > 100) {
      return 'Judul maksimal 100 karakter';
    }
    
    return null;
  }
  
  static String? validateTaskDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Deskripsi tidak boleh kosong';
    }
    
    if (value.length < 10) {
      return 'Deskripsi minimal 10 karakter';
    }
    
    if (value.length > 500) {
      return 'Deskripsi maksimal 500 karakter';
    }
    
    return null;
  }
  
  static String? validateDeadline(DateTime? deadline) {
    if (deadline == null) {
      return 'Deadline harus diisi';
    }
    
    final now = DateTime.now();
    if (deadline.isBefore(now)) {
      return 'Deadline tidak boleh di masa lalu';
    }
    
    return null;
  }
}