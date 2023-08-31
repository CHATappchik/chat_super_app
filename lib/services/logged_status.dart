import 'package:firebase_auth/firebase_auth.dart';

class LoggedStatus {
  // static Future<bool?> getUserLoggedStatus() async{
  //   SharedPreferences sf = await SharedPreferences.getInstance();
  //   return sf.getBool();
  // }


  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } catch (error) {
      print('Authentication error: $error');
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}
