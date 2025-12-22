import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();
  
  static SharedPreferences? _prefs;
  
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Theme
  Future<bool> getIsDarkMode() async {
    await _ensureInitialized();
    return _prefs!.getBool(AppConstants.themeModeKey) ?? false;
  }
  
  Future<void> setIsDarkMode(bool value) async {
    await _ensureInitialized();
    await _prefs!.setBool(AppConstants.themeModeKey, value);
  }
  
  // User Preferences
  Future<String?> getLastEmail() async {
    await _ensureInitialized();
    return _prefs!.getString(AppConstants.lastEmailKey);
  }
  
  Future<void> setLastEmail(String email) async {
    await _ensureInitialized();
    await _prefs!.setString(AppConstants.lastEmailKey, email);
  }
  
  Future<bool> getRememberMe() async {
    await _ensureInitialized();
    return _prefs!.getBool(AppConstants.rememberMeKey) ?? false;
  }
  
  Future<void> setRememberMe(bool value) async {
    await _ensureInitialized();
    await _prefs!.setBool(AppConstants.rememberMeKey, value);
  }
  
  // App State
  Future<bool> isFirstLaunch() async {
    await _ensureInitialized();
    return _prefs!.getBool(AppConstants.firstLaunchKey) ?? true;
  }
  
  Future<void> setFirstLaunch(bool value) async {
    await _ensureInitialized();
    await _prefs!.setBool(AppConstants.firstLaunchKey, value);
  }
  
  // Clear all data
  Future<void> clearAll() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }
  
  Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await init();
    }
  }
}