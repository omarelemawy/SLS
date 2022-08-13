
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class MyTheme {
 static ThemeData themeLight() =>
      ThemeData(
        primarySwatch: Colors.indigo,
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark,
            ),
            iconTheme: IconThemeData(
                color: Colors.black
            ),
            color: Colors.white,
            elevation: 0.0,
            titleTextStyle: TextStyle(color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold)
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
          bodyText1: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
          bodyText2: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          subtitle1: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        bottomNavigationBarTheme: const
        BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.indigo,
            elevation: 20,
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.grey
        ),
      );

 static ThemeData themeDark() =>
      ThemeData(
          primarySwatch: Colors.indigo,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.grey.withOpacity(.1),
          appBarTheme: AppBarTheme(
              backwardsCompatibility: false,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.black54,
                statusBarIconBrightness: Brightness.light,
              ),
              color: Colors.grey.withOpacity(.1),
              elevation: 0.0,
              iconTheme: const IconThemeData(
                  color: Colors.white
              ),
              titleTextStyle: const TextStyle(color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)
          ),
          bottomNavigationBarTheme:
          BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.indigo,
              elevation: 20,
              backgroundColor: Colors.grey.withOpacity(.1),
              unselectedItemColor: Colors.grey
          ),
          textTheme: const TextTheme(
            bodyText1: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            bodyText2: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            subtitle1: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          iconTheme: const
          IconThemeData(
              color: Colors.white, opacity: 1
          )
      );
}