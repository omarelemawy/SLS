import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:search_page/search_page.dart';
import 'package:sls/screens/chat/chat_screen.dart';
import 'package:sls/screens/home/home_screen.dart';

import '../account/account_screen.dart';
import '../notification/notification_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
/*  static List<Person> people = [
    Person('Mike', 'Barron', 64),
    Person('Todd', 'Black', 30),
    Person('Ahmad', 'Edwards', 55),
    Person('Anthony', 'Johnson', 67),
    Person('Annette', 'Brooks', 39),
  ];*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#191919"),

      body: Column(
        children: [
          const SizedBox(height: 30,),
          Row(
            children: [
              const SizedBox(width: 20,),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                  child: const Icon(Icons.arrow_back_ios,color: Colors.pinkAccent,)),
              const SizedBox(width: 20,),
              InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) =>  HomeScreen()), (
                            route) => false);
                  },
                  child: const Icon(Icons.home_outlined,
                      color: Colors.grey, size: 35)),
              const SizedBox(width: 20,),
              IconButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const MySearchPage())),
                  icon: const Icon(Icons.search,color: Colors.grey,size: 35,)),
              const Spacer(),
              InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>NotificationScreen()));
                  },
                  child: const Icon(Icons.notifications_none,color: Colors.grey,size: 35,)),
              const SizedBox(width: 20,),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AccountScreen()));
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
              ),
              const SizedBox(width: 20,),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Messages",style: TextStyle(color:
              Colors.blue[900],fontWeight: FontWeight.bold,fontSize: 18),),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width/4,),
              Text("you have no any new messages",style: TextStyle(color:
              Colors.grey[500],fontSize: 12),),
              const SizedBox(width: 25,),
              Text("Clean all",style: TextStyle(color:
              Colors.blue[500],fontSize: 12),),
            ],
          ),
          const SizedBox(height: 30,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.separated(itemBuilder: (context,index){
                return InkWell(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen()));
                   },
                    child: messagesCard());
              }, separatorBuilder: (context,index){
                return Container(
                  height: .5,width:
                MediaQuery.of(context).size.width-20,
                  color: Colors.grey[400],
                  margin: const EdgeInsets.symmetric(vertical: 20),
                );
              }, itemCount: 4),
            ),
          )
        ],
      ),
    );
  }
}
Widget messagesCard(){
  return  Row(
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
            child: Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png"
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
      Text("omacggv",style: TextStyle(color: Colors.grey[300],fontSize: 14,fontWeight: FontWeight.bold),),
      const Spacer(),
      Column(
        children: [
          Text("Jun 20,2022",style: TextStyle(color: Colors.grey[500],fontSize: 14),),
          Text("هايهراه",style: TextStyle(color: Colors.grey[500],fontSize: 12),),
        ],
      ),
      const SizedBox(width: 10,),
    ],
  );
}