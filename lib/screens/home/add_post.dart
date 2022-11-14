import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sls/screens/home/home_Screen.dart';
import 'package:sls/screens/videosource/source_page.dart';
import 'package:sls/screens/widget/video_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import '../../contance.dart';
import '../../model/media_source.dart';
import '../../model/user_model.dart';
import '../../providers/user_provider.dart';
import '../../shared/netWork/local/cache_helper.dart';
import '../go_live_screen.dart';
import '../widget/custom_button.dart';
import 'package:path_provider/path_provider.dart';
import '../notification/notification_screen.dart';
import '../service/localnotificationscreen.dart';

class AddPost extends StatefulWidget {

  static String routeName = '/addpost';

  @override
  State<AddPost> createState() => AddPostState();
}

class AddPostState extends State<AddPost> {
  String PostId = Uuid().v4();
  String likes = Uuid().v4();
 List<String>img=[];
  // final FirebaseMessaging fcm=FirebaseMessaging();
  TextEditingController quantityController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final _fireStore = FirebaseFirestore.instance;
  List<Uint8List>? photos;
  bool isfollow = true;
  String? path, videoath;
  bool islike = false;

  final _auth = FirebaseAuth.instance;
  File? _image;
  bool click = true;
  PickedFile? pickedFile;
  final picker = ImagePicker();
  late User signInUser;
  late VideoPlayerController _videoPlayerController;
  String? pp;
  late final LocalNotificationService service;
  @override
  void initState() {
    getCurrentUser();
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    super.initState();
    pp = fileMedia?.path;
    _videoPlayerController = VideoPlayerController.file(_image ?? File(""))
      ..initialize().then((_) {
        setState(() {});
      });
  }

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

  File? fileMedia;
  MediaSource? source;
 String isseller="";
  void checkseller()async{
    final DocumentSnapshot getuserdoc= await FirebaseFirestore.instance.collection('Users')
        .doc(signInUser.uid).get();
     isseller= getuserdoc['role'];

  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserProvider>(context, listen: false);
    final Stream<QuerySnapshot> _postStream =
    FirebaseFirestore.instance.collection('Post').snapshots();

    return WillPopScope(
      onWillPop: () {
        dialog();
        return dialog();
      },
      child: Scaffold(
          backgroundColor: HexColor("#f7b6b8"),
          body: StreamBuilder(
              stream: _postStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.separated(
                    itemCount: 1,
                    separatorBuilder: (BuildContext context, int index) {
                      return Container();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      String username=snapshot.data?.docs[index]["userName"];
                      String userid=snapshot.data?.docs[index]["uid"];
                      return Column(
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
                                      fontSize: 25),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: IconButton(
                                    onPressed: () {
                                      dialog();
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.indigo,
                                    )),
                              )
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
                                  child: Buildbutton(username),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20),
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
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1.5),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 30)),
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),

