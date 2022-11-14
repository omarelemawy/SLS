import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:provider/provider.dart';
import 'package:sls/screens/searchpage.dart';
import 'package:sls/screens/widget/notificationapi.dart';
import '../../contance.dart';
import '../../model/livestream.dart';
import '../../model/user_model.dart';
import '../../providers/user_provider.dart';
import '../../resources/firestore_methods.dart';
import '../../shared/netWork/local/cache_helper.dart';
import '../../utils/utils.dart';
import '../account/account_screen.dart';
import '../auth/first_screen.dart';
import '../broadcast/broadcast_screen.dart';
import '../feeds/feeds_screen.dart';
import '../go_live_screen.dart';
import '../messages/messages_screen.dart';
import '../my_cart/my_cart_screen.dart';
import '../notification/notification_screen.dart';
import '../search2.dart';
import '../service/localnotificationscreen.dart';
import '../streams/streams_field.dart';
import '../widget/custom_text.dart';
import '../widget/video_widget.dart';
import '../widget/videolivenetworkwidget.dart';
import '../widget/videonetworkwidget.dart';
import 'add_post.dart';

class HomeScreen extends StatefulWidget {
  static String id = "home";
  bool broadcast;

  HomeScreen({this.broadcast = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // UserModel user=UserModel();
  final _auth = FirebaseAuth.instance;
  late User signInUser;
  TextEditingController textController = TextEditingController();
  final _fireStore = FirebaseFirestore.instance;
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
  //  int index = 0;
  TabController? _tabController;
  final Stream<QuerySnapshot> _postStream =
      FirebaseFirestore.instance.collection('Post').where("postType",isEqualTo: "TextPostWithLive").snapshots();

  final Stream<QuerySnapshot> _postposStream =
  FirebaseFirestore.instance.collection('Post').where("postType",isEqualTo: "TextPostWithShop").snapshots();

  late final LocalNotificationService service;
  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    super.initState();
    getCurrentUser();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    debugPrint("${userr?.name}kjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
  }

  void _handleTabSelection() {
    setState(() {});
  }

  UserModel? userr;

  Future<UserModel?> readUser() async {
    final docUser = FirebaseFirestore.instance.collection("Users").doc(signInUser.uid);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      userr = UserModel.fromJson(snapshot.data());

      return userr;
    } else {
      return UserModel(name: '');
    }
  }

  LiveStream? livee;

  Future<LiveStream?> readlive() async {
    final docUser = FirebaseFirestore.instance
        .collection("Livestreamimage")
        .doc(CacheHelper.getData(key: "uId"));
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      livee = LiveStream.fromMap(snapshot.data()!);
      return livee;
    } else {
      return LiveStream(
        channelId: '',
        uid: '',
        viewers: 0,
        record: '',
        startedAt: " ",

        islive: false,
        username: '', photoprofile: '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    debugPrint("${userr?.name}widgettttttttttttttttttttttttttttttttttttttttttttttt");
    final userperson = Provider.of<UserProvider>(context).user;
    return Scaffold(
        backgroundColor: HexColor("#f7b6b8").withOpacity(.5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: HexColor("#f7b6b8").withOpacity(.6),
          leading: GestureDetector(
              child: const Icon(
            Icons.home_outlined,
            color: Colors.pinkAccent,
            size: 35,
          )),
          title: IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SearchScreen(userr ?? UserModel()))),
              icon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 35,
              )),
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
                            height: MediaQuery.of(context).size.height - 30,
                            padding: EdgeInsets.all(10),
                            child: MyCartScreen());
                      });
                },
                child: InkWell(
                  onTap: () {
                    CacheHelper.saveData(key: "uId", value: "");
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyCartScreen()),
                        (route) => false);
                  },
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 35,
                  ),
                )
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MessagesScreen(user: userr?? UserModel(),)));
                },
                child: const Icon(
                  Icons.chat_outlined,
                  color: Colors.white,
                  size: 35,
                )),
            const SizedBox(
              width: 10,
            ),
            InkWell(
                onTap: ()async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                },
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 35,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  AccountScreen()));
                },
                child: // FutureBuilder<UserModel?>(
                    //     future: readUser(),
                    //     builder: (context, AsyncSnapshot<UserModel?> snashot) {
                    //       if (snashot.hasData) {
                    //         return
                    Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        userperson.photo ?? "empty image",
                        errorBuilder: (c, d, s) {
                          return Container(
                            height: 30,
                            width: 30,
                          );
                        },
                        height: 45,
                        width: 45,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                    ),
                  ],
                ),
                //       }
                //       return CircularProgressIndicator();
                //     }
                // ),
              ),
            )
          ],
        ),
        body: Scaffold(
          backgroundColor: HexColor("#f7b6b8").withOpacity(.6),
          body: DefaultTabController(
            length: 2,
            child: Stack(
              children: [
                StreamBuilder(
                    stream: _postStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (!snapshot.hasData) {
                        return Container(width: 0,height: 0,);
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length??0,
                        itemBuilder:
                            (BuildContext context, int index) {
                          return Visibility(
                              visible:
                              snapshot.data.docs[index]
                              ["context"]["live"],
                              child: InkWell(
                                onTap: () {
                                  // await FirestoreMethods()
                                  //     .updateViewCount(post.channelId, true);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BroadcastScreen(
                                            channelId:
                                            snapshot.data.docs[index]
                                            ["id"] ??
                                                " ",
                                            isBroadcaster:
                                            widget.broadcast,
                                          ),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children:[

                                    Padding(
                                    padding: const EdgeInsets.only(
                                         left: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 600.0,top: 15),
                                      child: Container(
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        height:160,width: 140,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15)),
                                        child: VideoLiveNetworkWidget(snapshot.data.docs[index]["context"]["videoPreview"]),
                                      ),
                                    ),
                                  ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:10.0,top:15),
                                      child: Align(alignment: Alignment.topLeft,child: Container(
                                          height: 15,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(10),

                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "live ",
                                                style: TextStyle(color: Colors.white,fontSize: 12),
                                              ),

                                            ],
                                          )),),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 100.0,left: 13),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          CircleAvatar(child: Image.network(snapshot.data.docs[index]["profile"]),radius: 15,backgroundColor: Colors.grey,),
                                           CustomText(text: snapshot.data.docs[index]["userName"],color: Colors.white,),
                                        ],
                                      ),

                                    ),
                                  )
                                  ]
                                ),
                              ));
                        },
                        // separatorBuilder:
                        //     (BuildContext context, int index) {
                        //   return Container(width: 5, height: 5);
                        // },
                      );
                    }),

                Padding(
                  padding: const EdgeInsets.only(top:160.0),
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverList(
                            delegate: SliverChildListDelegate(
                          <Widget>[
                            InkWell(
                              onTap: ()async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddPost()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 15.0, right: 20, left: 20, bottom: 5),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "*Required";
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddPost()));
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    label: Text(
                                      "Write Something",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                        SliverAppBar(
                          floating: false,
                          snap: false,
                          pinned: false,
                          stretch: true,
                          expandedHeight: 0,
                          backgroundColor: HexColor("#f7b6b8").withAlpha(2),
                          bottom: PreferredSize(
                            preferredSize: const Size.fromHeight(5.0),
                            child: TabBar(
                              tabs: [
                                Tab(
                                  child: Text(
                                    "Streams",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _tabController!.index == 0
                                            ? Colors.pinkAccent
                                            : Colors.white,
                                        fontSize: 18),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Feeds",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _tabController!.index == 1
                                            ? Colors.pinkAccent
                                            : Colors.white,
                                        fontSize: 18),
                                  ),
                                ),
                              ],
                              onTap: (index) {
                                setState(() {});
                              },
                              controller: _tabController,
                              unselectedLabelStyle:
                                  const TextStyle(color: Colors.pinkAccent),
                              unselectedLabelColor: Colors.pinkAccent,
                              labelColor: Colors.pinkAccent,
                              indicatorColor: Colors.pinkAccent,
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        // StreamBuilder(
                        //     stream: _fireStore.collection("Posts").snapshots(),
                        //     builder: (context,
                        //         AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        //       if (!streamSnapshot.hasData) {
                        //         return Center(child: CircularProgressIndicator());
                        //       }
                        //       //  var messages = streamSnapshot.data!;
                        //
                        //       return
                                Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: StreamField(),
                                ),
                              ),
                           // }),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FeedsScreen(userr??UserModel() ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
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
}

class Person {
  final String name, surname;
  final num age;

  Person(this.name, this.surname, this.age);
}
