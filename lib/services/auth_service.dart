import 'package:chat_super_app/helper/helper_file.dart';
import 'package:chat_super_app/services/database_servise.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login

  Future loginUser(String email, String password) async{
    try{
      User user = (await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password)).user!;

      if(user != null) {
        return true;
      }

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }


  //register
 Future registerUser(String fullName, String email, String password) async{
   try{
     User user = (await firebaseAuth.createUserWithEmailAndPassword(
         email: email, password: password)).user!;

     if(user != null) {
       await DataBaseService(uid: user.uid).savingUserData(fullName, email);

       return true;
     }

   } on FirebaseAuthException catch (e) {
     return e.message;
   }
 }

 //signout

Future signOut() async{
   try {
     await HelperFunction.saveUserLoggedInStatus(false);
     await HelperFunction.saveUserEmailSF("");
     await HelperFunction.saveUserNameSF("");
     await firebaseAuth.signOut();
   }catch(e) {
     return null;
   }
}
}