import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  File file;

  MessageTextField(this.docId, this.currentId, this.friendId, this.friendImg,
      this.sendername, this.senderimg, this.file);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _controller = TextEditingController();
  bool seendata = false;
  UserModel? userr;
  bool? existt;
  bool isEmojiVisible = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isEmojiVisible = false;
        });
      }
    });
  }

  Future<String?> uploadeImage(File file) async {
    final storageRef = FirebaseStorage.instance.ref();
    String? dowurl;
    //Upload the file to firebase
    Reference reference =
        storageRef.child('Messages/${file.path.split('/').last}');
    UploadTask uploadTask = reference.putFile(file);
    dowurl = await (await uploadTask).ref.getDownloadURL();
    return dowurl;
  }

  Future getFile() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      widget.file = File(image.path);
    } else {}
  }

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

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final userperson = Provider.of<UserProvider>(context, listen: false);
    return Container(
      color: Colors.white,
      padding: EdgeInsetsDirectional.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  focusNode..unfocus();
                  focusNode.canRequestFocus = false;
                  setState(() {
                    isEmojiVisible = !isEmojiVisible;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              // GestureDetector(
              //   onTap: () async {
              //     focusNode..unfocus();
              //     focusNode.canRequestFocus = false;
              //     getFile();
              //     uploadeImage(widget.file).then((value) async {
              //       await FirebaseFirestore.instance
              //           .collection('chatChannels')
              //           .doc(widget.docId)
              //           .collection('messages')
              //           .doc()
              //           .set({
              //         "senderId": widget.currentId,
              //         "senderImage": widget.senderimg,
              //         "senderName": widget.sendername,
              //         "receiverId": widget.friendId,
              //         "receiverImage": widget.friendImg,
              //         "imagePath": value,
              //         "type": "IMAGE",
              //         "seen": seendata,
              //         "time": DateTime.now(),
              //       });
              //     });
              //   },
              //   child: Container(
              //     padding: EdgeInsets.all(8),
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.blue,
              //     ),
              //     child: Icon(
              //       Icons.image,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: TextField(
                focusNode: focusNode,
                controller: _controller,
                decoration: InputDecoration(
                    labelText: "${userr?.name ?? " "}",
                    fillColor: Colors.grey[100],
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 0),
                        gapPadding: 10,
                        borderRadius: BorderRadius.circular(25))),
              )),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () async {
                  String message = _controller.text;
                  _controller.clear();
                  // DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
                  //     await FirebaseFirestore.instance
                  //         .collection("chatChannels")
                  //         .doc(widget.docId)
                  //         .collection('messages')
                  //         .doc()
                  //         .get();
                  // if (documentSnapshot.exists) {
                  //   await FirebaseFirestore.instance
                  //       .collection('chatChannels')
                  //       .doc(widget.docId)
                  //       .collection('messages')
                  //       .doc()
                  //       .set({
                  //     "senderId": widget.currentId,
                  //     "senderImage": widget.senderimg,
                  //     "senderName": widget.sendername,
                  //     "receiverId": widget.friendId,
                  //     "receiverImage": widget.friendImg,
                  //     "text": message,
                  //     "type": "TEXT",
                  //     "seen": seendata,
                  //     "time": DateTime.now(),
                  //   });
                  // }
                  await FirebaseFirestore.instance
                      .collection('chatChannels')
                      .doc(widget.docId)
                      .collection('messages')
                      .add({
                    "messageid":widget.docId,
                    "senderId": widget.currentId,
                    "senderImage": widget.senderimg,
                    "senderName": widget.sendername,
                    "receiverId": widget.friendId,
                    "receiverImage": widget.friendImg,
                    "text": message,
                    "type": "TEXT",
                    "seen": seendata,
                    "time": DateTime.now(),
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          isEmojiVisible ? emojselected() : Container(),
        ],
      ),
    );
  }

  Future<bool> checkExist() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection("chatChannels")
            .doc(widget.docId)
            .get();
    if (documentSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  void onclickEmoj() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    await Future.delayed(Duration(milliseconds: 100));
  }

  Widget emojselected() {
    return EmojiPicker(
      rows: 4,
      columns: 7,
      onEmojiSelected: (emoj, category) {},
    );
  }
}
