import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_super_app/helper/helper_file.dart';
import 'package:chat_super_app/screens/chats_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }
  getUserLoggedInStatus() async{
      await HelperFunction.getUserLoggedInStatus().then((value) {
        if(value!=null) {
          setState(() {
            _isSignedIn = value;
          });
        }
      });
    }


  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: [
            Image.asset('assets/logo.jpg'),
            const Text('Chat',
            style: TextStyle(fontSize: 40,fontWeight:  FontWeight.bold, color: Colors.purple)
            ),
          ],
        ),
        backgroundColor: Colors.white,
        nextScreen: _isSignedIn ? const ChatsListScreen() : const LoginPage(),
        splashIconSize: 250,
      duration: 3000,
      splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 2),
    );
  }
}
