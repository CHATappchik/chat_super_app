import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_cubit.dart';
import '../bloc/theme_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final currentTheme = themeCubit.state;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              "Color Themes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ThemeCircle(AppTheme.purple),
                ThemeCircle(AppTheme.red),
                ThemeCircle(AppTheme.blue),
                ThemeCircle(AppTheme.green),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Dark Theme",style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                const SizedBox(width: 10),
                Switch(
                  value: currentTheme == AppTheme.dark,
                  activeColor: Colors.white12,
                  onChanged: (newValue) {
                    themeCubit.toggleTheme();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ThemeCircle extends StatelessWidget {
  final AppTheme theme;

  const ThemeCircle(this.theme, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ThemeCubit>().changeTheme(theme);
      },
      borderRadius: BorderRadius.circular(50.0),
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: getThemeColor(theme),
        ),
      ),
    );
  }
}
