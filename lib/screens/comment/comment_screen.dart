import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sls/shared/netWork/local/cache_helper.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';
import '../../contance.dart';
import '../notification/notification_screen.dart';
import '../service/localnotificationscreen.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../widget/custom_text.dart';

class CommentScreen extends StatefulWidget {
  String? postid;
  String? ownerid;
  String? ownername;
  String? ownerimg;
  CommentScreen(BuildContext context, {this.postid,this.ownerid,this.ownername,this.ownerimg});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  User? loggeruser;
  String collectionname = 'messages';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? messagetext;
  bool isliked=false;
  List<String>likeslist=[];
  final textfield = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool spinner = false;
  int leng = 0;
  bool isdesending = false;
  late final LocalNotificationService service;
  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    super.initState();
  }

  void clear() {
    textfield.clear();
  }
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      user?.reload();
      if (user != null) {
        loggeruser = user;
      }
    } catch (e) {
      print(e);
    }
  }
String userimg="";
  String usernamecomment = "";
  String postidddd="";
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: postColor,
      bottomNavigationBar: Container(
          padding: MediaQuery.of(context).viewInsets,
          color: postColor,
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.blue,
                    size: 40,
                  )),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 7,
                child: TextField(
                  controller: textfield,
                  onChanged: (value) {
                    messagetext = value;
                  },
                  style: TextStyle(color: Colors.grey[200]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Write comment",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue[500]!)),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration:
                  BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  child: InkWell(
                    // DocumentReference doc = _fireStore.collection("Posts").doc();
                      onTap: () {
                        setState(()async {
                          FirebaseFirestore.instance.collection("Notifications").doc().set({"data":"comment","relatedinfo":{"postId": "", "orderNo": ''},"seen": false,"topic": "follow","time": "${DateTime.now()}","senderInfoo":{"userName": user.user.name??" ", "uid": user.user.uId??" ", "userImg": user.user.photo??" ",}});
                          await service.showNotification(
                              id:0 ,
                              title: 'comment ',
                              body: '${user.user.name} comment your post');
                        databasecomment(context);
                        textfield.clear();
                        });
                      },
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          )),

      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Comments").where("relatedPost",isEqualTo: widget.postid).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CustomText(text:"Nothing Here",fontWeight: FontWeight.bold,color: Colors.white,),);
            }
            return Stack(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Row(
                            children: [
                              Text(
                                "${CacheHelper.getInt(key:"commentpost")} Comments",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Newest first",
                              style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  // databasecomment(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.blue[800],
                                )),
                            SizedBox(
                              width: 10,
                            ),
                        ],),//Spacer(),

                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      height: .5,
                      margin:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        //postid = snapshot.data!.docs[index]["postid"];
                        usernamecomment = snapshot.data!.docs[index]["userName"];
                        userimg = snapshot.data!.docs[index]["userImg"];

                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        leng = snapshot.data!.docs.length;
                     CacheHelper.setInt(key:"commentpost", value: leng);
                        return Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(radius: 10,child: Image.network(userimg,),backgroundColor: Colors.grey,),
                                Text(
                                  usernamecomment,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width / 1.5,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey[300],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    snapshot.data!.docs[index]["comment"],
                                    style:
                                    TextStyle(color: Colors.blueGrey[900]),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        setState(()async{
                                          FirebaseFirestore.instance.collection("Notifications").doc().set({"data":"like","relatedinfo":{"postId": "", "orderNo": ''},"seen": false,"topic": "like","time": "${DateTime.now()}","senderInfoo":{"userName": user.user.name??" ", "uid": user.user.uId??" ", "userImg": user.user.photo??" ",}});
                                          await service.showNotification(
                                              id:0 ,
                                              title: 'like ',
                                              body: '${user.user.name} like your post');
                                          isliked=!isliked;
                                          isliked ? likeslist.remove(loggeruser!.uid):likeslist.add(loggeruser!.uid) ;
                                          _fireStore.collection("Comments").doc().set(
                                              {"likes":likeslist});
                                        }); },
                                      // child: Icon(
                                      //   Icons.favorite,
                                      //   color: isliked ? Colors.red : Colors.grey,
                                      //   size: 25,
                                      // ),
                                    child: SvgPicture.asset(
                                      "assets/profile_icons/like.svg",
                                      semanticsLabel: 'Acme Logo',
                                      color: isliked ? Colors.blue : Colors.grey,
                                      width: 25,
                                      height: 25,
                                      ),),
                                    SizedBox(width: 8,),Text("${snapshot.data?.docs[index]["likes"].length}"),
                                    SvgPicture.asset(
                                      "assets/profile_icons/share.svg",
                                      semanticsLabel: 'Acme Logo',
                                      color: Colors.blue,
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(
                                      width: 70,
                                    ),
                                    Text("",
                                    // timeago.format((snapshot.data?.docs[index]["time"]).toDate()),
                                      //formattedDate,
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "1",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 13),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.network(
                                        "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
                                        width: 15,
                                        height: 15,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "Show replies",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        );
                      }),
                )
              ],
            );
          }),
    );
  }

  Widget commetist() {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.network(
            "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
            width: 50,
            height: 50,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " Omer Mohamed Elmawy",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.blueGrey[300],
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Nice",
                style: TextStyle(color: Colors.blueGrey[900]),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/profile_icons/like.svg",
                  semanticsLabel: 'Acme Logo',
                  color: Colors.grey[100],
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "2",
                  style: TextStyle(color: Colors.grey[100]),
                ),
                const SizedBox(
                  width: 18,
                ),
                SvgPicture.asset(
                  "assets/profile_icons/share.svg",
                  semanticsLabel: 'Acme Logo',
                  color: Colors.blue,
                  width: 25,
                  height: 25,
                ),
                const SizedBox(
                  width: 70,
                ),
                Text(
                 " snap",
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  "1",
                  style: TextStyle(color: Colors.blue, fontSize: 13),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                   backgroundImage: CachedNetworkImageProvider(img),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Show replies",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        )
      ],
    );
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
  final _fireStore = FirebaseFirestore.instance;
 String idd = "";
  String commentId=Uuid().v4();
  String username = "";
  String img="";
  List<String>docc=[];

  databasecomment(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    DocumentReference doc = _fireStore.collection("Comments").doc();
    _fireStore.collection("Comments").doc().set({
      "comment":messagetext,
      "likes":[],
      "relatedPost":widget.postid,
      "replies":[],
      "time":DateTime.now,
      "userInfo":{
        "userID":widget.ownerid,
        "userImg":user.user.photo,
        "userName":widget.ownername,
      }
    });


    //_fireStore.collection("commentsuer").doc("widget.postid").collection("comment");
    // _fireStore.collection("Posts").get().then((value) => {
    //   for(int i=0;i<value.docs.length;i++)
    //   {
    //     idd=value.docs[i].data()["id"]
    //   },
    // value.docs.forEach((element) {
    //         idd = element.data()["id"];
    //         username = element.data()["nameii"];
    //         img= element.data()["profileImg"];


       }

  }


