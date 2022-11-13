import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:sls/providers/liveprovider.dart';
import 'package:sls/resources/firestore_methods.dart';
import 'package:sls/screens/broadcast/broadcast_screen.dart';
import 'package:video_player/video_player.dart';
import '../../contance.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../joinscreen.dart';
import '../../model/user_model.dart';
import '../../providers/user_provider.dart';
import '../../shared/netWork/local/cache_helper.dart';
import '../comment/comment_screen.dart';
import '../notification/notification_screen.dart';
import '../service/localnotificationscreen.dart';
import '../streamcomment/stream_comments.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/custom_button.dart';
import '../widget/video_widget.dart';
import '../widget/videonetworkwidget.dart';

class StreamField extends StatefulWidget {
  UserModel? user;
  StreamField ({this.user});
  @override
  State<StreamField> createState() => _StreamFieldState();
}

class _StreamFieldState extends State<StreamField> {
  BroadcastScreen? broadcastscreen;
  double size = 45;
  bool isliked = false;
  int likecount = 0;
  final _auth = FirebaseAuth.instance;
   User ?signInUser;
  final _fireStore = FirebaseFirestore.instance;
  List<String>followinglist=[];
  List<String>followlist=[];
  List<String> likeslist = [];
  bool isfollowing=false;
  late final LocalNotificationService service;
  CollectionReference _liveStream =
      FirebaseFirestore.instance.collection('livestream');

