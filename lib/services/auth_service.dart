
import 'package:chat_super_app/services/database_servise.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login


  //register
 Future registerUser(String fullName, String email, String password) async{
   try{
     User user = (await firebaseAuth.createUserWithEmailAndPassword(
         email: email, password: password)).user!;

     if(user != null) {
       await DataBaseService(uid: user.uid).updateUserData(fullName, email);

       return true;
     }

   } on FirebaseAuthException catch (e) {
     return e.message;
   }
 }
}