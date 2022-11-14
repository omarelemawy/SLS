import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:sls/screens/chat/chat.dart';
import '../../model/user_model.dart';
import '../../shared/netWork/local/cache_helper.dart';
import '../account/account_screen.dart';
import '../home/home_Screen.dart';
import '../messages/messages_screen.dart';
import '../notification/notification_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _fireStore=FirebaseFirestore.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;
  TextEditingController messageController=TextEditingController();
  final _auth=FirebaseAuth.instance;
  late User signInUser;
  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
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
  Future<UserModel> readUser() async {
    final docUser = FirebaseFirestore.instance.collection("Users").doc(
        signInUser.uid);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return UserModel.fromJson(snapshot.data());
    } else {
      return UserModel(name: '');
    }
  }
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    void moveChat() {
      Future.delayed(Duration(milliseconds: 2), () {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
      });
    }
    return Scaffold(
        backgroundColor: HexColor("#f7b6b8"),
        bottomNavigationBar: Container(
            padding: MediaQuery
                .of(context)
                .viewInsets,
            color: HexColor("#f7b6b8"),
            child: Row(
              children: [
                Expanded(flex: 1,
                    child: Icon(
                      Icons.emoji_emotions_outlined, color: Colors.blue,
                      size: 40,)),
                SizedBox(width: 15,),
                Expanded(
                  flex: 7,
                  child: TextField(
                    controller: messageController,
                    onChanged: (text) {
                      messageText = text;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'write comment',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey[200]!)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.blue[500]!)
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15,),
                Expanded(
                  flex: 1,
                  child: Icon(
                    CupertinoIcons.photo_on_rectangle, color: Colors.blue,),
                ),
                SizedBox(width: 15,),
                InkWell(
                  onTap: () async {
                    setState(() {});

                    /*_fireStore.collection("messages").doc(signInUser.uid).set({
                    "text":messageText,
                    "sender": {
                      "image":signInUser.photoURL,
                      "name":signInUser.displayName
                    },
                  });*/
                    if (messageController.text.isNotEmpty) {
                      Message msg = Message(
                          user: signInUser.uid,
                          message: messageController.text,
                          /* time: Timestamp.now().toString(),*/
                          seen: false);
                      //chatBloc.sendMessage(msg, _scrollController);
                      messageController.clear();
                      await sendMessage(chatRoomId: 1, message: msg);
                      moveChat();
                    }
                    messageController.clear();
                  },
                  child: Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: Icon(Icons.arrow_forward, color: Colors.white,),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
              ],
            )
        ),
        body: FutureBuilder<UserModel?>(
            future: readUser(),
            builder: (context, AsyncSnapshot<UserModel?> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    const SizedBox(height: 30,),
                    Row(
                      children: [
                        const SizedBox(width: 20,),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios, color: Colors.pinkAccent,)),
                        const SizedBox(width: 20,),
                        InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (
                                      context) =>  HomeScreen()), (
                                      route) => false);
                            },
                            child: const Icon(Icons.home_outlined,
                                color: Colors.white, size: 35)),

                        const Spacer(),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (
                                  context) => MessagesScreen()));
                            },
                            child: const Icon(
                              Icons.chat_outlined, color: Colors.white,
                              size: 35,)),
                        const SizedBox(width: 20,),
                        InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      NotificationScreen()));
                            },
                            child: const Icon(
                              Icons.notifications_none, color: Colors.white,
                              size: 35,)),
                        const SizedBox(width: 10,),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (
                                    context) =>  AccountScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,

                                  ),
                                  child: Image.network(
                                    "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png"
                                    , errorBuilder: (c, d, s) {
                                    return Container(
                                      height: 20,
                                      width: 20,
                                    );
                                  },
                                    height: 40, width: 40, fit: BoxFit.fill,),
                                ),
                                Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  height: 7,
                                  width: 7,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20,),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child:Image.network(
                                  snapshot.data!.photo!
                                  , errorBuilder: (c, d, s) {
                                  return Container(
                                    height: 20,
                                    width: 20,
                                  );
                                },
                                  height: 40, width: 40, fit: BoxFit.fill,)
                                    ,
                              ),
                              Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                height: 7,
                                width: 7,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20,),
                        Text("Online", style: TextStyle(color: Colors.green),)
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Container(height: .5, width: MediaQuery
                        .of(context)
                        .size
                        .width, color: Colors.grey,),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return MessageCard(
                              "omascjocsncshcvnsidvhnsdvhnsivh nsidodvh nsdiv nvdn oivdsn oivnds oivdn oivsdn oivnds oircbcsvbfvbfvsfjlvbsfvblsbdvfsdvbsduvbsdiuvbsddviubsddviubsddiucbi",
                              "omar",
                              "https://miro.medium.com/max/775/0*rZecOAy_WVr16810",
                            );
                          },
                        ),
                      ),
                    )
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            }
        )    );
  }

  void messagesStream()async{
  await for (var snapshot in _fireStore.collection("messages").snapshots())
   {
     for(var message in snapshot.docs){

     }

   }
  }

}

class MessageCard extends StatefulWidget {
   MessageCard(this.text,this.name,this.image,{Key? key}) : super(key: key);
  String? text;
  String? name;
  String? image;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(

                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.pink[200],borderRadius: BorderRadius.circular(5)),
                child: Text(
                  widget.text!,
                ),
            ),
          ),
          const SizedBox(width: 10,),
          Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,

                    ),
                    child: Image.network(
                      widget.image!
                      , errorBuilder: (c, d, s) {
                      return Container(
                        height: 20,
                        width: 20,
                      );
                    },
                      height: 40, width: 40, fit: BoxFit.fill,),
                  ),
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: 7,
                    width: 7,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              Text("10:29 pm",style: TextStyle(color: Colors.white),)
            ],
          ),
          const SizedBox(width: 10,),


        ],
      ),
    );
  }
}
