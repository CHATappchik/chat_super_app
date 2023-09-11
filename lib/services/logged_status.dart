import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoggedStatus {

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

  static Future<bool?> saveUserLoggedInStatus(String userEmeil, bool isUserLoggedIn) async {
  try {
  final firestore = FirebaseFirestore.instance;
     final userCheck =  await firestore.collection('users').doc(userEmeil);
    if(userCheck != null) {
      isUserLoggedIn = true;
    } else {
      isUserLoggedIn = false;
    }
    print(isUserLoggedIn);
    return isUserLoggedIn;
  } catch (error) {
  print('Помилка під час збереження стану користувача: $error');
  // Обробка помилок
  }
  }

}
