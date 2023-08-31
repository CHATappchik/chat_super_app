import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_super_app/screens/temporary_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
        nextScreen: const MyHomePage(title: 'Temporary Page'),
        splashIconSize: 250,
      duration: 3000,
      splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 2),
    );
  }
}
