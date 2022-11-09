import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:search_page/search_page.dart';
import 'package:sls/screens/chat/chat_screen.dart';
import 'package:sls/screens/searchpage.dart';
import '../../model/user_model.dart';
import '../../shared/netWork/local/cache_helper.dart';
import '../account/account_screen.dart';
import '../chat/chatt.dart';
import '../home/home_screen.dart';
import '../notification/notification_screen.dart';

class MessagesScreen extends StatefulWidget {
  String  name,id,photo;
 //UserModel? user;

   MessagesScreen({this.id=" ",this.name="",this.photo=""}) ;

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<Map> messageresult = [];
bool isloading=false;

  @override
  void initState() {
    super.initState();
    // if(widget.id!=null )
    // {
    //   return messageresult.add(messagesCard(widget.name,widget.photo,widget.id));
    // }
  //  messageresult.add(messagesCard(widget.name,widget.photo,widget.id));

    messageresult=[];
    isloading=true;

    update();
  }
void update()async
{
  await FirebaseFirestore.instance
      .collection('Users')
      .where("uId", isEqualTo: widget.id)
      .get()
      .then((value) {
    if (value.docs.length < 1) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No User Found")));
      setState(() {
        isloading = false;
      });
      return;
    }
    value.docs.forEach((user) {
      //  if(user.data()['email'] != widget.user.email){
      messageresult.add(user.data());
      // }
    });

  });
}

  @override
  Widget build(BuildContext context) {

      return Scaffold(

        backgroundColor: HexColor("#f7b6b8"),

        body: Column(
          children: [
            const SizedBox(height: 30,),
            Row(
              children: [
                const SizedBox(width: 20,),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios, color: Colors.pinkAccent,)),
                const SizedBox(width: 20,),
                InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()), (
                              route) => false);
                    },
                    child: const Icon(Icons.home_outlined,
                        color: Colors.white, size: 35)),
                const SizedBox(width: 20,),
                IconButton(
                    onPressed: () =>
                        Navigator.of(context)
                            .push(
                            MaterialPageRoute(builder: (_) => MySearchPage())),
                    icon: const Icon(
                      Icons.search, color: Colors.white, size: 35,)),
                const Spacer(),
                InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen()));
                    },
                    child: const Icon(
                      Icons.notifications_none, color: Colors.white,
                      size: 35,)),
                const SizedBox(width: 20,),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => AccountScreen()));
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
                Text("Messages", style: TextStyle(color:
                Colors.blue[900], fontWeight: FontWeight.bold, fontSize: 18),),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: MediaQuery
                    .of(context)
                    .size
                    .width / 4,),
                Text("you have no any new messages", style: TextStyle(color:
                Colors.white, fontSize: 12),),
                const SizedBox(width: 25,),
                InkWell(
                  onTap:(){
                    update();
                  },
                  child: Text("Clean all", style: TextStyle(color:
                  Colors.blue[500], fontSize: 12),),
                ),
              ],
            ),
            const SizedBox(height: 30,),
            if (messageresult.length > 0)
            Expanded(
              //firestore.collection("Users").get().then((value)=>{value.docs.forEach((element) {
              child: Padding(
                padding: const EdgeInsets.all(15.0),

                child: ListView.separated(
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => Chat()));
                              },
                              child: messagesCard(messageresult[index]['userName']??" ",messageresult[index]['profileImg']??" ",messageresult[index]['uId']??" "));
                        }, separatorBuilder: (context, index) {
                      return Container(
                        height: 1, width:
                      MediaQuery
                          .of(context)
                          .size
                          .width - 20,
                        color: Colors.grey[400],
                        margin: const EdgeInsets.symmetric(vertical: 20),
                      );
                    }, itemCount:messageresult.length,

                ),
              ),
            )
          ],
        ),
      );

  }
}
Widget messagesCard(String namee,String photo,String email){
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
            child: Image.network(photo
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
      Text(namee,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
      const Spacer(),
      Column(
        children: [
          Text("Jun 20,2022",style: TextStyle(color: Colors.white,fontSize: 14),),
          Text(email,style: TextStyle(color: Colors.white,fontSize: 12),),
        ],
      ),
      const SizedBox(width: 10,),
    ],
  );
}
