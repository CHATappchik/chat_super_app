import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/theme_state.dart';

class ThemeRepository {
  static const String themeKey = 'appTheme';

  Future<void> saveTheme(AppTheme theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeKey, theme.index);
  }

  Future<AppTheme> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(themeKey) ?? AppTheme.purple.index;
    return AppTheme.values[themeIndex];
  }
}
