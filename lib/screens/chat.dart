import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:sls/model/user_model.dart';
import 'package:sls/screens/widget/message_textfield.dart';
import 'package:sls/screens/widget/single_message.dart';

class Chatscreen extends StatefulWidget {
  String friendid;
  String friendname;
  String friendimage;
  UserModel user;

  Chatscreen(
      {
        required this.user,
        required this.friendid,
      required this.friendimage,
      required this.friendname,});

  @override
  State<StatefulWidget> createState() => chatscreenstate();
}

class chatscreenstate extends State<Chatscreen> {
  @override
  Widget build(BuildContext context) {
  Timestamp chattime;
     return Scaffold(
      backgroundColor: HexColor("#f7b6b8"),
      appBar: AppBar(
        backgroundColor: HexColor("#f7b6b8"),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child:  CachedNetworkImage(
                imageUrl:widget.friendimage,
                placeholder: (conteext,url)=>CircularProgressIndicator(),
                errorWidget: (context,url,error)=>Icon(Icons.error,),
                height: 40,
              ),
            ),
            SizedBox(width: 5,),
            Text(widget.friendname,style: TextStyle(fontSize: 20),)
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color:HexColor("#f7b6b8"),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)
                )
            ),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Users").doc(widget.user.uId).collection('messages').doc(widget.friendid).collection('chats').orderBy("date",descending: true).snapshots(),
                builder: (context,AsyncSnapshot snapshot){
                  if(snapshot.hasData){

                    if(snapshot.data.docs.length < 1){
                      return Center(
                        child: Text("Say Hi"),
                      );
                    }

                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context,index){
                          chattime=snapshot.data.docs[index]['date'];
                         bool  isMe= snapshot.data.docs[index]['senderId'] == signInUser.uid;
                          return SingleMessage(message: snapshot.data.docs[index]['message'], isMe: isMe,chattime:chattime);
                        });
                  }
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }),
          )),
          MessageTextField(widget.user.uId??" ", widget.friendid),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  final _auth = FirebaseAuth.instance;
  late User signInUser;
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      user?.reload();
      if (user != null) {
        signInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
}
