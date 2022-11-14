import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setvideo(File value) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('video', value.toString());
}
Future<String> getvideo() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? value = prefs.getString("video");
  if(value != null){
    return value;
  }
  return "There is no video saved!";
}
