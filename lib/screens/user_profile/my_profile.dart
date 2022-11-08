import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:sls/screens/searchpage.dart';
import '../../contance.dart';
import '../../model/user_model.dart';
import '../../shared/netWork/local/cache_helper.dart';
import '../account/account_screen.dart';
import '../feeds/feeds_screen.dart';
import '../home/home_screen.dart';
import '../messages/messages_screen.dart';
import '../my_cart/my_cart_screen.dart';
import '../notification/notification_screen.dart';
import '../streams/streams_field.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>with SingleTickerProviderStateMixin {
  static List<Person> people = [
    Person('Mike', 'Barron', 64),
    Person('Todd', 'Black', 30),
    Person('Ahmad', 'Edwards', 55),
    Person('Anthony', 'Johnson', 67),
    Person('Annette', 'Brooks', 39),
  ];
  int index=0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length:2, vsync: this);
    _tabController!.addListener(_handleTabSelection);
  }
  void _handleTabSelection() {
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    Future<UserModel> readUser() async {
      final docUser = FirebaseFirestore.instance.collection("Users").doc(
          CacheHelper.getData(key: "uId"));
      final snapshot = await docUser.get();
      if (snapshot.exists) {
        return UserModel.fromJson(snapshot.data());
      } else {
        return UserModel(name: '');
      }
    }
    return Scaffold(
      backgroundColor:HexColor("#f7b6b8"),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("#f7b6b8"),
        leading: InkWell(
            onTap: (){
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);
            },
            child: const Icon(Icons.home_outlined,
              color: Colors.white,size: 35)),
        title: IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) =>  MySearchPage())),
            icon: const Icon(Icons.search,color: Colors.white,size: 35,)),
        actions: [
          InkWell(
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top:  Radius.circular(20),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (context) {
                      return Container(
                          color: postColor,
                          height: MediaQuery.of(context).size.height-30,
                          padding: EdgeInsets.all(10),
                          child: MyCartScreen());
                    });
              },
              child: const Icon(Icons.shopping_cart_rounded,color: Colors.white,size: 35,)),
          const SizedBox(width: 10,),
          InkWell(
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MessagesScreen()));
              } ,
              child: const Icon(Icons.chat_outlined,color: Colors.white,size: 35,)),
          const SizedBox(width: 10,),
          InkWell(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>NotificationScreen()));
              },
              child: const Icon(Icons.notifications_none,color: Colors.white,size: 35,)),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<UserModel?>(
                  future: readUser(),
                  builder: (context, AsyncSnapshot<UserModel?> snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,

                            ),
                            child: Image.network(
                              snapshot.data!.photo!,                                errorBuilder: (c, d, s) {
                              return Container(
                                height: 30,
                                width: 30,
                              );
                            }, height: 45, width: 45, fit: BoxFit.fill,),
                          ),
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            height: 10,

                            width: 10,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green
                            ),
                          ),
                        ],
                      );
                    }
                    return CircularProgressIndicator();
                  }
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
                    children:[
                      NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                                delegate: SliverChildListDelegate(
                                    <Widget>[
                                      Container(
                                        color: HexColor("#f7b6b8"),
                                        child:FutureBuilder<UserModel?>(
                                            future: readUser(),
                                            builder: (context, AsyncSnapshot<UserModel?> snapshot) {
                                              if (snapshot.hasData) {
                                                return Column(
                                                  children: [
                                                    const SizedBox(height: 15,),
                                                    Container(
                                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,

                                                      ),
                                                      child: Image.network(
                                                        snapshot.data!.photo!,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.fill,

                                                      ),
                                                    ),
                                                    const SizedBox(height: 15,),
                                                    Text(snapshot.data!.name!,style:
                                                    TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),
                                                    const SizedBox(height: 20,),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        const Text("Followers ",style: TextStyle(
                                                            color: Colors.white
                                                        ),),
                                                        Text(" 8",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                                        const SizedBox(width: 40,),
                                                        Container(
                                                          color: Colors.white,
                                                          width: 1,
                                                          height: 15,
                                                        ),
                                                        const SizedBox(width: 40,),
                                                        const Text("Followings ",style: TextStyle(
                                                            color: Colors.white
                                                        ),),
                                                        Text(" 6",style: TextStyle(fontWeight: FontWeight.bold
                                                            ,color: Colors.white),),
                                                      ],
                                                    ),
                                                    /*const SizedBox(height: 20,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 4,horizontal: 30),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.blue[700]!,width: 1.5),
                                                    borderRadius: BorderRadius.circular(20),

                                                  ),
                                                  child: Text(
                                                    "Follow",
                                                    style: TextStyle(
                                                        color: Colors.blue[700],
                                                        fontSize: 14,
                                                        fontWeight:FontWeight.w500
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 20,),
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 2,horizontal: 40),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.blue[700]!,width: 1.5),
                                                    borderRadius: BorderRadius.circular(20),

                                                  ),
                                                  child:Icon(Icons.mail_outline, color:Colors.grey[700],size: 20,),
                                                ),

                                              ],
                                            ),*/
                                                  ],
                                                );
                                              }
                                              return CircularProgressIndicator();
                                            }
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
                              backgroundColor:  HexColor("#f7b6b8"),
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(5.0),
                                child: TabBar(
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        "Feeds",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color:  _tabController!.index == 0
                                            ? Colors.black
                                            : Colors.white,fontSize: 18),
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        "Streams",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color:
                                        _tabController!.index == 1
                                            ? Colors.black
                                            : Colors.white,fontSize: 18),
                                      ),
                                    ),
                                  ],
                                  onTap: (index){
                                    setState((){});
                                  },
                                  controller: _tabController,
                                  unselectedLabelStyle: TextStyle(color: Colors.black),
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
                          children:  <Widget>[
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.separated(itemBuilder:
                                    (context,index){
                                  return FeedsScreen();
                                },
                                  itemCount: 12, separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(height:10,);
                                  },

                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.separated(itemBuilder:
                                    (context,index){
                                  return StreamField();
                                },
                                  itemCount: 12, separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(height:10,);
                                  },

                                ),
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
