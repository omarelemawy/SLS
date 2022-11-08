import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:sls/screens/searchpage.dart';
import '../../contance.dart';
import '../account/account_screen.dart';
import '../feeds/feeds_screen.dart';
import '../home/add_post.dart';

import '../home/home_screen.dart';
import '../messages/messages_screen.dart';
import '../my_cart/my_cart_screen.dart';
import '../notification/notification_screen.dart';
import '../streams/streams_field.dart';

class UserProfileScreen extends StatefulWidget {
  String name,id;
  int count;

   UserProfileScreen({ this.name="",this.id="",this.count=1}) ;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>with SingleTickerProviderStateMixin {
  static List<Person> people = [
    Person('Mike', 'Barron', 64),
    Person('Todd', 'Black', 30),
    Person('Ahmad', 'Edwards', 55),
    Person('Anthony', 'Johnson', 67),
    Person('Annette', 'Brooks', 39),
  ];
  final _fireStore = FirebaseFirestore.instance;

  int index=0;
  TabController? _tabController;
  User? loggeduser;
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

  String usrid="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:HexColor("#f7b6b8"),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:HexColor("#f7b6b8"),
        leading: InkWell(
          onTap: (){
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context)=>const HomeScreen()), (route) => false);
          },
            child: const Icon(Icons.home_outlined,
                color: Colors.white,size: 35)),
        title: IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => MySearchPage())),
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
                     ,errorBuilder: (c,d,s){
                      return Container(
                        height: 20,
                        width: 20,
                      );
                    },
                      height: 40,width: 40,fit: BoxFit.fill,),
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
                backgroundColor:HexColor("#f7b6b8"),
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
                                        child: Column(
                                        children: [
                                          const SizedBox(height: 15,),
                                          const CircleAvatar(
                                            child: Text("N",style: TextStyle(color: Colors.white,fontSize: 25),),
                                            backgroundColor: Colors.deepOrange,
                                            radius: 35,
                                          ),
                                          const SizedBox(height: 15,),
                                           Text('${widget.name}',style:
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
                                               Text(" 6",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                            ],
                                          ),
                                          const SizedBox(height: 20,),
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
                                              GestureDetector(
                                                onTap:(){

                                                  CollectionReference users=FirebaseFirestore.instance.collection("ChatListUsers");
                                                 _fireStore.collection("Users").get().then((value)=>{
                                                   value.docs.forEach((element) {usrid=element.data()["uId"];})});
//*******************************
                                                  Future<bool> docExists =  ( checkIfDocExists(widget.id)) as Future<bool>  ;
                                                  print("Document exists in Firestore? " + docExists.toString());


                                                  //***************************
                                                  users.where(widget.id,isNotEqualTo:loggeduser?.uid).where("uId",isEqualTo:usrid).limit(3)
                                                      .get().then((QuerySnapshot querysnapshot)
                                                  {
                                                      if(docExists==false){

                                                     // widget.count++;
                                                      users.add({
                                                        "uid":usrid,
                                                        'name':widget.name,
                                                        'id':widget.id,
                                                        "status":"available"
                                                      }).then((value) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    MessagesScreen(name: widget.name,id:widget.id)));
                                                      });
                                                    }
                                                  });

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MessagesScreen()));

                                                  },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(vertical: 2,horizontal: 40),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.white,width: 1.5),
                                                    borderRadius: BorderRadius.circular(20),

                                                  ),
                                                  child:Icon(Icons.mail_outline, color:Colors.green,size: 20,),
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
                              backgroundColor:HexColor("#f7b6b8"),
                              bottom: PreferredSize(
                                preferredSize: Size.fromHeight(5.0),
                                child: TabBar(
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        "Feeds",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color:  _tabController!.index == 1
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
                                child: FeedsScreen(),

                                // ListView.separated(itemBuilder:
                                //     (context,index){
                                //   return FeedsScreen();
                                // },
                                //   itemCount: 12, separatorBuilder:
                                //       (BuildContext context, int index) {
                                //     return SizedBox(height:10,);
                                //   },
                                //
                                // ),
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
  /// Check If Document Exists
  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef =FirebaseFirestore.instance.collection("ChatListUsers");

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }
}
class Person {
  final String name, surname;
  final num age;

  Person(this.name, this.surname, this.age);
}
