import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user_model.dart';
import '../../providers/user_provider.dart';
import '../../shared/netWork/local/cache_helper.dart';

class MessageTextField extends StatefulWidget {
  final String docId;
  final String currentId;
  final String friendId;
  final String friendImg;
  final String sendername;
  final String senderimg;

  MessageTextField(this.docId,this.currentId,this.friendId,this.friendImg,this.sendername,this.senderimg);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _controller = TextEditingController();
  bool seendata=false;
  UserModel? userr;
  bool ?existt;
  Future<UserModel?> readUser() async {
    final docUser = FirebaseFirestore.instance
        .collection("Users")
        .doc(CacheHelper.getData(key: "uId"));
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      userr = UserModel.fromJson(snapshot.data());
      return userr;
    } else {
      return UserModel(name: '');
    }
  }


  @override
  Widget build(BuildContext context) {
    final userperson=Provider.of<UserProvider>(context, listen: false);
    return Container(
       color: Colors.white,
       padding: EdgeInsetsDirectional.all(8),
       child: Row(
         children: [
           Expanded(child: TextField(
             controller: _controller,
              decoration: InputDecoration(
                labelText:"${userr?.name??" "}",
                fillColor: Colors.grey[100],
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0),
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(25)
                )
              ),
           )),
           SizedBox(width: 20,),
           GestureDetector(
             onTap: ()async{
               String message = _controller.text;
               _controller.clear();
               DocumentSnapshot<Map<String,dynamic>> documentSnapshot=await FirebaseFirestore.instance.collection("chatChannels").doc(widget.docId).get();
               if(documentSnapshot.exists)
               {
                 await FirebaseFirestore.instance.collection('chatChannels').doc(widget.docId).collection('messages').add({
                   "senderId":widget.currentId,
                   "senderImage":widget.senderimg,
                   "senderName":widget.sendername,
                   "receiverId":widget.friendId,
                   "receiverImage":widget.friendImg,
                   "text":message,
                   "type":"TEXT",
                   "seen":seendata,
                   "time":DateTime.now(),
                 });

               }
               await FirebaseFirestore.instance.collection('chatChannels').doc(widget.docId).collection('messages').add({
                 "senderId":widget.currentId,
                 "senderImage":widget.senderimg,
                 "senderName":widget.sendername,
                 "receiverId":widget.friendId,
                 "receiverImage":widget.friendImg,
                 "text":message,
                 "type":"TEXT",
                 "seen":seendata,
                 "time":DateTime.now(),
               });
    // await FirebaseFirestore.instance.collection('chatChannels').doc(widget.docId).collection('messages').doc().update({
    //               "senderId":widget.currentId,
    //              "senderImage":widget.senderimg,
    //              "senderName":widget.sendername,
    //               "receiverId":widget.friendId,
    //              "receiverImage":widget.friendImg,
    //               "text":message,
    //               "type":"TEXT",
    //              "seen":seendata,
    //               "time":DateTime.now(),
    //            });

             },
             child: Container(
               padding: EdgeInsets.all(8),
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 color: Colors.blue,
               ),
               child: Icon(Icons.arrow_forward,color: Colors.white,),
             ),
           )
         ],
       ),
      
    );
  }


   Future<bool> checkExist() async {

      DocumentSnapshot<Map<String,dynamic>> documentSnapshot=await FirebaseFirestore.instance.collection("chatChannels").doc(widget.docId).get();
        if(documentSnapshot.exists)
          {
            return true;
          }
        else{
          return false;
        }



  }
}