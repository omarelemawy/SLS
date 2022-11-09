import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:sls/screens/shippingaddress/shippingaddressscreen.dart';

import '../../model/user_model.dart';
import '../auth/register_screen.dart';
import '../home/home_Screen.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text.dart';

class Waitingscreen extends StatefulWidget {
  // UserModel usermodel;
  // Waitingscreen({required this.usermodel});
  @override
  State<StatefulWidget> createState() => Waitingscreenstate();
}

class Waitingscreenstate extends State<Waitingscreen> {
  bool isverify=false;
  @override
  Widget build(BuildContext context) {

      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (BuildContext context) => Shippingaddress()));

    final Stream<QuerySnapshot> _postStream =
        FirebaseFirestore.instance.collection('Users').snapshots();
    return Scaffold(

      body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   "SLS ",
                          //   style: TextStyle(
                          //       color: HexColor("#f7b6b8"),
                          //       fontSize: 40,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          CustomText(text:"SLS ",color:HexColor("#f7b6b8"),font:40,fontWeight: FontWeight.bold,),


                          // Text(
                          //   "Livestream",
                          //   style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 40,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          CustomText(text:"Livestream",color:Colors.black,font:40,fontWeight: FontWeight.bold,),
                          

                        ],
                      ),
                      // Text(
                      //   "Something different,new , this our app.",
                      //   style:
                      //       TextStyle(color: HexColor("#f7b6b8"), fontSize: 15),
                      // ),

                      CustomText(text:"Something different,new , this our app.",color:HexColor("#f7b6b8"),font:15,),

                      SizedBox(
                        height: 80,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 25,
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Text(
                      //   "Thank you for your registiration. ",
                      //   style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      CustomText(text:"Thank you for your registiration. ",color:Colors.black,font:20,fontWeight: FontWeight.bold,),

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: 1,
                        color: Colors.grey[400],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                        backgroundColor: HexColor("#f7b6b8"),
                        radius: 25,
                        child: Text(
                          "i",
                          style: TextStyle(color: Colors.white, fontSize: 30,fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Text(
                      //   "Your request is sending to and administrator , once accepted we will send you a confirmation by Email and you can enter in the app ",
                      //   style: TextStyle(
                      //     color: Colors.grey[600],
                      //     fontSize: 18,
                      //    // fontWeight: FontWeight.bold
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      CustomText(text:"Your request is sending to and administrator , once accepted we will send you a confirmation by Email and you can enter in the app",color:Colors.grey[600],font:18),

                      SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        (){
                         // Navigator.of(context).pop(true);
                          if (Platform.isAndroid) {
                            SystemNavigator.pop();
                          } else {
                            exit(0);
                          }
                    //      Navigator.pop(context);
                        },
                        text: "close the App".toUpperCase(),
                        textColor: Colors.white,
                        color: HexColor("#f7b6b8"),
                         height: 50,
                        font: 15,
                        radius: 15,
                        width: double.infinity - 15,
                      )
                    ],
                  ),
                ));
  }

  @override
  void initState() {
    super.initState();
  }
}
