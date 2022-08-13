
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../netWork/local/cache_helper.dart';

/*void signOut(context){
  FirebaseAuth.instance.signOut();
  CacheHelper.removeData(key: "uId").then((value) {
    pushAndRemove(context,LoginScreen());
  }
  );
}*/

void pushAndRemove(context,widget)
{
  Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:
      (context)=>widget), (route) => false);
}
void push(context,widget){
  Navigator.push(context,MaterialPageRoute(builder:
      (context)=>widget));
}

var uId;