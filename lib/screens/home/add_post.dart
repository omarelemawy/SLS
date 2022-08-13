import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:sls/screens/home/home_Screen.dart';

import '../widget/custom_button.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        dialog();
        return dialog();
      },
      child: Scaffold(
        backgroundColor: HexColor("#191919"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 35,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width/3,),
                  Center(
                    child: Text("Write A Post",style: TextStyle(
                      color: Colors.indigo[700],fontWeight: FontWeight.bold,fontSize: 20
                    ),),
                  ),
                  Spacer(),
                  IconButton(onPressed: (){
                    dialog();
                  }, icon: Icon(Icons.close,color: Colors.indigo,))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(width: 20,),
                    Text("Write something",style:
                    TextStyle(color: Colors.indigo[900],
                      fontSize: 18,

                    ),),
                    SizedBox(width: 20,),
                    Spacer(),
                    CustomButton(
                          () {
                         },
                      color: HexColor("#3593FF"),
                      height: 40,
                      width: 100,
                      radius: 15,
                      text: "PUBLISH",
                      textColor: Colors.white,
                    ),
                    SizedBox(width: 20,),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.indigo[200],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                child: TextFormField(
                  style: TextStyle(color: Colors.grey[200]),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "*Required";
                    }
                    return null;
                  },
                  decoration:  InputDecoration(
                      label:  Text("Write something here..",style: TextStyle(color: Colors.grey),),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue,width: 1.5),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 30)
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 10,),
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "*Required";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.grey[200]),
                      decoration:  InputDecoration(
                          label:  Text("Quantity",style: TextStyle(color: Colors.grey),),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.pinkAccent,width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.pinkAccent,width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 30)
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      style: TextStyle(color: Colors.grey[200]),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "*Required";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration:  InputDecoration(
                          hintText:  "0",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.pinkAccent,width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.pinkAccent,width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          suffixIcon: Icon(CupertinoIcons.money_euro,color: Colors.pinkAccent,)
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Icon(Icons.local_offer_outlined,color: Colors.blue,size: 30,),
                  SizedBox(width: 5,),
                  Icon(Icons.emoji_emotions_outlined,color: Colors.blue,size: 30,),
                  SizedBox(width: 5,),
                  Icon(CupertinoIcons.photo_on_rectangle,color: Colors.blue,),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
  Future<bool> dialog()async{

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: HexColor("#323232"),
          title:Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close,color: Colors.indigo,),
              ),
            ],
          ) ,
          content: Container(
            height: 80,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text("Are you sure you want discard this post",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),),
              ],
            ),
          ),
          contentPadding: EdgeInsets.all(10),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween
              ,children: [
              SizedBox(width: 10,),
              CustomButton(
                    () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()),
                          (route) => false);
                },
                color: HexColor("#3593FF"),
                height: 50,
                text: "Yes",
                textColor: Colors.white,
                width: 100,
              ),
              SizedBox(width: 10,),
              CustomButton(
                    () {
                      Navigator.pop(context);
                },
                color: Colors.red,
                height: 50,
                text: "No",
                textColor: Colors.white,
                width: 100,
              ),
              SizedBox(width: 10,),
            ],
            ),
            SizedBox(height:20,)
          ],
        );
      },
    );
    return await true;
  }
}