  List<String> itemms=[];
Future<List<String>>videos()async
{
  final user = Provider.of<UserProvider>(context, listen: false);
  final storageRef = FirebaseStorage.instance.ref("livestreamvideorecord/${user.user.uId}${user.user.name}");
  final listResult =await storageRef.listAll();
  for (var item in listResult.items) {
   itemms.add(item.name);
  }
  return itemms;
}

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => NotificationScreen())));
    }
  }
  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
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
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
   // final live = Provider.of<LiveProvider>(context, listen: false).live;

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Post").where("postType",isEqualTo: "TextPostWithLive").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.data?.docs.length==0)
        {
          return Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(10),
            color: HexColor("#f7b6b8"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.sticky_note_2_outlined,color: Colors.blue,size: 130,),
                 SizedBox(height: 5,),
                Text("No Posts available now!",style: TextStyle(color: Colors.indigo[800],fontWeight: FontWeight.bold,fontSize: 30)),
                SizedBox(height: 5,),
                Text("it seems there no posts right now make sure you are following others to see thier activites",style: TextStyle(color: Colors.grey,fontSize: 20),textAlign: TextAlign.center,),
                SizedBox(height: 5,),
                CustomButton((){},text:"refresh".toUpperCase(),color: Colors.indigo,font: 20,textColor: Colors.white,width: 150,),
              ],
            ),
          );
        }
        return ListView.separated(
          itemCount: snapshot.data?.docs.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
          //  String channelId = snapshot.data!.docs[index]["channelId"];
           // Timestamp timestamp = snapshot.data?.docs[index]["time"];
            Timestamp timestamp = snapshot.data!.docs[index]["context"]["duration"];
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
                                      builder: (context) => UserProfileScreen(

                                          name: snapshot.data!.docs[index]
                                              ["userName"],
                                          id: snapshot.data!.docs[index]
                                              ["uid"],
                                        profileimage: snapshot.data!.docs[index]
                                        ["profile"],user: widget.user??UserModel(),)));
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Image.network(snapshot.data!.docs[index]["profile"]??""),
                                  backgroundColor: Colors.deepOrange,
                                  radius: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]["userName"],
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
                                          color: Colors.grey[800],
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        const SizedBox(width: 100),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 30),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blue[900]!, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap:(){
                              setState(()async {
                                final userr = Provider.of<UserProvider>(context, listen: false);
                                FirebaseFirestore.instance.collection("Notifications").doc().set({"data":"Has Followed You","relatedinfo":{"postId": "", "orderNo": ''},"seen": false,"topic": "follow","time": "${DateTime.now()}","senderInfoo":{"userName": user.user.name??" ", "uid": user.user.uId??" ", "userImg": user.user.photo??" ",}});
                                await service.showNotification(
                                    id:0 ,
                                    title: 'Has Followed You ',
                                    body: '${user.user.name} follow you');
                                isfollowing =!isfollowing;
                                if(signInUser?.uid!=snapshot.data?.docs[index]["uid"]){
                                  isfollowing?followlist.add(signInUser?.uid??" "):followlist.remove(signInUser?.uid);
                                  _fireStore.collection("Users").doc(snapshot.data?.docs[index]["uid"]).update(
                                      {"follower":followlist});
                                  isfollowing?followinglist.add(snapshot.data?.docs[index]["uid"]):followinglist.remove(snapshot.data?.docs[index]["uid"]);
                                  _fireStore.collection("Users").doc(signInUser?.uid).update(
                                      {"following":followinglist});}
                              });
                            },
                            child: Text(
                              "Follow",
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
                              showDialogOfPost(context,snapshot.data!.docs[index]["uid"],signInUser?.uid??" ");
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
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
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
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 1,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                     clipBehavior: Clip.antiAliasWithSaveLayer,
                     height:350,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: VideoNetworkWidget(snapshot.data.docs[index]["context"]["videoPreview"],),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 1,
                        color: Colors.grey[300],
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
                                "data": "like your Post",
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
                                  ? likeslist.remove(signInUser?.uid)
                                  : likeslist.add(signInUser?.uid??" ");
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
                            width: 25,
                            height: 25,
                          ):
                          SvgPicture.asset(
                            "assets/profile_icons/like.svg",
                            semanticsLabel: 'Acme Logo',
                            color:  Colors.blue ,
                            width: 25,
                            height: 25,
                          ),
                        ),
                        Text(
                            "${snapshot.data.docs[index]["likes"].length}"),
                        // Text(
                        //   "${likecount}",
                        //   style: TextStyle(color: Colors.white),
                        // ),
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
                                      height:
                                          MediaQuery.of(context).size.height -
                                              30,
                                      padding: EdgeInsets.all(10),
                                      child: StreamCommentScreen(context,streamid:snapshot.data!.docs[index]["id"],ownerid:signInUser?.uid??" ",ownername:signInUser?.displayName??" ",ownerimg:snapshot.data!.docs[index]["profile"] ,),);
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
                                "3",
                                style: TextStyle(color: Colors.black),
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
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10,
            );
          },
        );
      },
    );
  }

  Future getuserslist() async {
    List itemlist = [];
    try {
      await _liveStream.get().then((value) {
        value.docs.forEach((element) {
          itemlist.add(element);
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  List Livestreamm = [];

  Future dynamicmethed() async {
    dynamic result = await getuserslist();
    if (result == null) {
      print("unable o retrieve");
    } else {
      setState(() {
        Livestreamm = result;
      });
    }
  }
}

class SamplePlayer extends StatefulWidget {
  SamplePlayer({Key? key}) : super(key: key);

  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  FlickManager? flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      autoPlay: false,
      videoPlayerController: VideoPlayerController.network(
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"),
    );
  }

  @override
  void dispose() {
    flickManager!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlickVideoPlayer(flickManager: flickManager!),
    );
  }
}

Future showDialogOfPost(context,String uid,String signinuser) {
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
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => JoinScreen()),);
                    },
                    child: Text(
                      "Report this post",
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Hide this post",
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Delete this post",
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Visibility(
                    visible: uid==signinuser?true:false,
                    child: Text(
                      "Edit post",
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Allow post notifications",
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                      Spacer(),
                      Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: Colors.blue[900],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Allow live notifications",
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                      Spacer(),
                      Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: Colors.blue[900],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ));
      });
}
