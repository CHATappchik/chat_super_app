import 'package:bloc/bloc.dart';
import 'package:chat_super_app/bloc/theme_state.dart';
import '../repository/theme_repository.dart';

enum ThemeEvent { changeTheme }

class ThemeCubit extends Cubit<AppTheme> {
  final ThemeRepository themeRepository;

  ThemeCubit(this.themeRepository) : super(AppTheme.red);

  void changeTheme(AppTheme theme) {
    emit(theme);
    themeRepository.saveTheme(theme);
  }

  Future<void> loadTheme() async {
    final savedTheme = await themeRepository.loadTheme();
    emit(savedTheme);
  }
}
