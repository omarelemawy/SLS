
import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{
  static  SharedPreferences? sharedPreferences;

  static init() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }
 static Future<bool>  putBool(
  {
    required String key,
    required bool value
  })async
  {
     return await sharedPreferences!.setBool(key, value);
  }
  static dynamic getData({required String key})
  {
    return sharedPreferences!.get(key);
  }

  static Future  setString({required String key, required String value})async
  {
     await sharedPreferences!.setString(key, value);
  }
  static String? getString({required String key})
  {
    return sharedPreferences!.getString(key);
  }
  static Future  setInt({required String key, required int value})async
  {
    await sharedPreferences!.setInt(key, value);
  }
  static int? getInt({required String key})
  {
    return sharedPreferences!.getInt(key);
  }
  static Future<bool> saveData({
    required  String key,
    required  dynamic value
  })async
  {
     if(value is String) return await sharedPreferences!.setString(key, value);
     if(value is bool) return await sharedPreferences!.setBool(key, value);
     if(value is int) return await sharedPreferences!.setInt(key, value);
     return await sharedPreferences!.setDouble(key, value);
  }

  static Future<bool>  removeData(
      {
        required String key,
      })async
  {
    return await sharedPreferences!.remove(key);
  }

}