import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{

  static String userProfileKey='USERPROFILEKEY';
  static String userDetails='USERDETAILS';

  Future<bool> saveUserDetails(String getUserDetails) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.setString(userDetails, getUserDetails);
  }

  Future<String?> getUserDetails()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(userDetails);
  }

  Future<bool> saveUserProfile(String getUserProfile) async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.setString(userProfileKey, getUserProfile);
  }

  Future<String?> getUserProfile()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString(userProfileKey);
  }
}