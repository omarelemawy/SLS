
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sls/screens/home/home_Screen.dart';
import 'package:sls/screens/videosource/source_page.dart';
import 'package:sls/screens/widget/video_widget.dart';
import 'package:video_player/video_player.dart';
import '../../contance.dart';
import '../../model/media_source.dart';
import '../go_live_screen.dart';
import '../widget/custom_button.dart';
import 'package:path_provider/path_provider.dart';

class UpdatePost extends StatefulWidget {
  const UpdatePost({Key? key});
  static String routeName = '/addpost';
  @override
  State<UpdatePost> createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {

  // final FirebaseMessaging fcm=FirebaseMessaging();
  TextEditingController quantityController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final _fireStore = FirebaseFirestore.instance;
  List<Uint8List>? photos;
  bool isfollow = true;
  String? path,videopath;
  bool isstretched = false;
  final _auth = FirebaseAuth.instance;
  File? _image;
  bool click=true;
  PickedFile? pickedFile;
  final picker = ImagePicker();
  late User signInUser;
  late VideoPlayerController _videoPlayerController;
  String? pp;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
    pp=fileMedia?.path;
    _videoPlayerController = VideoPlayerController.file(_image ?? File(""))
      ..initialize().then((_) {
        setState(() {});
      });
  }
  _pickvideo() async {
    print("********************************************** + ${signInUser.displayName}");
    pickedFile = await picker.getVideo(source: ImageSource.gallery);
    _image = File(pickedFile!.path);
    videopath = _image!.path;
    _videoPlayerController = VideoPlayerController.file(_image!)
      ..initialize().then((_) {
        setState(() {});
      });
    _videoPlayerController.play();
  }
  Future<void> getCurrentUser()async {
    try {
      final user =await _auth.currentUser;
      user?.reload();
      if (user != null) {
        signInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
  File? fileMedia;
  MediaSource? source;
  @override
  Widget build(BuildContext context) {
    DocumentReference doc = _fireStore.collection("Posts").doc();

    return WillPopScope(
      onWillPop: () {
        dialog();
        return dialog();
      },
      child: Scaffold(
        backgroundColor: HexColor("#f7b6b8"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                  Center(
                    child: Text(
                      "Write A Post",
                      style: TextStyle(
                          color: Colors.indigo[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        dialog();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.indigo,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Write something",
                      style: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Spacer(),
                    Container(
                      width: 120,
                      height: 50,
                      child: Buildbutton(),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.indigo[200],
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "*Required";
                    }
                    return null;
                  },
                  controller: postController,
                  decoration: InputDecoration(
                      label: Text(
                        "Write something here..",
                        style: TextStyle(color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 30)),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "*Required";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: quantityController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          label: Text(
                            "Quantity",
                            style: TextStyle(color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.pinkAccent, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.pinkAccent, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 30)),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "*Required";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      decoration: InputDecoration(
                          hintText: "0",
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.pinkAccent, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.pinkAccent, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          suffixIcon: Icon(
                            CupertinoIcons.money_euro,
                            color: Colors.pinkAccent,
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: (){
                      showDialogOfPost(context);
                    },
                    child: Icon(
                      Icons.local_offer_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => GoLiveScreen())
                      );
                    },
                    child: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                      onTap: () async {
                        if (pickedFile ==
                            await picker.getImage(
                                source: ImageSource.gallery)) {
                          if (pickedFile != null) {
                            setState(() {
                              _image = File(pickedFile!.path);
                              print(_image);
                              path = _image!.path;
                              print(path);
                            });
                          }
                        }
                        var img=await picker.getImage(source: ImageSource.gallery);
                        _image=File(img!.path);
                      }
                      //********************************************************
                      //  final result=await FilePicker.platform.pickFiles(
                      //    allowMultiple: false,
                      //    type: FileType.custom,
                      //    allowedExtensions: ['png','jpg'],
                      //  );
                      //  if(result ==null)
                      //  {
                      //
                      //  }
                      //image!=null?Image.file(_image!):Container();
                      // path =result?.files.single.path;
                      //  final filename=result?.files.single.name;
                      //
                      //  print(path);
                      //  print(filename);
                      //   doc.set({
                      //     "imagepath":path,
                      //     "filename":filename
                      //   });
                      ,
                      child: Icon(
                        CupertinoIcons.photo_on_rectangle,
                        color: Colors.blue,
                      )
                  ),
                ],
              ),
              SizedBox(
                height: 70,
              ),
              Column(children: [
                fileMedia == null
                    ? Icon(Icons.photo, size: 120)
                    : (source == MediaSource.image
                    ? Container(child: Image.file(fileMedia!,height: 200,))
                    : Container(child: VideoWidget(fileMedia!))),
              ]),
            ],
          ),
        ),
      ),
    );
  }
  //******************************************************************************
  Widget Buildbutton() {
    return CustomButton(
          () {
            updatedatabase();
      },
      color: HexColor("#3593FF"),
      height: 40,
      width: 100,
      radius: 15,
      text: "PUBLISH",
      textColor: Colors.white,
    );
  }

  //database
  updatedatabase() async {
    final ref=_fireStore.collection("Posts");
      ref.get().then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((DocumentSnapshot doc) {
          
        });
      });
    DocumentReference doc = _fireStore.collection("Posts").doc();
    _fireStore.collection("Users").get().then((value)=>{
      value.docs.forEach((element) {
        try {
          doc.update({
            "context": {
              "duration": DateTime.now(),
              "productPrice": priceController.text,
              "live": false,
              //"imagepath": path,
              "imagepathhh": fileMedia?.path,
              "text": postController.text,
            },
            "id": doc.id,
            "likes": [],
            "postType": "TextPostWithShop",
            "shares": 0,
            "time": DateTime.now(),
            "uid": signInUser.uid,
            "nameii": signInUser.displayName,
            "userimage":element.data()["profileImage"],
            "email": signInUser.email,
          }).then((value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false);
          });
        } catch (e) {
          print(e.toString());
        }
      }
      )
    });
  }
  deletedatabase()async{
    DocumentReference doc = _fireStore.collection("Posts").doc();
    doc.delete();
  }
  Future<bool> dialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: HexColor("#f7b6b8").withOpacity(.8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          content: Container(
            height: 80,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Are you sure you want discard this post",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.all(10),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 10,
                ),
                CustomButton(
                      () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                            (route) => false);
                  },
                  color: HexColor("#3593FF"),
                  height: 50,
                  text: "Yes",
                  textColor: Colors.white,
                  width: 100,
                ),
                SizedBox(
                  width: 10,
                ),
                CustomButton(
                      () {
                    Navigator.pop(context);
                  },
                  color: Colors.red,
                  height: 50,
                  text: "No",
                  textColor: Colors.white,
                  width: 100,
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        );
      },
    );
    return await true;
  }
  Future capture(MediaSource source) async {
    setState(() {
      this.source = source;
      this.fileMedia = null;
    });

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SourcePage(),
        settings: RouteSettings(
          arguments: source,
        ),
      ),
    );

    if (result == null) {
      return;
    } else {
      setState(() {
        fileMedia = result;
      });
    }
  }
  Future showDialogOfPost(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.pinkAccent,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  const BorderRadius.all(const Radius.circular(20.0))),
              content: Container(
                width: 260.0,
                height: MediaQuery.of(context).size.height / 1.7,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.blue[900],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: (){
                        capture(MediaSource.image);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.photo,
                            color: Colors.blue,
                          ),
                          Text(
                            "Select Picture",
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      onTap: (){
                        capture(MediaSource.video);

                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.video_collection,
                            color: Colors.blue,
                          ),
                          Text(
                            "Select Video",
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                  ],
                ),
              ));
        });
  }

}
