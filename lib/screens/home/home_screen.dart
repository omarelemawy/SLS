import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import '../../contance.dart';
import '../account/account_screen.dart';
import '../feeds/feeds_screen.dart';
import '../messages/messages_screen.dart';
import '../my_cart/my_cart_screen.dart';
import '../notification/notification_screen.dart';
import '../streams/streams_field.dart';
import 'add_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  TextEditingController textController=TextEditingController();
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

    return Scaffold(
        backgroundColor:HexColor("#191919"),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("#191919"),
        leading:GestureDetector(child: const Icon(Icons.home_outlined,color: Colors.pinkAccent,size: 35,)),
        title: IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const MySearchPage())),
            icon: const Icon(Icons.search,color: Colors.grey,size: 35,)),
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
              child: const Icon(Icons.shopping_cart_rounded,color: Colors.grey,size: 35,)),
          const SizedBox(width: 10,),
          InkWell(
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MessagesScreen()));
              } ,
              child: const Icon(Icons.chat_outlined,color: Colors.grey,size: 35,)),
          const SizedBox(width: 10,),
          InkWell(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>NotificationScreen()));
              },
              child: const Icon(Icons.notifications_none,color: Colors.grey,size: 35,)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AccountScreen()));
              },
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
                    errorBuilder: (c,d,s){
                          return Container(
                            height: 30,
                            width: 30,
                          );
                    },height: 45,width: 45,fit: BoxFit.fill, ),
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
              ),
            ),
          )
        ],
      ),

      body: Scaffold(
        backgroundColor:HexColor("#191919"),
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
                        InkWell(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPost()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 35.0,right: 20,left: 20,bottom: 5),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "*Required";
                              }
                              return null;
                            },
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPost()));
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration:  InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.grey[400]!)
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                              label:  Text("Write Something",style: TextStyle(color: Colors.grey[400]),),
                            ),

                          ),
                        ),
                      ),
                      ],
                      )
                    ),
                    SliverAppBar(
                      floating: false,
                      snap: false,
                      pinned: false,
                      stretch: true,
                      expandedHeight: 0,
                      backgroundColor:  HexColor("#191919"),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(5.0),
                        child: TabBar(
                          tabs: [
                            Tab(
                              child: Text(
                                "Streams",

                                textAlign: TextAlign.center,
                                style: TextStyle(color:
                                _tabController!.index == 0
                                    ? Colors.pinkAccent
                                    : Colors.grey,fontSize: 18),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Feeds",
                                textAlign: TextAlign.center,
                                style: TextStyle(color:  _tabController!.index == 1
                                    ? Colors.pinkAccent
                                    : Colors.grey,fontSize: 18),
                              ),
                            ),
                          ],
                          onTap: (index){
                            setState((){});
                          },
                          controller: _tabController,
                          unselectedLabelStyle: const TextStyle(color: Colors.pinkAccent),
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
                  children:  <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(itemBuilder:
                            (context,index){
                           return const StreamField();
                            },
                          itemCount: 12, separatorBuilder:
                              (BuildContext context, int index) {
                          return const SizedBox(height:10,);
                          },

                            ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(itemBuilder:
                            (context,index){
                          return const FeedsScreen();
                        },
                          itemCount: 12, separatorBuilder:
                              (BuildContext context, int index) {
                            return const SizedBox(height:10,);
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
      )
    );
  }
}

class MySearchPage extends StatelessWidget {
  const MySearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: HexColor("#191919"),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: HexColor("#191919"),
        // The search area here
          title: Center(
            child: TextFormField(
              style: TextStyle(color: Colors.grey[200]),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "*Required";
                }
                return null;
              },
              decoration:  InputDecoration(
                  label:  Text("Search...",style: TextStyle(color: Colors.grey),),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  enabledBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue,width: 1.5),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 30)
              ),
            )
          )),
    );
  }
}


class Person {
  final String name, surname;
  final num age;

  Person(this.name, this.surname, this.age);
}