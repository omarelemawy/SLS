import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../model/user_model.dart';
import '../account/account_screen.dart';
import '../home/home_Screen.dart';
import '../messages/messages_screen.dart';
import '../notification/notification_screen.dart';

class Chat extends StatefulWidget {
  static String id = "chat";
  // UserModel userr;
  // Chat({required this.userr});
  @override
  State<StatefulWidget> createState() => Myapp();
}

class Myapp extends State<Chat> {
  User? loggeruser;
  String collectionname = 'messages';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? messagetext;
  final _auth = FirebaseAuth.instance;
  bool spinner = false;
  final textfield = TextEditingController();

  void clear() {
    textfield.clear();
  }

  @override
  void initState() {
    super.initState();
    // loggeruser=User();
  }
  String  messageemail="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#f7b6b8"),
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.pinkAccent,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  HomeScreen()),
                                (route) => false);
                          },
                          child: const Icon(Icons.home_outlined,
                              color: Colors.white, size: 35)),
                      const Spacer(),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MessagesScreen()));
                          },
                          child: const Icon(
                            Icons.chat_outlined,
                            color: Colors.white,
                            size: 35,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationScreen()));
                          },
                          child: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 35,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  AccountScreen()));
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
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
                                  errorBuilder: (c, d, s) {
                                    return Container(
                                      height: 20,
                                      width: 20,
                                    );
                                  },
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                height: 7,
                                width: 7,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: firestore
                        .collection("messages")
                        .orderBy("time")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        spinner = true;
                      }
                      spinner = false;
                      const SizedBox(
                        height: 30,
                      );

                      List<Material> addmessage = [];
                      final mess = snapshot.data?.docs;
                      for (var message in mess??[]) {
                        final messagetext = message.get('message');
                         messageemail = message.get('email');
                        final usermail = loggeruser?.email;
                        // final widgett=message( messtext: messageemail) ;
                        //Text('$messageemail',style: TextStyle(color: Colors.blue,fontSize: 15));
                        if (messageemail == usermail) {
                          Material sendermail = Material(
                            child: Text('$messageemail',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15)),
                          );
                          Material sender = Material(
                            elevation: 10,
                            shadowColor: Colors.grey,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            color: Colors.pinkAccent,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 20),
                                child: Text('$messagetext',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 25)),
                              ),
                            ),
                          );
                          addmessage.add(sender);
                        }
                        Material tt = Material(
                          color: HexColor("#f7b6b8"),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$messageemail',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15)),
                          ),
                        );
                        Material tt2 = Material(
                          elevation: 10,
                          shadowColor: Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          color: Colors.white70,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20),
                            child: Text('$messagetext',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 25)),
                          ),
                        );
                        addmessage.add(tt);
                        addmessage.add(tt2);
                      }

                      return Expanded(
                        flex: 9,
                        child: ListView(
                          key: UniqueKey(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          children: addmessage,
                        ),
                      );
                    }),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              messagetext = value;
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                hintText: "write your message",
                                border: InputBorder.none),
                            controller: textfield,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            firestore.collection(collectionname).add({
                              'message': messagetext,
                              'email': _auth.currentUser?.email,
                              'time': FieldValue.serverTimestamp()
                            });
                            print("**************************");
                            print(_auth.currentUser?.email);
                            clear();
                          },
                          child: Text(
                            "Send",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getmessage() async {
    //ديه طريقهfuture
    /*  var snapshot=await firestore.collection(collectionname).get();
    for(var message in snapshot.docs)
      {
      print("+++++++++++++++++");
      print(message);
      }*/

    //ديه طريقه stream
    var snapshotss = await firestore.collection(collectionname).snapshots();
    //كل docs جوهcollection
    await for (var snap in snapshotss) {
      //كل عنصر جوهdocs
      for (var s in snap.docs) {
        var dd = s.data();
        print("---------------------------------");
        for (var item in dd.keys) {
          print("---------------------------------");
          print(item);
        }
      }
    }
  }
}

// class message extends StatelessWidget {
//   final String messtext;
//   message({required this.messtext});
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//         color: Colors.blue,
//         child: Text('$messtext',
//             style: TextStyle(color: Colors.white, fontSize: 15)));
//   }
// }
