import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
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
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }
  void getCurrentUser() {

    try{
      final user=_auth.currentUser;
      if(user!=null){
        signInUser=user;
      }

    }catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#191919"),
      bottomNavigationBar: Container(
          padding: MediaQuery.of(context).viewInsets,
          color: HexColor("#191919"),
          child: Row(
            children: [
              Expanded(flex: 1,
                  child: Icon(Icons.emoji_emotions_outlined,color: Colors.blue,size: 40,)),
              SizedBox(width: 15,),
              Expanded(
                flex: 7,
                child: TextField(
                  controller: messageController,
                  onChanged: (text){
                    messageText=text;
                  },
                  style: TextStyle(color: Colors.grey[200]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'write comment',
                    labelStyle: TextStyle(color: Colors.grey[400]),
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
                child: Icon(CupertinoIcons.photo_on_rectangle,color: Colors.blue,),
              ),
              SizedBox(width: 15,),
              InkWell(
                onTap: (){
                  setState(() {});
                  messageController.clear();
                  _fireStore.collection("messages").doc(signInUser.uid).set({
                    "text":messageText,
                    "sender": {
                      "image":signInUser.photoURL,
                      "name":signInUser.displayName
                    },
                  });
                },
                child: Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(color: Colors.blue,shape: BoxShape.circle),
                    child: Icon(Icons.arrow_forward,color: Colors.white,),
                  ),
                ),
              ),
              SizedBox(width: 10,),
            ],
          )
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _fireStore.collection("messages").doc(signInUser.uid).snapshots(),
        builder: (context,snapshot){
          List<MessageCard>? messageWidgets=[];
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          var messages = snapshot.data!.get("");
          for(var message in messages){
           final messageText= message.get("text");
           final messageSender= message.get("sender")["name"];
           final messageImage= message.get("sender")["image"];
           print(messageSender);
           messageWidgets.add(MessageCard(
             messageText,messageSender,messageImage
           ));
          }
          return Column(
            children: [
              const SizedBox(height: 30,),
              Row(
                children: [
                  const SizedBox(width: 20,),
                  InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios,color: Colors.pinkAccent,)),
                  const SizedBox(width: 20,),
                  InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()), (
                                route) => false);
                      },
                      child: const Icon(Icons.home_outlined,
                          color: Colors.grey, size: 35)),

                  const Spacer(),
                  InkWell(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MessagesScreen()));
                      } ,
                      child: const Icon(Icons.chat_outlined,color: Colors.grey,size: 35,)),
                  const SizedBox(width: 20,),
                  InkWell(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>NotificationScreen()));
                      },
                      child: const Icon(Icons.notifications_none,color: Colors.grey,size: 35,)),
                  const SizedBox(width: 10,),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const AccountScreen()));
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
                          child: Image.network(
                             signInUser.photoURL!
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
                  SizedBox(width: 20,),
                  Text("Online",style: TextStyle(color: Colors.green),)
                ],
              ),
              const SizedBox(height: 10,),
              Container(height: .5,width: MediaQuery.of(context).size.width,color: Colors.grey,),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListView(
                    children: messageWidgets,
                  ),
                ),
              )
            ],
          );
        },

      ),
    );
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
          Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(color: Colors.pink[200],borderRadius: BorderRadius.circular(5)),
              child: ExpandableText(
                widget.text!,
                expandText: 'show more',
                collapseText: 'show less',
                maxLines: 1,
                linkColor: Colors.blue,
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
              Text("10:29 pm",style: TextStyle(color: Colors.grey[400]),)
            ],
          ),
          const SizedBox(width: 10,),


        ],
      ),
    );
  }
}
