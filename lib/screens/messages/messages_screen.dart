import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:sls/screens/chat/chat_screen.dart';
import 'package:sls/screens/searchpage.dart';
import '../../model/user_model.dart';
import '../../providers/user_provider.dart';
import '../../shared/netWork/local/cache_helper.dart';
import '../account/account_screen.dart';
import '../chat/chatt.dart';
import '../home/home_screen.dart';
import '../notification/notification_screen.dart';
import '../widget/custom_text.dart';

class MessagesScreen extends StatefulWidget {
//  String  name,id,photo;
 UserModel? user;

   MessagesScreen({this.user}) ;

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late User signInUser;
  final _auth = FirebaseAuth.instance;

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
  @override
  void initState() {

    super.initState();
    getCurrentUser();
  }
  //final Stream<QuerySnapshot> _chatStream = FirebaseFirestore.instance.collection("chatChannels").doc().collection('messages').where("",isEqualTo: signInUser.uid).orderBy("time",descending: true).snapshots();
  List<String>messagename = [];
  List<String>messagephoto = [];
  List<String>notificationdata = [];



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: HexColor("#f7b6b8"),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("chatChannels").doc().collection('messages').where("userIds",arrayContains:user.user.uId).orderBy("time",descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data?.docs.length == 0) {
              return Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(10),
                color: HexColor("#f7b6b8"),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "you have no any any messages",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 1.5,
                      child: Center(
                        child: Text(
                          "Nothing here",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5),
              child: Stack(
                  children: [
                    Column(children: [ const SizedBox(
                      height: 30,
                    ),
                      Row(
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
                                        builder: (context) => HomeScreen()),
                                        (route) => false);
                              },
                              child: const Icon(Icons.home_outlined,
                                  color: Colors.white, size: 35)),
                          const SizedBox(
                            width: 20,
                          ),
                          IconButton(
                              onPressed: () =>
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => MySearchPage())),
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 35,
                              )),
                          const Spacer(),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MessagesScreen()));
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
                                      builder: (context) => AccountScreen()));
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
                                    child: Image.network(user.user.photo ?? " ",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Notifications",
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "you have ${snapshot.data!.docs.length}  messages",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),

                          InkWell(onTap: () {
                            setState(() {
                              notificationdata.clear();
                              messagephoto.clear();
                              messagename.clear();
                            });
                          }, child: CustomText(text: "Clean All", color: Colors
                              .blue[700], fontWeight: FontWeight.bold,))
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],),
                    Padding(
                      padding: const EdgeInsets.only(top: 130.0),
                      child: ListView.separated(
                        itemCount: snapshot.data!.docs.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          messagename.add(snapshot.data
                              .docs[index]["senderInfoo"]["userName"]);
                          messagephoto.add(snapshot.data
                              .docs[index]["senderInfoo"]["userImg"]);
                          notificationdata.add(
                              snapshot.data.docs[index]["data"]);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(child: Image.network(
                                    messagephoto[index]),
                                  radius: 35,
                                  backgroundColor: Colors.grey[300],),
                                SizedBox(width: 10,),
                                Column(children: [
                                  CustomText(text: messagename[index],
                                    fontWeight: FontWeight.bold,
                                    font: 20,),
                                  SizedBox(height: 5,),
                                  CustomText(text: notificationdata[index],
                                    font: 18,
                                    color: Colors.white70,),
                                ],)
                              ],
                            ),
                          );
                        }, separatorBuilder: (BuildContext context, int index) {
                        return Container(width: double.infinity,
                          height: 1,
                          color: Colors.grey[300],);
                      },),
                    ),
                  ]
              ),
            );
          }),
    );
  }


  Widget messagesCard(String namee, String photo, String email) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 10,),
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,

              ),
              child: Image.network(photo
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
        const SizedBox(width: 30,),
        Text(namee, style: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
        const Spacer(),
        Column(
          children: [
            Text("Jun 20,2022",
              style: TextStyle(color: Colors.white, fontSize: 14),),
            Text(email, style: TextStyle(color: Colors.white, fontSize: 12),),
          ],
        ),
        const SizedBox(width: 10,),
      ],
    );
  }
}