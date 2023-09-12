import 'package:chat_super_app/screens/profile_screen.dart';
import 'package:chat_super_app/screens/settings_screen.dart';
import 'package:chat_super_app/services/auth_service.dart';
import 'package:chat_super_app/services/often_abused_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_cubit.dart';
import '../bloc/theme_state.dart';
import 'auth/login_page.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final currentTheme = themeCubit.state;

    /*  final titleTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: currentTheme == AppTheme.dark ? Colors.white : Colors.black,
    );*/

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // буде реалізовано пошук
            },
            icon: const Icon(Icons.search),
          )
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Chats list',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 15),
            const Text(
              'Username',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 30),
            const Divider(height: 2),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(
                Icons.group,
                color: currentTheme == AppTheme.dark
                    ? Colors.white
                    : Theme.of(context).primaryColor,
              ),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: currentTheme == AppTheme.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()));
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(
                Icons.settings,
                color: currentTheme == AppTheme.dark
                    ? Colors.white
                    : Theme.of(context).primaryColor,
              ),
              title: Text(
                "Settings",
                style: TextStyle(
                  color: currentTheme == AppTheme.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?",
                            style: TextStyle(fontSize: 16)),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel_sharp,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 5),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                      (route) => false);
                            },
                            icon: const Icon(
                              Icons.done_outline_sharp,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                        ],
                      );
                    });
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(
                Icons.logout,
                color: currentTheme == AppTheme.dark
                    ? Colors.white
                    : Theme.of(context).primaryColor,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: currentTheme == AppTheme.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Create chat"),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("CANCEL"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("CREATE"),
                  ),
                ],
              );
            },
          );
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
