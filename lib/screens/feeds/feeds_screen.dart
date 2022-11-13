import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mime/mime.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sls/model/media_source.dart';
import 'package:sls/screens/comment/comment_screen.dart';
import 'package:sls/screens/widget/custom_button.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../contance.dart';
import 'package:like_button/like_button.dart';
import '../../model/user_model.dart';
import '../../providers/user_provider.dart';
import '../../shared/netWork/local/cache_helper.dart';
import '../home/add_post.dart';
import '../streamcomment/stream_comments.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/video_widget.dart';
import '../widget/videonetworkwidget.dart';
import '../notification/notification_screen.dart';
import '../service/localnotificationscreen.dart';

class FeedsScreen extends StatefulWidget {
  UserModel user;

  FeedsScreen(this.user);

  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  int? comments;
  String? id;
  Map? likes;
  String? postType;
  String? time;
  String? uid;
  int? likecountt;

  _FeedsScreenState({
    this.comments,
    this.id,
    this.likes,
    this.postType,
    this.time,
    this.uid,
    this.likecountt,
  });

  _FeedsScreenState.fromJson(DocumentSnapshot json) {
    comments = json["comments"];
    id = json["id"];
    postType = json["postType"];
    time = json["time"];
    uid = json["uid"];
    likes = json["likes"];
    likecountt = getlikecountt(likes);
    // likecountt!=null?likecountt++ :0;
  }

  int getlikecountt(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((element) {
      if (element == true) {
        count += 1;
      }
    });
    return count;
  }

