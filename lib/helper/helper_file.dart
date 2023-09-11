import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {

  //keys

  static String userLoggedinKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  // saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedinKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }



  //geting the data from SF

static Future<bool?> getUserLoggedInStatus() async{
  SharedPreferences sf = await SharedPreferences.getInstance();
  return sf.getBool(userLoggedinKey);
}


}