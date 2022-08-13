import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sls/firebase_options.dart';
import 'package:sls/screens/auth/first_screen.dart';
import 'package:sls/screens/home/home_Screen.dart';
import 'package:sls/shared/netWork/local/cache_helper.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Widget? widget;
  await CacheHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var uId =CacheHelper.getData(key: "uId");
  print(uId.toString()+"ffff");
  if(uId ==null||uId==""){
    widget=const FirstScreen();
    }else{
    widget= HomeScreen();
  }
  runApp( MyApp(startwidget:widget ,));
}

class MyApp extends StatelessWidget {

  Widget? startwidget;
  MyApp({Key? key,this.startwidget}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'We Work',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: startwidget,
    );
  }
}
