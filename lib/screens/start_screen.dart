import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_super_app/screens/temporary_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../services/logged_status.dart';
import 'auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool _isSignedIn;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }
  getUserLoggedInStatus() async{
      if(LoggedStatus.getCurrentUser() == null) {
        _isSignedIn = true;
      }else {
        _isSignedIn = false;
      }
    }


  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Column(
          children: [
            Image.asset('assets/logo.jpg'),
            const Text('Chat for superIV',
            style: TextStyle(fontSize: 40,fontWeight:  FontWeight.bold, color: Colors.purple)
            ),
          ],
        ),
        backgroundColor: Colors.white,
        nextScreen: _isSignedIn ? const MyHomePage(title: 'Temporary Page') : const LoginPage(),
        splashIconSize: 250,
      duration: 3000,
      splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 2),
    );
  }
}