                              Visibility(
                                visible: isseller=="seller"?true:false,
                                child: SizedBox(
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
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Colors.pinkAccent,
                                              width: 1.5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Colors.pinkAccent,
                                              width: 1.5),
                                        ),
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 30)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Visibility(
                                visible: true,
                                child: SizedBox(
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
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Colors.pinkAccent,
                                              width: 1.5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Colors.pinkAccent,
                                              width: 1.5),
                                        ),
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 10),
                                        suffixIcon: Icon(
                                          CupertinoIcons.money_euro,
                                          color: Colors.pinkAccent,
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
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
                                  },
                                  child: Icon(
                                    CupertinoIcons.photo_on_rectangle,
                                    color: Colors.blue,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 70,
                          ),
                          Column(children: [

                            fileMedia == null
                                ? Icon(
                                    Icons.photo,
                                    size: 120,
                                    color: HexColor("#f7b6b8"),
                                  )
                                : (source == MediaSource.image
                                    ? Container(
                                        child: Image.file(
                                        fileMedia!,
                                        height: 400,
                                        width: 300,
                                      ))
                                    : Container(
                                        child: VideoWidget(fileMedia!),
                                        height: 400,
                                        width: 300,
                                      )),
                          ]),
                        ],
                      );
                    });
              })),
    );
  }

  //******************************************************************************
  Widget Buildbutton(String id) {
    return CustomButton(
      () {
// if(signInUser.uid==id)
//   {
//    return updatedatabase(context, id);
//   }else {
//   return
    database(context);
//}
},
      color: HexColor("#3593FF"),
      height: 40,
      width: 100,
      radius: 15,
      text: "PUBLISH",
      textColor: Colors.white,
    );
  }
  Future<String?> uploadeImage(File file,String id) async {
    final storageRef = FirebaseStorage.instance.ref();
    String? dowurl;
    //Upload the file to firebase
    Reference reference =
    storageRef.child('PostsRefs/"${id}"/images/${file.path.split('/').last}');
    UploadTask uploadTask = reference.putFile(file);
    dowurl = await (await uploadTask).ref.getDownloadURL();
    return dowurl;
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
  //database
  database(BuildContext context) async {


    final userr = Provider.of<UserProvider>(context, listen: false);
    FirebaseFirestore.instance.collection("Notifications").doc().set({"data":"add post","relatedinfo":{"postId": "", "orderNo": ''},"seen": false,"topic": "add post","time": "${DateTime.now()}","senderInfoo":{"userName": userr.user.name??" ", "uid": userr.user.uId??" ", "userImg": userr.user.photo??" ",}});
    await service.showNotification(
        id:0 ,
        title: 'New Post',
        body: '${userr.user.name} Add new post');
    //Context contextmodel=Context(text: postController.text,productPrice: priceController.text,images: [],video: "",videoPreview: "",views: "${0}");
    DocumentReference doc = _fireStore.collection("Post").doc();
   uploadeImage(fileMedia??File(""), doc.id).then((value){
           img.add(value!);
            try {
             //  PostModel postmodel=PostModel(context: Context(images: img,productPrice:priceController.text,text:postController.text ),
             //      comments: 0,likes: [],postType:"TextPostWithShop",
             //      time: "${DateTime.now()}",uid:signInUser.uid,id: doc.id,shares:0,userName:userr.user.name ?? " ",email:signInUser.email,profile: userr.user.photo ?? " null "   );
             // doc.set(postmodel).then((value) {
             //     Navigator.pushAndRemoveUntil(
             //         context,
             //         MaterialPageRoute(builder: (context) => HomeScreen()),
             //             (route) => false);
             //   });

              doc.set({

                "id": doc.id,
                "comment":'${CacheHelper.getInt(key:"commentpost")}',
                "likes": [],
                "time": DateTime.now(),
                "img":value,
                "context":{
                  "text":postController.text,
                  "productprice":priceController.text
                },
                "uid": signInUser.uid,
                "userName": userr.user.name ?? " ",
                "email": signInUser.email,
                "profile": userr.user.photo ?? " null ",
                "postType":"TextPostWithShop"
              }).then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false);
              });
            }
            catch (e) {
              print(e.toString());
            }
   });


              // PostModel postmodel=PostModel(
              //     comments: 0,likes: [],postType:"TextPostWithShop",
              //     time: "${DateTime.now()}",uid:signInUser.uid,id: doc.id,shares:0 );
              // doc.set(postmodel).then((value) {
              //   Navigator.pushAndRemoveUntil(
              //       context,
              //       MaterialPageRoute(builder: (context) => HomeScreen()),
              //           (route) => false);
              // });
              // doc.update({
              //   "imagepost": value,
              //   "profile":userr.user.photo,
              //   "email": signInUser.email,
              // }).then((value) {
              //   Navigator.pushAndRemoveUntil(
              //       context,
              //       MaterialPageRoute(builder: (context) => HomeScreen()),
              //       (route) => false);
              // });

//});
        //   })
        // });
  }

  //database
  updatedatabase(BuildContext context, String id) async {
    String? currentname = signInUser.displayName;
    final userr = Provider.of<UserProvider>(context, listen: false);
    DocumentReference doc = _fireStore.collection("Post").doc(id);
    //_fireStore.collection("Users").get().then((value)=>{
    //value.docs.forEach((element) {
    try {
      doc.update({
        "context": {
          "duration": DateTime.now(),
          "productPrice": priceController.text,
          "imagepathhh": fileMedia?.path,
          "text": postController.text,
        },
        "id": doc.id,
        "likes": [],
        "time": DateTime.now(),
        "uid": signInUser.uid,
        "userName": currentname ?? " ",
        "confirmState": userr.user.confirmState,
        "userimage": usermodel?.photo,
        "email": signInUser.email,
        "profile": userr.user.photo ?? " null ",
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

  UserModel? usermodel;

  Future<UserModel?> readUser() async {
    final docUser = FirebaseFirestore.instance
        .collection("Users")
        .doc(CacheHelper.getData(key: "uId"));
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      usermodel = UserModel.fromJson(snapshot.data());
      return usermodel;
    } else {
      return UserModel(name: '');
    }
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
              backgroundColor: HexColor("#f7b6b8"),
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(20.0))),
              content: Container(
                width: 260.0,
                height: MediaQuery.of(context).size.height / 2.7,
                decoration: BoxDecoration(
                  color: HexColor("#f7b6b8"),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.blue[900],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
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
                          onTap: () {
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
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}
