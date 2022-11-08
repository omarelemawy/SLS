import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sls/model/media_source.dart';
import 'package:sls/screens/comment/comment_screen.dart';
import 'package:timeago/timeago.dart';
import '../../contance.dart';
import 'package:like_button/like_button.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/video_widget.dart';

class FeedsScreen extends StatefulWidget {
  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final _fireStore = FirebaseFirestore.instance;
  late final String? profileId;

  //var firebaseUser =  FirebaseAuth.instance.currentUser;
  //final firestoreInstance = FirebaseFirestore.instance;

  final followersref = FirebaseFirestore.instance.collection("followers");
  final followwingref = FirebaseFirestore.instance.collection("following");
  final activityfeed = FirebaseFirestore.instance.collection("activityfeed");
  bool isfollow = false;
  final _auth = FirebaseAuth.instance;
  late String currentuserId;
  int followerscount=0;
  int followingcount=0;
  double size=25.0;
  bool isliked=false;
  int likecount=0;
  MediaSource? source;
late User signInUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    //currentuserId = signInUser.uid;
  }

  handlefollow() {
    setState(() {
      isfollow = true;
    });
    followersref
        .doc(profileId)
        .collection("userfollowers")
        .doc(currentuserId)
        .set({});
    followwingref
        .doc(profileId)
        .collection("userfollowwing")
        .doc(currentuserId)
        .set({});
    activityfeed.doc(profileId).collection("feeditems").doc(currentuserId).set({
      "type": "follow",
      "ownerId": profileId,
      "username": signInUser.displayName,
      "userId": currentuserId,
    });
  }
  handleunfollow() {
    setState(() {
      isfollow = false;
    });
    followersref
        .doc(profileId)
        .collection("userfollowers")
        .doc(currentuserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    followwingref
        .doc(profileId)
        .collection("userfollowwing")
        .doc(currentuserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    activityfeed
        .doc(profileId)
        .collection("feeditems")
        .doc(currentuserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }
  getfollowers()async
  {
    QuerySnapshot snapshot=await followersref.doc(profileId).collection("").get();
    setState(() {
    //  followerscount=followersref.doc().collection("").get() ;
      setState(() {

      });
    });

  }

  checkIffollowing() async {
    DocumentSnapshot doc = await followersref
        .doc(profileId)
        .collection("userfollowers")
        .doc(currentuserId)
        .get();
    setState(() {
      isfollow = doc.exists;
    });
  }

  buildbuttonfollow() {
    bool isprofileowner = currentuserId == profileId;
    if (isprofileowner) {
      //hide button
    } else if (isfollow) {
      return InkWell(
        onTap: () {
          handleunfollow();
        },
        child: Text(
          "Unfollow",
          style: TextStyle(
              color: Colors.blue[900],
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
      );
    } else if (!isfollow) {
      return InkWell(
        onTap: () {
          handlefollow();
        },
        child: Text(
          "follow",
          style: TextStyle(
              color: Colors.blue[900],
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
      );
    }
  }
User? user;
  String convertdatetime(timpstamp) {
    var datefromtimestamp =
        DateTime.fromMillisecondsSinceEpoch(timpstamp.seconds * 1000);
    return DateFormat("yyyy-MM-dd tt:yy:ii ").format(datefromtimestamp);
  }
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('Posts').snapshots();
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
 // _AddPostState addpost=new _AddPostState();
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: _usersStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          // Map<String, dynamic> dataa = snapshot.data as Map<String, dynamic>;
          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
             //  DateTime dataNasc = DateTime.fromMicrosecondsSinceEpoch(
             // //snapshot.data!.docs();
             //      snapshot.data!.docs[index]["time"].microsecondsSinceEpoch);
             //  String formattedDate =
             //      DateFormat('yyyy-MM-dd – kk:mm').format(dataNasc);
              //
              // DateTime todate = DateTime.now();
              // String toDate = DateFormat('yyyy-MM-dd – kk:mm').format(todate);
              // final duration = todate.difference(dataNasc).inDays;

             // final date1 = convertdatetime(snapshot.data!.docs[index]["time"]);
             //  var datee = DateTime.fromMillisecondsSinceEpoch(snapshot.data!
             //    .docs[index]["time"] );
             //   var d24 = DateFormat('dd/MM/yyyy, HH:mm').format(datee);
              // print("*************************************************"+snapshot.data!
              //     .docs[index]["time"]);

               //final duration = date2.difference(DateTime.parse(d24)).inDays;

              // String name = snapshot.data!.docs[index]["nameii"];
              //  DateTime datet=DateTime(snapshot.data!
              //    .docs[index]["time"]);
              // final date2 = DateTime.now();
              // final duration = date2.difference(datet).inDays;
              // print("duration**********************${duration}");
              //*************

              String readTimestamp(int timestamp) {
                var now = new DateTime.now();
                var format = new DateFormat('HH:mm a');
                var date =
                    new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
                var diff = date.difference(now);
                var time = '';

                if (diff.inSeconds <= 0 ||
                    diff.inSeconds > 0 && diff.inMinutes == 0 ||
                    diff.inMinutes > 0 && diff.inHours == 0 ||
                    diff.inHours > 0 && diff.inDays == 0) {
                  time = format.format(date);
                } else {
                  if (diff.inDays == 1) {
                    time = diff.inDays.toString() + 'DAY AGO';
                  } else {
                    time = diff.inDays.toString() + 'DAYS AGO';
                  }
                }
                return time;
              }
              //***************
              var document = FirebaseFirestore.instance.collection('Users').doc();
              document.get(). then((documentt) {
              });
              //log("duration**********************${duration}");
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
                                                 UserProfileScreen(name:  snapshot.data!.docs[index]
                                                 ["nameii"],id:snapshot.data!.docs[index]
                                                 ["uid"] ,)));
                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        child: Image.file(File(snapshot.data?.docs[index]
                                  ["context"]["profileImage"] ??
                                      ""),),
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
                                            ["nameii"]
                                        ,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            "",
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
                                    setState(() {buildbuttonfollow();});
                                  },
                                  child: Text(
                                    "Unfollow",
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
                                                      onTap: (){
                                                        setState(){
                                                        snapshot.data!.docs.removeAt(index); 
                                                      }
                                                      },
                                                      child: Text(
                                                        "Delete this post",
                                                        style: TextStyle(color: Colors.blue[900]),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 25,
                                                    ),
                                                    InkWell(
                                                      onTap: (){},
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
                          height: 150,
                          color: Colors.white,
                          child: source == MediaSource.image
                              ? Image.file(File(snapshot.data?.docs[index]
                          ["context"]["imagepathhh"] ??
                              ""))
                              : VideoWidget(File(snapshot.data?.docs[index]
                          ["context"]["imagepathhh"] ??
                              ""))),
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
                            // SvgPicture.asset(
                            //   "assets/profile_icons/like.svg",
                            //   semanticsLabel: 'Acme Logo',
                            //   color: Colors.white,
                            //   width: 28,
                            //   height: 28,
                            // ),
                            // const SizedBox(
                            //   width: 10,
                            // ),
                            Text(
                              "",
                              style: TextStyle(color: Colors.white),
                            ),
                            //********************************************************likebutton
                           LikeButton(
                             size:size,
                             likeCount:likecount,
                             likeBuilder: (isLiked)
                             {
                               final color=isliked?Colors.red:Colors.grey;
                               return Icon(Icons.favorite,color: color,size: size,);
                             },
                             likeCountPadding: EdgeInsets.only(left: 12),
                             countBuilder: (count,isliked,text)
                             {
                               final color=isliked?Colors.black:Colors.grey;
                               return Text(text,style: TextStyle(
                                 color: color,fontSize: 24,fontWeight: FontWeight.bold,
                               ),);
                             },
                             onTap: (isliked)async
                             {
                               this.isliked=!isliked;
                               likecount+=this.isliked?1:-1;
                               return !isliked;
                             },

                           ),

                            //**********************************************************likebutton
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
                                // CollectionReference comments=FirebaseFirestore.instance.collection("comments");
                                // comments.where("id",isEqualTo:snapshot.data!.docs[index]["id"]).limit(1)
                                //     .get().then((QuerySnapshot querysnapshot)
                                // {
                                //   if(querysnapshot.docs.isEmpty)
                                //   {
                                //
                                //   }
                                // }
                                // );
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              30,
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
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '1',
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

  Future showDialoOfPost(context) {
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
                    Text(
                      "Delete this post",
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Edit post",
                      style: TextStyle(color: Colors.blue[900]),
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

  //*****filteration

  List <String>listofpostid = [];
  List <String>listofpostoutput = [];
  String postid="";


  void filternme(){
    String ff="";
    // FirebaseFirestore.instance.collection('users').doc(signInUser.uid).get().then((DocumentSnapshot documentSnapshot) {
      //   if (documentSnapshot.exists) {
      //     print('Document data: ${documentSnapshot.}');
      //   } else {
      //     print('Document does not exist on the database');
      //   }
      // });
      // _fireStore.collection("Posts").get().then((value) => {
      // //  print(value.docs);
      // //listofpostoutput=value.docs.cast<String>()
      //
      //    value.docs.forEach((element) {
      //     postid= element.data()["id"];
      //     listofpostid.add(postid.toLowerCase());
      //   // listofpostoutput= listofpostid.where((element) =>element.toLowerCase(),isEqualto:).toList();
      //   })
      // });
      var document = FirebaseFirestore.instance.collection('Users').doc();
      document.get(). then((documentt) {
        ff=documentt["Username"];
     // return documentt["Username"];
        return ff;
    });

  }}