  final _fireStore = FirebaseFirestore.instance;
  late final String? profileId;
  List<String> likeslist = [];
  List<String> followlist = [];
  List<String> followinglist = [];
  int likecount = 0;
  final _auth = FirebaseAuth.instance;
  late String currentuserId;
  int followerscount = 0;
  int followingcount = 0;
  double size = 25.0;
  bool isliked = false;
  MediaSource? source;
  late User signInUser;
  bool isowner = true;
  bool isfollowing = false;
  late final LocalNotificationService service;

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    super.initState();
    getCurrentUser();
  }

  AddPostState addpostedit = new AddPostState();

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

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => NotificationScreen())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    final Stream<QuerySnapshot> _postStream = FirebaseFirestore.instance
        .collection('Post')
        .where("postType", isEqualTo: "TextPostWithShop")
        .snapshots();

    return StreamBuilder(
        stream: _postStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data?.docs.length == 0) {
            return Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(10),
              color: HexColor("#f7b6b8"),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sticky_note_2_outlined,
                    color: Colors.blue,
                    size: 130,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("No Posts available now!",
                      style: TextStyle(
                          color: Colors.indigo[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 30)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "it seems there no posts right now make sure you are following others to see thier activites",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CustomButton(
                    () {},
                    text: "refresh".toUpperCase(),
                    color: Colors.indigo,
                    font: 20,
                    textColor: Colors.white,
                    width: 150,
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            itemCount: snapshot.data?.docs.length??0,
            itemBuilder: (BuildContext context, int index) {
              Timestamp timestamp = snapshot.data?.docs[index]["time"];
              postid = snapshot.data?.docs[index].id ?? " ";
              //***************
              //https://stackoverflow.com/questions/70205911/flutter-firebase-posts-that-user-like-system
              var document =
                  FirebaseFirestore.instance.collection('Users').doc();
              document.get().then((documentt) {});
              return Material(
                elevation: 2,
                color: HexColor("#f7b6b8"),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfileScreen(
                                                    name: snapshot.data!.docs[
                                                        index]["userName"],
                                                    profileimage:
                                                        snapshot.data?.docs[
                                                                    index]
                                                                ["profile"] ??
                                                            "",
                                                    id: snapshot.data!
                                                        .docs[index]["uid"],user:widget.user
                                                    )));
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        child: Image.network(snapshot
                                                .data?.docs[index]["profile"] ??
                                            ""),
                                        backgroundColor: Colors.deepOrange,
                                        radius: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]
                                                    ["userName"] ??
                                                " ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            "${timeago.format(timestamp.toDate())} ",
                                            style: TextStyle(
                                                color: Colors.grey[900],
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              const SizedBox(width: 60),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 30),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blue[900]!, width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() async {
                                      final userr = Provider.of<UserProvider>(
                                          context,
                                          listen: false);
                                      FirebaseFirestore.instance
                                          .collection("Notifications")
                                          .doc()
                                          .set({
                                        "data": "follow",
                                        "relatedinfo": {
                                          "postId": "",
                                          "orderNo": ''
                                        },
                                        "seen": false,
                                        "topic": "follow",
                                        "time": "${DateTime.now()}",
                                        "senderInfoo": {
                                          "userName": user.user.name ?? " ",
                                          "uid": user.user.uId ?? " ",
                                          "userImg": user.user.photo ?? " ",
                                        }
                                      });
                                      await service.showNotification(
                                          id: 0,
                                          title: 'follow ',
                                          body: '${user.user.name} follow you');
                                      isfollowing = !isfollowing;
                                      if (signInUser.uid !=
                                          snapshot.data?.docs[index]["uid"]) {
                                        isfollowing
                                            ? followlist.add(signInUser.uid)
                                            : followlist.remove(signInUser.uid);
                                        _fireStore
                                            .collection("Users")
                                            .doc(snapshot.data?.docs[index]
                                                ["uid"])
                                            .update({"follower": followlist});
                                        isfollowing
                                            ? followinglist.add(snapshot
                                                .data?.docs[index]["uid"])
                                            : followinglist.remove(snapshot
                                                .data?.docs[index]["uid"]);
                                        _fireStore
                                            .collection("Users")
                                            .doc(signInUser.uid)
                                            .update(
                                                {"following": followinglist});
                                      }
                                    });
                                  },
                                  child: Text(
                                    isfollowing ? "follow" : "Unfollow",
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AlertDialog(
                                              backgroundColor: postColor,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              const Radius
                                                                      .circular(
                                                                  20.0))),
                                              content: Container(
                                                width: 260.0,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.7,
                                                decoration: BoxDecoration(
                                                  color: postColor,
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Icon(
                                                              Icons.close,
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
                                                          color:
                                                              Colors.blue[900]),
                                                    ),
                                                    const SizedBox(
                                                      height: 25,
                                                    ),
                                                    Text(
                                                      "Hide this post",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[900]),
                                                    ),
                                                    const SizedBox(
                                                      height: 25,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState() {
                                                          snapshot.data!.docs
                                                              .removeAt(index);
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
                                                          onChanged: (value) {},
                                                          activeColor:
                                                              Colors.blue[900],
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
                                                          onChanged: (value) {},
                                                          activeColor:
                                                              Colors.blue[900],
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.more_vert,
                                      color: Colors.blue[900],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          snapshot.data!.docs[index]["context"]["text"],
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 350,
                            color: postColor,
                            child: source == MediaSource.image
                                ? Image.network(
                                    snapshot.data?.docs[index]["img"] ?? "")
                                : VideoNetworkWidget(
                                    snapshot.data?.docs[index]["img"] ?? "")),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 1,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() async {
                                  FirebaseFirestore.instance
                                      .collection("Notifications")
                                      .doc()
                                      .set({
                                    "data": "like",
                                    "relatedinfo": {
                                      "postId": "",
                                      "orderNo": ''
                                    },
                                    "seen": false,
                                    "topic": "like",
                                    "time": "${DateTime.now()}",
                                    "senderInfoo": {
                                      "userName": user.user.name ?? " ",
                                      "uid": user.user.uId ?? " ",
                                      "userImg": user.user.photo ?? " ",
                                    }
                                  });
                                  await service.showNotification(
                                      id: 0,
                                      title: 'like ',
                                      body: '${user.user.name} like your post');
                                  isliked = !isliked;
                                  isliked
                                      ? likeslist.remove(signInUser.uid)
                                      : likeslist.add(signInUser.uid);
                                  _fireStore
                                      .collection("Post")
                                      .doc(snapshot.data?.docs[index]["id"])
                                      .update({"likes": likeslist});
                                });
                              },
                              child:isliked? SvgPicture.asset(
                                "assets/profile_icons/like.svg",
                                semanticsLabel: 'Acme Logo',
                                color:  Colors.grey,
                                width: size,
                                height: size,
                              ):
                              SvgPicture.asset(
                                "assets/profile_icons/like.svg",
                                semanticsLabel: 'Acme Logo',
                                color:  Colors.blue ,
                                width: size,
                                height: size,
                              ),
                            ),
                            Text(
                                "${snapshot.data?.docs[index]["likes"].length}"),
                            const SizedBox(
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
                                      builder: (context) => StreamCommentScreen(
                                          context,
                                        streamid: postid,
                                          ownerid: signInUser.uid,
                                          ownername: user.user.name,ownerimg: snapshot.data?.docs[index]["profile"],),
                                    ),
                                );
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
                                    '2',
                                    style: TextStyle(color: Colors.black),
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
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 10,
              );
            },
          );
        });
  }

  Future showDialoOfPot(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              backgroundColor: postColor,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(20.0))),
              content: Container(
                width: 260.0,
                height: MediaQuery.of(context).size.height / 1.7,
                decoration: BoxDecoration(
                  color: postColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.blue[900],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Report this post",
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Hide this post",
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "Delete this post",
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      onTap: () {
                        // addpostedit.updatedatabase(context);
                      },
                      child: Text(
                        "Edit post",
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Allow post notifications",
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                        const Spacer(),
                        Switch(
                          value: true,
                          onChanged: (value) {},
                          activeColor: Colors.blue[900],
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
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                        const Spacer(),
                        Switch(
                          value: true,
                          onChanged: (value) {},
                          activeColor: Colors.blue[900],
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
  }

  databaselike(String postid, isliked) async {
    if (isliked) {
      DocumentReference likesstatus = _fireStore
          .collection("Postlikes")
          .doc(postid)
          .collection("userlikes")
          .doc(signInUser.uid);
      likesstatus.set({
        'time': DateTime.now(),
        'likestatus': isliked,
        "postid": postid,
      });
    } else {
      DocumentReference likesstatus = _fireStore
          .collection("likedpost")
          .doc(postid)
          .collection("userlikes")
          .doc(signInUser.uid);
      likesstatus.delete();
    }
  }

  List<String> listofpostid = [];
  List<String> listofpostoutput = [];
  String postid = "";
}
