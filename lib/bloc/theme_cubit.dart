import 'package:bloc/bloc.dart';
import 'package:chat_super_app/bloc/theme_state.dart';
import '../repository/theme_repository.dart';

enum ThemeEvent { changeTheme }

class ThemeCubit extends Cubit<AppTheme> {
  final ThemeRepository themeRepository;
  AppTheme? previousTheme;

  ThemeCubit(this.themeRepository) : super(AppTheme.purple) {
    _loadSavedTheme();
  }

  void changeTheme(AppTheme theme) {
    previousTheme = state;
    emit(theme);
    themeRepository.saveTheme(theme);
  }

  Future<void> _loadSavedTheme() async {
    final savedTheme = await themeRepository.loadTheme();
    emit(savedTheme);
  }

  Future<void> toggleTheme() async {
    if (state == AppTheme.dark) {
      emit(previousTheme!);
      themeRepository.saveTheme(previousTheme!);
    } else {
      previousTheme = state;
      emit(AppTheme.dark);
      themeRepository.saveTheme(AppTheme.dark);
    }
  }

  Future<void> loadSavedTheme() async {
    final savedTheme = await themeRepository.loadTheme();
    emit(savedTheme);
  }
}
