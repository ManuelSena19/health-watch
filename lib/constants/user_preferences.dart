import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeUserDataInSharedPrefs(
    String email, Map<String, dynamic> userData) async {
  final sharedPrefs = await SharedPreferences.getInstance();
  final userDataJson = Map<String, dynamic>.from(userData);
  sharedPrefs.setString(email, jsonEncode(userDataJson));
}

Future<Map<String, dynamic>> getUserDataFromSharedPrefs(String email) async {
  final sharedPrefs = await SharedPreferences.getInstance();
  final userDataJson = sharedPrefs.getString(email);

  if (userDataJson != null) {
    final userData = jsonDecode(userDataJson) as Map<String, dynamic>;
    return userData;
  }
  return {};
}

Future<void> deleteUserDataFromSharedPrefs(String email) async{
  final sharedPrefs = await SharedPreferences.getInstance();
  List<String> existingList = sharedPrefs.getStringList(email) ?? [];
  existingList.removeWhere((key) => key == email);
}
