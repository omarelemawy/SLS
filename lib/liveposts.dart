import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:sls/model/livestream.dart';
import 'package:sls/providers/user_provider.dart';
import 'package:timeago/timeago.dart'as timeago;


class Liveposts extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>Livepostsstate();
}

class Livepostsstate extends State<Liveposts>{
  @override
  Widget build(BuildContext context) {
    final userprovider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SafeArea(
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
          Text("Live users",style: TextStyle(fontSize: 22),),
              Expanded(
                  child: StreamBuilder<dynamic>(
                    stream: FirebaseFirestore.instance
                        .collection("livestream")
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return ListView.builder(
                        itemBuilder: (context, index) {
                          LiveStream livestream=LiveStream.fromMap(snapshot.data.docs[index].data);
                          return InkWell(
                            onTap: (){},
                            child: Container(
                              height:MediaQuery.of(context).size.height*0.1 ,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child:Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                AspectRatio(aspectRatio:16/9,child:Image.network("")),
                                  SizedBox(width: 10,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(livestream.username,style: TextStyle(color: Colors.black),),
                                      Text("${livestream.viewers}watching",style: TextStyle(color: Colors.black),),
                                      Text("started${timeago.format(livestream.startedAt.toDate())}",style: TextStyle(color: Colors.black),),
                                    ],),
                                  IconButton(onPressed:(){}, icon:Icon(Icons.more_vert))
                              ],)
                              // ListTile(
                              //   title: Text(
                              //     snapshot.data.docs[index]["userName"],
                              //     style: TextStyle(
                              //         color: snapshot.data.docs[index]['uId'] ==
                              //             userprovider.user.uId
                              //             ? Colors.blue
                              //             : Colors.black),
                              //   ),
                              //   subtitle: Text(snapshot.data.docs[index]["message"]),
                              // ),
                            ),
                          );
                        },
                        itemCount: snapshot.data.docs.length,
                      );
                    },
                  )),
            ],
          ),
        ),

      ),
    );
  }
}