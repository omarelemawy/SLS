import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sls/screens/comment/comment_screen.dart';

import '../../contance.dart';
import '../user_profile/user_profile_screen.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final _fireStore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: HexColor("#f7b6b8"),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:  Column(
              children: [
                Row(
                  children: [

                    InkWell(
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context)=>const UserProfileScreen()));
                        },
                        child: Row(
                          children: [
                             CircleAvatar(
                              child: /*Image.network("")*/
                              Text("N",style: TextStyle(color: Colors.white),),
                              backgroundColor: Colors.deepOrange,
                              radius: 20,
                            ),

                             const SizedBox(width: 10,),
                             Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nacer Bounfws",style:
                                TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),
                                const SizedBox(height: 2,),
                                 Text("2 days ago",style:
                                 TextStyle(color: Colors.grey[900],fontSize: 12),),
                              ],
                            ),

                          ],
                        )),

                    const SizedBox(width: 60),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical:6,horizontal:30),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue[900]!,width: 1.5),
                        borderRadius: BorderRadius.circular(20),

                      ),
                      child: Text(
                        "Follow",
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 14,
                            fontWeight:FontWeight.w500
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                       onTap: (){
                         showDialogOfPost(context);
                       },
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.more_vert,color: Colors.blue[900],),
                    ))
                  ],
                ),
                const SizedBox(height: 20,),
                 Text("Text messages are used for personal, family, business and social purposes. Governmental and no"
                    "n-governmental organizations use text messaging for communication",style: TextStyle(color:Colors.black),),
                const SizedBox(height: 20,),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 1,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/profile_icons/like.svg",
                      semanticsLabel: 'Acme Logo',
                      color: Colors.white,
                      width: 28,
                      height: 28,
                    ),
                    const SizedBox(width: 10,),
                    Text("2",style: TextStyle(color: Colors.white),),
                    const SizedBox(width: 80,),
                    Container(
                      width: 1,
                      height:30,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 80,),
                    InkWell(
                      onTap: (){
                        showModalBottomSheet(
                            context: context,
                            useRootNavigator: true,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top:  Radius.circular(20),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            builder: (context) {
                              return Container(
                                  color: postColor,
                                  height: MediaQuery.of(context).size.height-30,
                                  padding: EdgeInsets.all(10),
                                  child: CommentScreen());
                            });

                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/comment.svg",
                            semanticsLabel: 'Acme Logo',
                            color: Colors.black,
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(width: 10,),
                          Text("3",style: TextStyle(color: Colors.black),),
                        ],
                      ),
                    ),

                  ],
                )
              ],
            )
      ),
    );
  }
}
Future showDialogOfPost(context){
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder:(context){
        return AlertDialog(
            backgroundColor:  postColor,
            shape: const RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(const Radius.circular(20.0))),
            content:  Container(
              width: 260.0,
              height: MediaQuery.of(context).size.height/1.7,
              decoration:  BoxDecoration(
                color: postColor,
                shape: BoxShape.rectangle,
                borderRadius:  BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end
                    ,children: [
                    InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        }
                        ,  child: Icon(Icons.close,color:Colors.blue[900],))
                  ],
                  ),
                  const SizedBox(height: 15,),
                  Text("Report this post",style: TextStyle(color: Colors.blue[900]),),
                  const SizedBox(height: 25,),
                  Text("Hide this post",style: TextStyle(color: Colors.blue[900]),),
                  const SizedBox(height: 25,),
                  Text("Delete this post",style: TextStyle(color: Colors.blue[900]),),
                  const SizedBox(height: 25,),
                  Text("Edit post",style: TextStyle(color: Colors.blue[900]),),
                  const SizedBox(height: 20,),


                  Row(
                    children: [
                      Text("Allow post notifications",style: TextStyle(color: Colors.blue[900]),),
                      const Spacer(),
                      Switch(value: true, onChanged: (value){

                      },activeColor: Colors.blue[900],)
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Text("Allow live notifications",style: TextStyle(color: Colors.blue[900]),),
                      const Spacer(),
                      Switch(value: true, onChanged: (value){

                      },activeColor: Colors.blue[900],)
                    ],
                  ),
                  const SizedBox(height: 20,),
                ],

              ),
            )
        );
      }
  );
}