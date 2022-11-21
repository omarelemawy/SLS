import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gallery_saver/files.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:sls/screens/searchpage.dart';
import '../../contance.dart';
import '../../model/media_source.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../model/user_model.dart';
import '../../providers/user_provider.dart';
import '../../shared/netWork/local/cache_helper.dart';
import '../account/account_screen.dart';
import '../chat.dart';
import '../comment/comment_screen.dart';
import '../feeds/feeds_screen.dart';
import '../home/add_post.dart';
import 'package:http/http.dart' as http;
import '../home/home_screen.dart';
import '../messages/messages_screen.dart';
import '../my_cart/my_cart_screen.dart';
import '../notification/notification_screen.dart';
import '../service/localnotificationscreen.dart';
import '../streamcomment/stream_comments.dart';
import '../streams/streams_field.dart';
import '../widget/custom_button.dart';
import '../widget/video_widget.dart';
import '../widget/videonetworkwidget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserProfileScreen extends StatefulWidget {
  String name, id;
  String profileimage;
  UserModel user;
  int followerslen;
  int followinglen;

  UserProfileScreen(
      { this.name = "", this.profileimage = " ", this.id = "", required this.user,this.followerslen=0,this.followinglen=0 });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {


  final _fireStore = FirebaseFirestore.instance;
  List<String>userslist = [];
  List<bool>chatlist = [];
  int index = 0;
  TabController? _tabController;
  User? loggeduser;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      user?.reload();
      if (user != null) {
        loggeduser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void _handleTabSelection() {
    setState(() {});
  }


  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    super.initState();
    storenotifcationtoken();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      print("FCM message received");
    });
    getCurrentUser();

    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_handleTabSelection);
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => NotificationScreen())));
    }
  }

  UserModel? userr;

  Future<UserModel?> readUser() async {
    final docUser = FirebaseFirestore.instance
        .collection("Users")
        .doc(signInUser.uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      userr = UserModel.fromJson(snapshot.data());
      return userr;
    } else {
      return UserModel(name: '');
    }
  }

  storenotifcationtoken() async
  {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection("Users").doc(widget.id).set(
        {"token": token}, SetOptions(merge: true));
  }

  late User signInUser;
  String usrid = "";
  int likecount = 0;
  double size = 25.0;
  bool isliked = false;
  MediaSource? source;
  bool isfollow = false;
  final _auth = FirebaseAuth.instance;
  List<String> followlist = [];
  List<String> likeslist = [];
  late final LocalNotificationService service;

  AddPostState addpostedit = new AddPostState();

  sendNotification(String title, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': 1,
      'status': 'done',
      'message': title
    };
    try {
      http.Response response = await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content_Type': 'application/json',
            'Authorization': 'key=AAAATOwZIh4:APA91bGLnvyJyvi7yVuJgrXJuxFk6t8pUOVtk9ptz4IOyxL8EiNdmsujUINK8iLMhCdOlArPOILSJmFxfSOFq24SIZF8MS2vGKhvhATRskijs3YhKGO7Pf3aA43JAKYJWkaOFXU5fpI5'
          },
          body: jsonEncode(<String, dynamic>{
            'notification': <String, dynamic>{
              'title': title,
              'body': 'you are followed by some one'
            },
            'priority': 'high',
            'data': data,
            'to': '$token',
          })
      );
      if (response.statusCode == 200) {
        print("notification is sended");
      }
      else {
        print("error");
      }
    } catch (e) {}
  }


  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await FirebaseFirestore.instance.collection("chatChannels")
          .doc(docId)
          .get();
      return documentSnapshot.exists;
    }
    catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userperson = Provider.of<UserProvider>(context, listen: false);
    FirebaseFirestore.instance
        .collection("Users")
        .doc()
        .update({"follower": followlist});
    final Stream<QuerySnapshot> _postfeed =
    FirebaseFirestore.instance
        .collection('Post')
        .where("postType", isEqualTo: "TextPostWithShop").where(
        "uid", isEqualTo: widget.id)
        .snapshots();
    final Stream<QuerySnapshot> _poststream =
    FirebaseFirestore.instance
        .collection('Post')
        .where("postType", isEqualTo: "TextPostWithLive").where(
        "uid", isEqualTo: widget.id)
        .snapshots();
    return Scaffold(
      backgroundColor: HexColor("#f7b6b8"),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("#f7b6b8"),
        leading: InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()), (
                      route) => false);
            },
            child: const Icon(Icons.home_outlined,
                color: Colors.white, size: 35)),
        title: IconButton(
            onPressed: () =>
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => MySearchPage())),
            icon: const Icon(Icons.search, color: Colors.white, size: 35,)),
        actions: [
          InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (context) {
                      return Container(
                          color: postColor,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height - 30,
                          padding: EdgeInsets.all(10),
                          child: MyCartScreen());
                    });
              },
              child: const Icon(
                Icons.shopping_cart_rounded, color: Colors.white, size: 35,)),
          const SizedBox(width: 10,),
          InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MessagesScreen()));
              },
              child: const Icon(
                Icons.chat_outlined, color: Colors.white, size: 35,)),
          const SizedBox(width: 10,),
          InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => NotificationScreen()));
              },
              child: const Icon(
                Icons.notifications_none, color: Colors.white, size: 35,)),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AccountScreen()));
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
                    child: Image.network(widget.profileimage
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
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Scaffold(
                backgroundColor: HexColor("#f7b6b8"),
                body: DefaultTabController(
                  length: 2,
                  child: Stack(
                    children: [
                      NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                                delegate: SliverChildListDelegate(
                                    <Widget>[
                                      Container(
                                        color: HexColor("#f7b6b8"),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 15,),
                                            CircleAvatar(
                                              child: Image.network(
                                                  widget.profileimage),
                                              backgroundColor: Colors
                                                  .deepOrange,
                                              radius: 35,
                                            ),
                                            const SizedBox(height: 15,),
                                            Text('${widget.name}', style:
                                            TextStyle(color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),),
                                            const SizedBox(height: 20,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              children: [
                                                const Text("Followers ",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                  ),),
                                                Text("${widget.followerslen}", style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),),
                                                const SizedBox(width: 40,),
                                                Container(
                                                  color: Colors.white,
                                                  width: 1,
                                                  height: 15,
                                                ),
                                                const SizedBox(width: 40,),
                                                const Text("Followings ",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                  ),),
                                                Text("${widget.followinglen}", style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),),
                                              ],
                                            ),
                                            const SizedBox(height: 20,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 30),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .blue[700]!,
                                                        width: 1.5),
                                                    borderRadius: BorderRadius
                                                        .circular(20),

                                                  ),
                                                  child: Text(
                                                    "Follow",
                                                    style: TextStyle(
                                                        color: Colors.blue[700],
                                                        fontSize: 14,
                                                        fontWeight: FontWeight
                                                            .w500
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 20,),
                                                Visibility(
                                                  visible: widget.id != loggeduser?.uid,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      if (widget.id != loggeduser?.uid) {
                                                        DocumentReference doc = FirebaseFirestore.instance
                                                            .collection('chatChannels')
                                                            .doc();
                                                        bool exist = await checkIfDocExists(
                                                            '6UGG5SZqv1AgYl9OGFGf');
                                                        // DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
                                                        // await FirebaseFirestore.instance.collection("chatChannels").doc(doc.id).get();
                                                        if (exist) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (
                                                                      context) =>
                                                                      Chatscreen(

                                                                        friendname: widget
                                                                            .name,
                                                                        friendimage: widget
                                                                            .profileimage,
                                                                        user: userr ??
                                                                            UserModel(),
                                                                        friendid: widget
                                                                            .id,
                                                                        docid: doc
                                                                            .id,
                                                                      )));
                                                          ScaffoldMessenger.of(
                                                              context)
                                                              .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  "document exist",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                duration: const Duration(
                                                                    seconds: 3),
                                                                backgroundColor: Colors
                                                                    .grey,
                                                              ));
                                                        }
                                                        else {
                                                          doc.set({
                                                            "userIds": [
                                                              widget.id,
                                                              userperson.user
                                                                  .uId ?? " "
                                                            ]
                                                          });
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (
                                                                      context) =>
                                                                      Chatscreen(

                                                                        friendname: widget
                                                                            .name,
                                                                        friendimage: widget
                                                                            .profileimage,
                                                                        user: userr ??
                                                                            UserModel(),
                                                                        friendid: widget
                                                                            .id,
                                                                        docid: doc
                                                                            .id,
                                                                      )));
                                                          ScaffoldMessenger.of(
                                                              context)
                                                              .showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  "document doesn't exist",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                duration: const Duration(
                                                                    seconds: 3),
                                                                backgroundColor: Colors
                                                                    .grey,
                                                              ));
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          vertical: 2,
                                                          horizontal: 40),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 1.5),
                                                        borderRadius: BorderRadius
                                                            .circular(20),

                                                      ),
                                                      child: Icon(
                                                        Icons.mail_outline,
                                                        color: Colors.green,
                                                        size: 20,),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])
                            ),
                            SliverAppBar(
                              floating: false,
                              snap: false,
                              pinned: false,
                              stretch: true,
                              expandedHeight: 0,
                              backgroundColor: HexColor("#f7b6b8"),
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(5.0),
                                child: TabBar(
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        "Feeds",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: _tabController!.index == 1
                                                ? Colors.black
                                                : Colors.white),
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        "Streams",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color:
                                        _tabController!.index == 0
                                            ? Colors.black
                                            : Colors.white),
                                      ),
                                    ),
                                  ],
                                  onTap: (index) {
                                    setState(() {});
                                  },
                                  controller: _tabController,
                                  unselectedLabelStyle: TextStyle(
                                      color: Colors.black),
                                  unselectedLabelColor: Colors.black,
                                  labelColor: Colors.black,
                                  indicatorColor: Colors.black,
                                ),
                              ),
                            ),
                          ];
                        },
                        body: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            Center(
                              child: StreamBuilder(
                                  stream: _postfeed,
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    }
                                    return ListView.separated(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (BuildContext context,
                                          int index) {
                                        Timestamp timestamp = snapshot.data!
                                            .docs[index]["time"];
                                        String postid = snapshot.data!
                                            .docs[index].id;
                                        //***************
                                        //https://stackoverflow.com/questions/70205911/flutter-firebase-posts-that-user-like-system
                                        var document = FirebaseFirestore
                                            .instance.collection('Users')
                                            .doc();
                                        document.get().then((documentt) {});
                                        return Material(
                                          elevation: 2,
                                          color: HexColor("#f7b6b8"),
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          child: Padding(
                                              padding: const EdgeInsets.all(
                                                  8.0),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(right: 2.0),
                                                    child: Row(
                                                      children: [
                                                        InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) =>
                                                                          UserProfileScreen(

                                                                              name: snapshot
                                                                                  .data!
                                                                                  .docs[index]
                                                                              ["userName"],
                                                                              profileimage: snapshot
                                                                                  .data
                                                                                  ?.docs[index]
                                                                              ["profile"] ??
                                                                                  "",
                                                                              id: snapshot
                                                                                  .data!
                                                                                  .docs[index]
                                                                              ["uid"],
                                                                              user: widget
                                                                                  .user)));
                                                            },
                                                            child: Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  child: Image
                                                                      .network(
                                                                      snapshot
                                                                          .data
                                                                          ?.docs[index]
                                                                      ["profile"] ??
                                                                          ""),
                                                                  backgroundColor: Colors
                                                                      .deepOrange,
                                                                  radius: 20,
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .start,
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                      snapshot
                                                                          .data!
                                                                          .docs[index]["userName"] ??
                                                                          " ",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize: 14),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 2,
                                                                    ),
                                                                    Text(
                                                                      "${timeago
                                                                          .format(
                                                                          timestamp
                                                                              .toDate())} ",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey[900],
                                                                          fontSize: 12),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                        ),
                                                        const SizedBox(
                                                            width: 60),
                                                        Container(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              vertical: 6,
                                                              horizontal: 30),
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .blue[900]!,
                                                                width: 1.5),
                                                            borderRadius: BorderRadius
                                                                .circular(20),
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                //   buildbuttonfollow();
                                                              });
                                                            },
                                                            child: Text(
                                                              "Unfollow",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue[900],
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight
                                                                      .w500),
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                  context: context,
                                                                  barrierDismissible: false,
                                                                  builder: (
                                                                      context) {
                                                                    return AlertDialog(
                                                                        backgroundColor: postColor,
                                                                        shape: const RoundedRectangleBorder(
                                                                            borderRadius:
                                                                            const BorderRadius
                                                                                .all(
                                                                                const Radius
                                                                                    .circular(
                                                                                    20.0))),
                                                                        content: Container(
                                                                          width: 260.0,
                                                                          height: MediaQuery
                                                                              .of(
                                                                              context)
                                                                              .size
                                                                              .height /
                                                                              1.7,
                                                                          decoration: BoxDecoration(
                                                                            color: postColor,
                                                                            shape: BoxShape
                                                                                .rectangle,
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                30),
                                                                          ),
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .start,
                                                                            crossAxisAlignment: CrossAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment
                                                                                    .end,
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .end,
                                                                                children: [
                                                                                  InkWell(
                                                                                      onTap: () {
                                                                                        Navigator
                                                                                            .pop(
                                                                                            context);
                                                                                      },
                                                                                      child: Icon(
                                                                                        Icons
                                                                                            .close,
                                                                                        color: Colors
                                                                                            .blue[900],
                                                                                      ))
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 15,
                                                                              ),
                                                                              Text(
                                                                                "Report this post",
                                                                                style: TextStyle(
                                                                                    color: Colors
                                                                                        .blue[900]),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 25,
                                                                              ),
                                                                              Text(
                                                                                "Hide this post",
                                                                                style: TextStyle(
                                                                                    color: Colors
                                                                                        .blue[900]),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 25,
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  setState() {
                                                                                    snapshot
                                                                                        .data!
                                                                                        .docs
                                                                                        .removeAt(
                                                                                        index);
                                                                                  }
                                                                                },
                                                                                child: Text(
                                                                                  "Delete this post",
                                                                                  style: TextStyle(
                                                                                      color: Colors
                                                                                          .blue[900]),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 25,
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  addpostedit
                                                                                      .updatedatabase(
                                                                                      context,
                                                                                      postid);
                                                                                },
                                                                                child: Text(
                                                                                  "Edit post",
                                                                                  style: TextStyle(
                                                                                      color: Colors
                                                                                          .blue[900]),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 20,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "Allow post notifications",
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .blue[900]),
                                                                                  ),
                                                                                  const Spacer(),
                                                                                  Switch(
                                                                                    value: true,
                                                                                    onChanged: (
                                                                                        value) {},
                                                                                    activeColor: Colors
                                                                                        .blue[900],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "Allow live notifications",
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .blue[900]),
                                                                                  ),
                                                                                  const Spacer(),
                                                                                  Switch(
                                                                                    value: true,
                                                                                    onChanged: (
                                                                                        value) {},
                                                                                    activeColor: Colors
                                                                                        .blue[900],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 20,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ));
                                                                  });
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                  .all(8.0),
                                                              child: Icon(
                                                                Icons.more_vert,
                                                                color: Colors
                                                                    .blue[900],
                                                              ),
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    snapshot.data!
                                                        .docs[index]["context"]["text"],
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width / 1.2,
                                                      height: 150,
                                                      color: postColor,
                                                      child: source ==
                                                          MediaSource.image
                                                          ? Image.file(
                                                          File(snapshot.data
                                                              ?.docs[index]
                                                          ["context"]["imagepathhh"] ??
                                                              ""))
                                                          : VideoWidget(
                                                          File(snapshot.data
                                                              ?.docs[index]
                                                          ["context"]["imagepathhh"] ??
                                                              ""))),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width / 1.2,
                                                      height: 1,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      LikeButton(
                                                        size: size,
                                                        likeCount: likecount,
                                                        likeBuilder: (isLiked) {
                                                          final color = isliked
                                                              ? Colors.red
                                                              : Colors.grey;
                                                          return Icon(
                                                            Icons.favorite,
                                                            color: color,
                                                            size: size,
                                                          );
                                                        },
                                                        likeCountPadding: EdgeInsets
                                                            .only(left: 12),
                                                        onTap: (isliked) async {
                                                          this.isliked =
                                                          !isliked;
                                                          likecount += this
                                                              .isliked ? 1 : -1;
                                                          return !isliked;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 80,
                                                      ),
                                                      Container(
                                                        width: 1,
                                                        height: 30,
                                                        color: Colors.white,
                                                      ),
                                                      const SizedBox(
                                                        width: 80,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (
                                                                    context) =>

                                                                    StreamCommentScreen(
                                                                        context,
                                                                        streamid: postid,
                                                                        ownerid: signInUser
                                                                            .uid,
                                                                        ownername: signInUser
                                                                            .displayName,
                                                                        ownerimg: signInUser
                                                                            .photoURL),
                                                              ));
                                                        },
                                                        child: Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                              "assets/comment.svg",
                                                              semanticsLabel: 'Acme Logo',
                                                              color: Colors
                                                                  .black,
                                                              width: 30,
                                                              height: 30,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              '${CacheHelper
                                                                  .getInt(
                                                                  key: "commentpost")}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )),
                                        );
                                      },
                                      separatorBuilder: (BuildContext context,
                                          int index) {
                                        return const SizedBox(
                                          height: 10,
                                        );
                                      },
                                    );
                                  }),
                            ),
                            Center(
                              child: StreamBuilder(
                                stream: _poststream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.data?.docs.length == 0) {
                                    return Material(
                                      elevation: 2,
                                      borderRadius: BorderRadius.circular(10),
                                      color: HexColor("#f7b6b8"),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          Icon(Icons.sticky_note_2_outlined,
                                            color: Colors.blue, size: 130,),
                                          SizedBox(height: 5,),
                                          Text("No Posts available now!",
                                              style: TextStyle(
                                                  color: Colors.indigo[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30)),
                                          SizedBox(height: 5,),
                                          Text(
                                            "it seems there no posts right now make sure you are following others to see thier activites",
                                            style: TextStyle(color: Colors.grey,
                                                fontSize: 20),
                                            textAlign: TextAlign.center,),
                                          SizedBox(height: 5,),
                                          CustomButton(() {},
                                            text: "refresh".toUpperCase(),
                                            color: Colors.indigo,
                                            font: 20,
                                            textColor: Colors.white,
                                            width: 150,),
                                        ],
                                      ),
                                    );
                                  }

                                  return ListView.separated(
                                    itemCount: snapshot.data?.docs.length ?? 0,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      String uId = snapshot.data!
                                          .docs[index]["uid"];
                                      // Timestamp timestamp = snapshot.data!
                                      //     .docs[index]["time"];
                                      return Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.circular(10),
                                        color: HexColor("#f7b6b8"),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
                                                                    UserProfileScreen(
                                                                      name: snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      ["userName"],
                                                                      id: snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      ["uid"],
                                                                      user: widget
                                                                          .user,)));
                                                      },
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            child: Image
                                                                .network(
                                                                snapshot.data!
                                                                    .docs[index]["profile"] ??
                                                                    ""),
                                                            backgroundColor: Colors
                                                                .deepOrange,
                                                            radius: 20,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .start,
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                snapshot.data!
                                                                    .docs[index]["userName"],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    fontSize: 14),
                                                              ),
                                                              const SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text("",
                                                                // "${timeago
                                                                //     .format(
                                                                //     timestamp
                                                                //         .toDate())} ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey[800],
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  const SizedBox(width: 60),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 6,
                                                        horizontal: 30),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors
                                                              .blue[900]!,
                                                          width: 1.5),
                                                      borderRadius: BorderRadius
                                                          .circular(20),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() async {
                                                          final userr = Provider
                                                              .of<UserProvider>(
                                                              context,
                                                              listen: false);
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                              "Notifications")
                                                              .doc()
                                                              .set({
                                                            "data": "follow",
                                                            "relatedinfo": {
                                                              "postId": "",
                                                              "orderNo": ''
                                                            },
                                                            "seen": false,
                                                            "topic": "follow",
                                                            "time": "${DateTime
                                                                .now()}",
                                                            "senderInfoo": {
                                                              "userName": userperson
                                                                  .user.name ??
                                                                  " ",
                                                              "uid": userperson
                                                                  .user.uId ??
                                                                  " ",
                                                              "userImg": userperson
                                                                  .user.photo ??
                                                                  " ",
                                                            }
                                                          });
                                                          await service
                                                              .showNotification(
                                                              id: 0,
                                                              title: 'follow ',
                                                              body: '${userperson
                                                                  .user
                                                                  .name} follow you');
                                                          isfollow = !isfollow;
                                                          if (signInUser.uid !=
                                                              snapshot.data
                                                                  ?.docs[index]["uid"]) {
                                                            isfollow
                                                                ? followlist
                                                                .add(
                                                                signInUser.uid)
                                                                : followlist
                                                                .remove(
                                                                signInUser.uid);
                                                            _fireStore
                                                                .collection(
                                                                "Users")
                                                                .doc(
                                                                snapshot.data
                                                                    ?.docs[index]
                                                                ["uid"])
                                                                .update({
                                                              "follower": followlist
                                                            });
                                                            isfollow
                                                                ? followlist
                                                                .add(snapshot
                                                                .data
                                                                ?.docs[index]["uid"])
                                                                : followlist
                                                                .remove(snapshot
                                                                .data
                                                                ?.docs[index]["uid"]);
                                                            _fireStore
                                                                .collection(
                                                                "Users")
                                                                .doc(
                                                                signInUser.uid)
                                                                .update(
                                                                {
                                                                  "following": followlist
                                                                });
                                                          }
                                                        });
                                                      },
                                                      child: isfollow ? Text(
                                                        "Unfollow",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blue[900],
                                                            fontSize: 14,
                                                            fontWeight: FontWeight
                                                                .w500),
                                                      ) : Text(
                                                        "follow",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blue[900],
                                                            fontSize: 14,
                                                            fontWeight: FontWeight
                                                                .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  InkWell(
                                                      onTap: () {
                                                        showDialogOfPost(
                                                            context,
                                                            snapshot.data!
                                                                .docs[index]["uid"],
                                                            signInUser.uid);
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .all(8.0),
                                                        child: Icon(
                                                          Icons.more_vert,
                                                          color: Colors
                                                              .blue[900],
                                                        ),
                                                      ))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .center,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 3,
                                                    height: 1,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    "was Live",
                                                    style: TextStyle(
                                                        color: Colors.red[900],
                                                        fontSize: 12,
                                                        fontWeight: FontWeight
                                                            .bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  Container(
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 3,
                                                    height: 1,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 350,
                                                clipBehavior: Clip
                                                    .antiAliasWithSaveLayer,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(20)),
                                                child: VideoNetworkWidget(
                                                    snapshot.data
                                                        .docs[index]["context"]["videoPreview"]),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Center(
                                                child: Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 1.2,
                                                  height: 1,
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() async {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                            "Notifications")
                                                            .doc()
                                                            .set({
                                                          "data": "like",
                                                          "relatedinfo": {
                                                            "postId": "",
                                                            "orderNo": ''
                                                          },
                                                          "seen": false,
                                                          "topic": "like",
                                                          "time": "${DateTime
                                                              .now()}",
                                                          "senderInfoo": {
                                                            "userName": userr
                                                                ?.name ?? " ",
                                                            "uid": userr?.uId ??
                                                                " ",
                                                            "userImg": userr
                                                                ?.photo ?? " ",
                                                          }
                                                        });
                                                        await service
                                                            .showNotification(
                                                            id: 0,
                                                            title: 'like ',
                                                            body: '${userr
                                                                ?.name} like your post');
                                                        isliked = !isliked;
                                                        isliked
                                                            ? likeslist.remove(
                                                            signInUser.uid)
                                                            : likeslist.add(
                                                            signInUser.uid);
                                                        _fireStore
                                                            .collection("Post")
                                                            .doc(snapshot.data
                                                            ?.docs[index]["id"])
                                                            .update({
                                                          "likes": likeslist
                                                        });
                                                      });
                                                    },
                                                    child: isliked ? SvgPicture
                                                        .asset(
                                                      "assets/profile_icons/like.svg",
                                                      semanticsLabel: 'Acme Logo',
                                                      color: Colors.grey,
                                                      width: size,
                                                      height: size,
                                                    ) :
                                                    SvgPicture.asset(
                                                      "assets/profile_icons/like.svg",
                                                      semanticsLabel: 'Acme Logo',
                                                      color: Colors.blue,
                                                      width: size,
                                                      height: size,
                                                    ),
                                                  ),
                                                  Text(
                                                      "${snapshot.data
                                                          ?.docs[index]["likes"]
                                                          .length}"),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),

                                                  const SizedBox(
                                                    width: 80,
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    height: 30,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 80,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          context: context,
                                                          useRootNavigator: true,
                                                          isScrollControlled: true,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .vertical(
                                                              top: Radius
                                                                  .circular(20),
                                                            ),
                                                          ),
                                                          clipBehavior: Clip
                                                              .antiAliasWithSaveLayer,
                                                          builder: (context) {
                                                            return Container(
                                                              color: postColor,
                                                              height: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .height - 30,
                                                              padding: EdgeInsets
                                                                  .all(10),
                                                              child: CommentScreen(
                                                                  context,
                                                                  postid: snapshot
                                                                      .data!
                                                                      .docs[index]["uid"],
                                                                  ownerid: signInUser
                                                                      .uid,
                                                                  ownername: userr
                                                                      ?.name ??
                                                                      " "),);
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
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "${CacheHelper.getInt(
                                                              key: "lenofcomment")}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (BuildContext context,
                                        int index) {
                                      return SizedBox(
                                        height: 10,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}

class Person {
  final String name, surname;
  final num age;

  Person(this.name, this.surname, this.age);
}
