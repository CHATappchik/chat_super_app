import 'package:chat_super_app/screens/auth/registered_page.dart';
import 'package:chat_super_app/screens/chats_list_screen.dart';
import 'package:chat_super_app/services/style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../component/square_tile.dart';
import '../../services/auth_google_service.dart';
import '../../services/often_abused_function.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
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
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const Text('Login in this app',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400)),
                      Image.asset('assets/chat.png',
                        height: 125,
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },

                        // check tha validation
                        validator: (value) {
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!)
                              ? null
                              : "Будь ласка, введіть правильний формат emeil";
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        validator: (value) {
                          if(value!.length < 6) {
                            return 'Пароль має бути не менше 6 символів';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('Sign in', style: TextStyle(color: Colors.white, fontSize: 16)),
                          onPressed: () {
                            login();
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text('Or continue with',
                              style: TextStyle(color: Colors.grey[700])
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: SquareTile(onTap: () => AuthGoogleService().signInGoogle(),
                        imagePath: 'assets/google_new.png'),
                      ),
                      const SizedBox(height: 25),
                      Text.rich(
                          TextSpan(
                            text: 'Ще немає акаунта?',
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Зареєструватись',
                                style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  nextScreen(context, const RegisterPage());
                                }
                              ),
                            ],
                          ))
                    ],
                  ),
                )),
          ),
        )
    );
  }
  login() {
    if(formKey.currentState!.validate()) {
      nextScreen(context, const ChatsListScreen());
    }
  }
}
