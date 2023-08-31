import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text('Chat',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 10),
                    const Text('Login in this app',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)
                    ),
                    Image.asset('assets/logo.jpg'),
                  ],
                ),
              )
          ),
        ),
      )
    );
  }
}
