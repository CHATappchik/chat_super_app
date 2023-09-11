import 'package:chat_super_app/repository/theme_repository.dart';
import 'package:chat_super_app/screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/theme_cubit.dart';
import 'bloc/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(ThemeRepository()),
      child: Builder(
        builder: (context) {
          final themeCubit = context.watch<ThemeCubit>();
          final currentTheme = themeCubit.state;
          final themeData = ThemeData(
            primaryColor: getThemeColor(currentTheme),
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
            ),
            useMaterial3: true,
            brightness: currentTheme == AppTheme.dark
                ? Brightness.dark
                : Brightness.light,
          );
          return MaterialApp(
            title: 'Flutter Demo',
            theme: themeData,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

