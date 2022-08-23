import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../contance.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: postColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon:Icon(Icons.close,color: Colors.blue[700],)),
              ],
            ),
            SizedBox(height: 10,),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 160.0,
                  height: 160.0,
                 clipBehavior: Clip.antiAliasWithSaveLayer,
                 decoration:  BoxDecoration(
                   color: const Color(0xff7c94b6),
                   image:  DecorationImage(
                     image:  NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
                         ),
                     fit: BoxFit.cover,
                   ),
                   shape: BoxShape.circle,
                   border: Border.all(
                     color: Colors.blue[900]!,
                     width: 1.5,
                   ),
                 ),
                 ),
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[900]
                  ),
                  child: Icon(Icons.arrow_upward_rounded,color: Colors.grey[200],),
                )
              ],
            ),


            SizedBox(height: 20,),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "*Required";
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.grey[400]) ,
                      keyboardType: TextInputType.emailAddress,
                      decoration:  InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 18.0,horizontal: 10),
                          label:  Text("Username",style: TextStyle(color:  Colors.white),),
                          ),

                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "*Required";
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.white) ,
                      keyboardType: TextInputType.emailAddress,
                      decoration:  InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 18.0,horizontal: 10),
                        label:  Text("FullName",style: TextStyle(color:  Colors.white),),
                      ),

                    ),

                    SizedBox(height: 20,),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "*Required";
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.white) ,
                      keyboardType: TextInputType.emailAddress,
                      decoration:  InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 18.0,horizontal: 10),
                        label:  Text("Email",style: TextStyle(color:  Colors.white),),
                      ),

                    ),

                    SizedBox(height: 20,),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "*Required";
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.white) ,
                      keyboardType: TextInputType.emailAddress,
                      decoration:  InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 18.0,horizontal: 10),
                        label:  Text("Phone Number",style: TextStyle(color:  Colors.white),),
                      ),

                    ),

                    SizedBox(height: 20,),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "*Required";
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.white) ,
                      keyboardType: TextInputType.emailAddress,
                      decoration:  InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 18.0,horizontal: 10),
                        label:  Text("Date of birth",style: TextStyle(color:  Colors.white),),
                      ),

                    ),

                    SizedBox(height: 20,),
                    Text("Change your password!",style: TextStyle(color: Colors.blue[900]),),
                    SizedBox(height: 40,),
                  ],
                ),
              ),
            ),
          ],

        ),
      ),
    );
  }
}
