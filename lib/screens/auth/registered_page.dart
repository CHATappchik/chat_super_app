import 'package:chat_super_app/screens/auth/login_page.dart';
import 'package:chat_super_app/services/auth_service.dart';
import 'package:chat_super_app/services/logged_status.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../services/often_abused_function.dart';
import '../../services/style.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullName = '';
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)) :
        SingleChildScrollView(
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
                      const Text('Створіть Ваш акаунт',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400)),
                      Image.asset('assets/register.jpg'),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Full Name',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            fullName = value;
                          });
                        },

                        // check tha validation
                        validator: (value) {
                          if(value!.isNotEmpty) {
                            return null;
                          }else {
                            return 'Поле не може пути пустим';
                          }
                        },
                      ),
                      const SizedBox(height: 15),
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
                          child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 16)),
                          onPressed: () {
                            registration();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text.rich(
                          TextSpan(
                            text: 'Вже маєш акаунт?',
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Увійти',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    nextScreen(context, const LoginPage());
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
  registration() async{
    if(formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.registerUser(fullName, email, password)
      .then((value) async{
        if(value == true) {
          await LoggedStatus.saveUserLoggedInStatus(email, true);
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
