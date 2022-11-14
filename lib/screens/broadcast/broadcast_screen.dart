import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sls/screens/widget/custom_button.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../../config/appId.dart';
import '../../model/user_model.dart';
import '../../providers/user_provider.dart';
import '../../resources/firestore_methods.dart';
import '../../responsive/resonsive_layout.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtc_engine/media_recorder.dart' as media_recorder;
import '../../shared/netWork/local/cache_helper.dart';
import '../home/add_post.dart';
import 'package:path/path.dart' as path;
import '../notification/notification_screen.dart';
import '../service/localnotificationscreen.dart';
import '../home/home_Screen.dart';
import '../widget/custom_text.dart';

class BroadcastScreen extends StatefulWidget {
  final bool isBroadcaster;
  final String channelId;
  final String userid;

  BroadcastScreen({
    required this.isBroadcaster,
    required this.channelId,
    this.userid = " ",
  });

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  RtcEngine? _engine;
  List<int> remoteUid = [];
  bool switchCamera = true;
  bool isMuted = false;
  File? videofile;
  media_recorder.MediaRecorder? mediaRecorder;
  bool isswitch = false;
  bool isScreenSharing = false;
  bool isopen = false;
  File? imgfile;
  List<String> Screenshotsimgs = [];
  double size = 45;
  bool isliked = false;
  int likecount = 0;
  bool checkboxvalue = false;
  bool isenabled = true;
  TextEditingController priceController = TextEditingController();
  bool commentvisible = true;
  int count = 0;
  late final LocalNotificationService service;

  // Add the link to the deployed server
  String rid = "";
  String sid = "";
  final TextEditingController _chatController = TextEditingController();
  bool _isStartedMediaRecording = false;
  String _recordingFileStoragePath = '';
  int recUid = 0;
  Duration duration = Duration();
  Timer? timer;
  final screenshotcontroller = ScreenshotController();
  bool isbroad = true;

  @override
  void initState() {
    Permission.storage.request();
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    super.initState();
    _initEngine();
    //_startMediaRecrding();

    // _startMedaRecordig();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
    _chatController.dispose();
  }

  void _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _addListeners();

    await _engine?.enableVideo();
    await _engine?.startPreview();
    await _engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);

    if (widget.isBroadcaster) {
      _engine?.setClientRole(ClientRole.Broadcaster);
    } else {
      _engine?.setClientRole(ClientRole.Audience);
    }
    _joinChannel();
  }

  String baseUrl = "https://twitch-tutorial-server.herokuapp.com";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? token;
  Uint8List? image;

  //+++++++++++++++++++
  String recorddd = "";
  final capttureimg = File('');

  Future<File?> _startMediaRecording() async {
    //  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    media_recorder.MediaRecorderObserver observer =
        media_recorder.MediaRecorderObserver(
      onRecorderStateChanged: (RecorderState state, RecorderErrorCode error) {
        print('onRecorderStateChanged state: $state, error: $error');
      },
      onRecorderInfoUpdated: (RecorderInfo info) async {
        print('onRecorderInfoUpdated info: ${info.toJson()}');
      //  final user = Provider.of<UserProvider>(context, listen: false);
        videofile = File(info.fileName);
        await FirestoreMethods()
            .startLiveStream(context, widget.userid, true, info.fileName);
        // final ref = FirebaseStorage.instance
        //     .ref("livestreamvideorecord/${user.user.uId}${user.user.name}");
        // final storageRef = FirebaseStorage.instance.ref();
        // UploadTask uploadTask =
        //     ref.putFile(videofile!, SettableMetadata(contentType: 'video/mp4'));
        // File file = File(info.fileName);
        // Reference reference =
        // storageRef.child('UsersRefs/${file.path.split('/').last}');
        // UploadTask uploaddTask = reference.putFile(file);
        // String dowurl = await (await uploadTask).ref.getDownloadURL();
        //
        // //return dowurl;

        // print("uploading");
        // uploadTask.whenComplete(() async {
        //   String downloadUrl = await ref.getDownloadURL();
        //   print("download url: $downloadUrl");
        // });
        // GallerySaver.saveVideo(info.fileName).then((value) {
        //   print("done");
        //   File file = File(info.fileName);
        // });
      },
    );
    // await FirestoreMethods()
    //     .startLiveStream(context, widget.userid, true, recorddd);
    mediaRecorder = media_recorder.MediaRecorder.getMediaRecorder(
      _engine!,
      callback: observer,
    );

    Directory appDocDir = Platform.isAndroid
        ? (await getExternalStorageDirectory())!
        : await getApplicationDocumentsDirectory();
    String p = path.join(appDocDir.path, 'testing.mp4');

    await mediaRecorder?.startRecording(MediaRecorderConfiguration(
        storagePath: p, containerFormat: MediaRecorderContainerFormat.MP4));
    // sharedPreferences.setString("finalrecord", p);
    setState(() {
      _recordingFileStoragePath = 'Recording file storage path: $p';
      _isStartedMediaRecording = true;
    });
    return videofile;
  }

//***************************
//   Future<void> _startMedaRecordig() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     media_recorder.MediaRecorderObserver observer =
//         media_recorder.MediaRecorderObserver(
//       onRecorderStateChanged: (RecorderState state, RecorderErrorCode error) {
//         print('onRecorderStateChanged state: $state, error: $error');
//       },
//       onRecorderInfoUpdated: (RecorderInfo info) async {
//         print('onRecorderInfoUpdated info: ${info.toJson()}');
//         final user = Provider.of<UserProvider>(context, listen: false);
//         videofile = File(info.fileName);
//         sharedPreferences.setString("recorrd", info.fileName);
//         // await _firestore
//         //     .collection('livestreamimage')
//         //     .doc(widget.userid)
//         //     .update({
//         //   'record': info.fileName,
//         // });
//         // await FirestoreMethods()
//         //     .startLiveStream(context, widget.userid, true, info.fileName);
//         // _firestore
//         //     .collection('livestreamimage')
//         //     .doc(widget.userid)
//         //     .update({"videorecord": videofile, "hkh": "jk"});
//         videofile = File(info.fileName);
//         //  String? videorecord=videofile?.path;
//         // CacheHelper.putString(key:"videofile", value: videorecord??"mnknjn"+"nknkj");
//         final ref = FirebaseStorage.instance.ref("livestreamvideo/hgff");
//         UploadTask uploadTask =
//             ref.putFile(videofile!, SettableMetadata(contentType: 'video/mp4'));
//         print("uploading");
//         uploadTask.whenComplete(() async {
//           String downloadUrl = await ref.getDownloadURL();
//           print("download url: $downloadUrl");
//         });
//
//         //  final ref=FirebaseStorage.instance.ref().child();
//
//         // GallerySaver.saveVideo(info.fileName).then((value) {
//         //   print("done");
//         // });
//       },
//     );
//
//     mediaRecorder = media_recorder.MediaRecorder.getMediaRecorder(
//       _engine!,
//       callback: observer,
//     );
//
//     Directory appDocDir = Platform.isAndroid
//         ? (await getExternalStorageDirectory())!
//         : await getApplicationDocumentsDirectory();
//     String p = path.join(appDocDir.path, 'testing.mp4');
//
//     await mediaRecorder?.startRecording(MediaRecorderConfiguration(
//         storagePath: p, containerFormat: MediaRecorderContainerFormat.MP4));
//
//     setState(() {
//       _recordingFileStoragePath = 'Recording file storage path: $p';
//       _isStartedMediaRecording = true;
//     });
//   }

  Future<void> _stopMediaRecording() async {
    await mediaRecorder?.stopRecording();
    setState(() {
      _recordingFileStoragePath = '';
      _isStartedMediaRecording = false;
    });
  }

  Future<void> getToken() async {
    final res = await http.get(
      Uri.parse(baseUrl +
          '/rtc/' +
          widget.channelId +
          '/publisher/userAccount/' +
          Provider.of<UserProvider>(context, listen: false).user.uId! +
          '/'),
    );

    if (res.statusCode == 200) {
      setState(() {
        token = res.body;
        token = jsonDecode(token!)['rtcToken'];
      });
    } else {
      debugPrint('Failed to fetch the token');
    }
  }

  //*********
  Future<void> _startRecording(String channelName) async {
    final response = await http.post(
      Uri.parse(baseUrl + '/api/start/call'),
      body: {"channel": channelName},
    );

    if (response.statusCode == 200) {
      print('Recording Started');
      setState(() {
        rid = jsonDecode(response.body)['data']['rid'];
        recUid = jsonDecode(response.body)['data']['uid'];
        sid = jsonDecode(response.body)['data']['sid'];
      });
    } else {
      print('Couldn\'t start the recording : ${response.statusCode}');
    }
  }

  Future<void> _stopRecording(
      String mChannelName, String mRid, String mSid, int mRecUid) async {
    final response = await http.post(
      Uri.parse(baseUrl + '/api/stop/call'),
      body: {
        "channel": mChannelName,
        "rid": mRid,
        "sid": mSid,
        "uid": mRecUid.toString()
      },
    );

    if (response.statusCode == 200) {
      print('Recording Ended');
    } else {
      print('Couldn\'t end the recording : ${response.statusCode}');
    }
  }

  //***
  void _addListeners() {
    _engine?.setEventHandler(
        RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
      debugPrint('joinChannelSuccess $channel $uid $elapsed');
    }, userJoined: (uid, elapsed) {
      debugPrint('userJoined $uid $elapsed');
      setState(() {
        remoteUid.add(uid);
      });
    }, userOffline: (uid, reason) {
      debugPrint('userOffline $uid $reason');
      setState(() {
        remoteUid.removeWhere((element) => element == uid);
      });
    }, leaveChannel: (stats) {
      debugPrint('leaveChannel $stats');
      setState(() {
        remoteUid.clear();
      });
    }, tokenPrivilegeWillExpire: (token) async {
      await getToken();
      await _engine?.renewToken(token);
    }));
  }

  void _joinChannel() async {
    await getToken();
    if (token != null) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await [Permission.microphone, Permission.camera].request();
      }
      await _engine?.joinChannelWithUserAccount(
        token,
        widget.channelId,
        Provider.of<UserProvider>(context, listen: false).user.uId!,
      );
    }
  }

  void _switchCamera() {
    _engine?.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      debugPrint('switchCamera $err');
    });
  }

  void onToggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _engine?.muteLocalAudioStream(isMuted);
  }

  _leaveChannel() async {
    await _engine?.leaveChannel();
    if ('${Provider.of<UserProvider>(context, listen: false).user.uId!}' ==
        widget.userid) {
      await FirestoreMethods().endLiveStream(widget.userid, context);
    } else {
      await FirestoreMethods().updateViewCount(widget.userid, false);
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HomeScreen(broadcast: widget.isBroadcaster),
      ),
    );
  }

  Widget buildTime() {
    String twodigits(int n) => n.toString().padLeft(2, '0');
    final hours = twodigits(duration.inHours.remainder(60));
    final minutes = twodigits(duration.inMinutes.remainder(60));
    final seconds = twodigits(duration.inSeconds.remainder(60));

    return Row(
      children: [
        buildcard(time: '$hours', header: "hours"),
        SizedBox(
          width: 5,
        ),
        buildcard(time: '$minutes:', header: "minutes"),
        SizedBox(
          width: 5,
        ),
        buildcard(time: '$seconds', header: "second"),
      ],
    );
  }

  void addTime() {
    final addseconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addseconds;
      duration = Duration(seconds: seconds);
    });
  }

  void starttimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  Widget buildcard({required String time, required String header}) => Text(
        time,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
      );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    final userperson = Provider.of<UserProvider>(context).user;
    final userProvider = Provider.of<UserProvider>(context);
    final size = MediaQuery.of(context).size;
    userperson.photo;
    return WillPopScope(
        onWillPop: () async {
          await _leaveChannel();
          return Future.value(true);
        },
        child: Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(8),
          child: ResponsiveLatout(
            desktopBody: Row(
              children: [
                Screenshot(
                  controller: screenshotcontroller,
                  child: Expanded(
                    child: Stack(
                      children: [
                        _renderVideo(userperson, isScreenSharing),
                        if ("${userperson.uId}${userperson.name}" ==
                            widget.channelId)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: _switchCamera,
                                child: isswitch
                                    ? Icon(
                                        Icons.linked_camera_outlined,
                                        color: Colors.red,
                                      )
                                    : Icon(Icons.flip_camera_ios_outlined,
                                        color: Colors.grey),
                              ),
                              InkWell(
                                onTap: onToggleMute,
                                child: isMuted
                                    ? Icon(
                                        Icons.mic_none,
                                        color: Colors.red,
                                      )
                                    : Icon(Icons.mic_off_outlined,
                                        color: Colors.red),
                              ),
                              InkWell(
                                onTap: widget.isBroadcaster
                                    ? () {
                                        _leaveChannel();
                                        // _stopMediaRecording();
                                      }
                                    : null,
                                child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 35,
                                    child: Icon(
                                      Icons.call,
                                      color: Colors.white,
                                    )),
                              ),
                            ]
                          ),
                      ],
                    ),
                  ),
                ),
                // Chat(channelId: widget.channelId),
              ],
            ),
            mobileBody: Screenshot(
              controller: screenshotcontroller,
              child: Stack(children: [
                _renderVideo(userperson, isScreenSharing),
                if ("${userperson.uId}${userperson.name}" == widget.channelId)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                                radius: 30,
                                backgroundColor:  Colors.grey[200],
                                child: Image.network(
                                    userperson.photo ?? "nulllllllll")),
                            SizedBox(height: 80),
                            image != null
                                ? Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.memory(image!))
                                : Container(height: 0, width: 0),
                          ],
                        ),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height:20,
                              decoration: BoxDecoration(
                                  border: Border(
                                      top:
                                      BorderSide(color: Colors.white),
                                      right:
                                      BorderSide(color: Colors.white),
                                      left:
                                      BorderSide(color: Colors.white),
                                      bottom: BorderSide(
                                          color: Colors.white)),
                                  borderRadius:
                                  BorderRadius.circular(10)),
                              child: Text(
                                userperson.name ?? "nullll ", style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(height:3),
                            Row(
                              children: [
                                Container(
                                    height: 30,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                        // border: Border(
                                        //     top:
                                        //         BorderSide(color: Colors.white),
                                        //     right:
                                        //         BorderSide(color: Colors.white),
                                        //     left:
                                        //         BorderSide(color: Colors.white),
                                        //     bottom: BorderSide(
                                        //         color: Colors.white))
                                                ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "live ",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        buildTime(),
                                      ],
                                    )),
                                SizedBox(width: 3),

                                Container(
                                    height: 30,

                                    decoration: BoxDecoration(
                                        border: Border(
                                            top:
                                            BorderSide(color: Colors.white),
                                            right:
                                            BorderSide(color: Colors.white),
                                            left:
                                            BorderSide(color: Colors.white),
                                            bottom: BorderSide(
                                                color: Colors.white)),
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "${0}",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                                SizedBox(width: 3),
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(color: Colors.white),
                                          right:
                                          BorderSide(color: Colors.white),
                                          left: BorderSide(color: Colors.white),
                                          bottom:
                                          BorderSide(color: Colors.white)),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: LikeButton(
                                    size: 20.0,
                                    likeCount: likecount,
                                    likeBuilder: (isLiked) {
                                      final color =
                                      isliked ? Colors.red : Colors.white;
                                      return Icon(
                                        Icons.favorite_outline_rounded,
                                        color: color,
                                        size: 20.0,
                                      );
                                    },
                                    likeCountPadding: EdgeInsets.only(left: 12),
                                    onTap: (isliked) async {
                                      this.isliked = !isliked;
                                      likecount += this.isliked ? 1 : -1;
                                      return !isliked;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ConstrainedBox(
                  constraints: BoxConstraints.tightForFinite(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80.0, left: 350),
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn,
                          height: isopen ? 300 : 50,
                          width: 50,
                          decoration: ShapeDecoration(shape: StadiumBorder()),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 25, left: 3),
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: AnimatedCrossFade(
                            secondChild: IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_up_sharp,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                toggleopen();
                              },
                            ),
                            crossFadeState: !isopen
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: Duration(milliseconds: 250),
                            firstChild: IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down_sharp,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                toggleopen();
                              },
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: isopen ? 1 : 0,
                          duration: Duration(milliseconds: 400),
                          child: Container(
                            padding: EdgeInsets.only(top: 50),
                            height: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: widget.isBroadcaster,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5, left: 3),
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      icon: isswitch
                                          ? Icon(
                                              Icons.camera_front,
                                              color: Colors.black,
                                            )
                                          : Icon(Icons.switch_camera_outlined,
                                              color: Colors.black),
                                      onPressed: () {
                                        setState(() {
                                          _switchCamera();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                    icon: commentvisible
                                        ? Icon(
                                            Icons.insert_comment_rounded,
                                            color: Colors.black,
                                          )
                                        : Icon(
                                            Icons.comments_disabled_rounded,
                                            color: Colors.black,
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        commentvisible = !commentvisible;
                                      });
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: widget.isBroadcaster,
                                  child: Container(
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.fullscreen_sharp,
                                        color: Colors.black,
                                      ),
                                      onPressed: () async {
                                        image = await screenshotcontroller
                                            .capture();

                                        _saved(image);
                                        // String? img = await NativeScreenshot
                                        //     .takeScreenshot();
                                        // final capttureimg =
                                        //     await screenshotcontroller.capture();

                                        // if (img != null) {
                                        //   setState(() {
                                        //     debugPrint("${imgfile?.path.toString()}***********pppppppppp");
                                        //     imgfile = File(img);
                                        //  // Screenshotsimgs.add(imgfile!.path);
                                        //   });
                                        // } else {
                                        //   debugPrint("error999999999999999999999999999999999999999");
                                        // }
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: widget.isBroadcaster,
                                  child: Container(
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.table_rows_outlined,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          orderdialog();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: widget.isBroadcaster,
                                  child: Container(
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      icon: isMuted
                                          ? Icon(
                                              Icons.mic_off_outlined,
                                              color: Colors.black,
                                            )
                                          : Icon(Icons.mic_none,
                                              color: Colors.black),
                                      onPressed: () {
                                        setState(() {
                                          onToggleMute();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 230),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: StreamBuilder<dynamic>(
                              stream: FirebaseFirestore.instance
                                  .collection('Post')
                                  .doc(CacheHelper.getString(key: "liveid"))
                                  .collection("commentslive")
                                  .orderBy('createdAt', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                return Visibility(
                                  visible: commentvisible,
                                  child: ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) => ListTile(
                                      title: Row(
                                        children: [
                                          CircleAvatar(
                                              radius: 8,
                                              backgroundColor:
                                                  Colors.grey[200],
                                              child: Image.network(snapshot.data
                                                      .docs[index]['photo'] ??
                                                  "nullll")),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            snapshot.data.docs[index]
                                                ['username'],
                                            style: TextStyle(
                                              color: snapshot.data.docs[index]
                                                          ['uid'] ==
                                                      userProvider.user.uId
                                                  ? Colors.blue
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: [
                                          SizedBox(
                                            width: 3,
                                          ),
                                          CustomText(text:
                                            snapshot.data.docs[index]
                                                ['message'],
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:5.0,right:0.0,bottom:5.0),
                                      child: TextFormField(
                                        controller: _chatController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "*Required";
                                          }
                                          return null;
                                        },
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          suffixIcon: InkWell(
                                            onTap:()async{
                                              await FirestoreMethods().chat(_chatController.text, context);
                                              _chatController.clear();
                                            },
                                            child: CircleAvatar(
                                                radius: .5,
                                                backgroundColor: HexColor("#f7b6b8"),
                                                child: Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                )),
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText: "Say something...",
                                              hintStyle: TextStyle(
                                                backgroundColor:Colors.grey[200] ,
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                          prefixIcon: Icon(
                                            Icons.emoji_emotions,
                                            color: HexColor("#f7b6b8"),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                  color: Colors.white)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                  color: Colors.white)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              borderSide: BorderSide(
                                                  color: Colors.white)),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 18.0),
                                        ),
                                      ),
                                    ),
                                ),
                                // Expanded(
                                //   flex:1,
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(
                                //         bottom: 15.0, left: 5, right: 5),
                                //     child: Container(
                                //       width: double.infinity,
                                //       decoration: BoxDecoration(
                                //         color: Colors.red,
                                //         borderRadius: BorderRadius.circular(10),
                                //       ),
                                //       child: Padding(
                                //         padding: const EdgeInsets.all(5.0),
                                //         child: Row(
                                //           children: [
                                //             Icon(
                                //               Icons.live_tv_sharp,
                                //               color: Colors.white,
                                //             ),
                                //             InkWell(
                                //               onTap: () {
                                //                 dialog();
                                //               },
                                //               child: Text(
                                //                 "Disconnected".toUpperCase(),
                                //                 style: TextStyle(
                                //                     color: Colors.white),
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Visibility(
                                  visible: widget.isBroadcaster,
                                  child: Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5.0, left: 5, right: 5),
                                      child: Container(
                                           height: 60,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.live_tv_sharp,
                                                color: Colors.white,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  if (isbroad == true) {
                                                    isbroad = false;
                                                    _firestore
                                                        .collection(
                                                            "Notifications")
                                                        .doc()
                                                        .set({
                                                      "data": "Is live now",
                                                      "relatedinfo": {
                                                        "postId": "",
                                                        "orderNo": ''
                                                      },
                                                      "seen": false,
                                                      "topic": "live",
                                                      "time":
                                                          "${DateTime.now()}",
                                                      "senderInfoo": {
                                                        "userName": userProvider
                                                                .user.name ??
                                                            " ",
                                                        "uid": userProvider
                                                                .user.uId ??
                                                            " ",
                                                        "userImg": userProvider
                                                                .user.photo ??
                                                            " ",
                                                      }
                                                    });
                                                    await service.showNotification(
                                                        id: 0,
                                                        title: 'Live ',
                                                        body:
                                                            '${user.user.name} Is Live Now');
                                                    _startMediaRecording();
                                                    starttimer();
                                                    // });
                                                  } else {
                                                    dialog();
                                                  }
                                                },
                                                child: isbroad
                                                    ? Text(
                                                        "broadcast"
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : Text(
                                                        "Disconnected"
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ]),
            ),
          ),
        )));
  }

  takescreeho() async {
    final immgfile = await screenshotcontroller.capture();
  }

  toggleopen() {
    setState(() {
      isopen = !isopen;
    });
  }

  toggleenabletext() {
    setState(() {
      isenabled = !isenabled;
    });
  }

  _renderVideo(user, isScreenSharing) {
    return AspectRatio(
      aspectRatio: 16 / 32,
      // Unhandled Exception: PlatformException(-4, not supported, null, null)
      child: "${user.uId}${user.name}" == widget.channelId
          ? isScreenSharing
              ? kIsWeb
                  ? const RtcLocalView.SurfaceView.screenShare()
                  : const RtcLocalView.TextureView.screenShare()
              : const RtcLocalView.SurfaceView(
                  zOrderMediaOverlay: true,
                  zOrderOnTop: true,
                )
          : isScreenSharing
              ? kIsWeb
                  ? const RtcLocalView.SurfaceView.screenShare()
                  : const RtcLocalView.TextureView.screenShare()
              : remoteUid.isNotEmpty
                  ? kIsWeb
                      ? RtcRemoteView.SurfaceView(
                          uid: remoteUid[0],
                          channelId: widget.channelId,
                        )
                      : RtcRemoteView.TextureView(
                          uid: remoteUid[0],
                          channelId: widget.channelId,
                        )
                  : Container(),
    );
  }

  Future<bool> dialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
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
                  "Are you sure you want to end this live",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
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
                    if (widget.isBroadcaster) {
                      Navigator.pop(context);
                      //finaldialog();

                        _leaveChannel();
                        _stopMediaRecording();

                    }
                  },
                  color: Colors.blue,
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

  String equation = "0";

  buttonpressed(String buttonval) {
    setState(() {
      if (buttonval == "C") {
      } else if (buttonval == "⌫") {
        equation = equation.substring(0, equation.length - 1);
        if (equation == " ") {
          equation = "0";
        }
      } else if (buttonval == "=") {
      } else {
        if (equation == "0") {
          equation = buttonval;
        } else {
          equation = equation + buttonval;
        }
      }
    });
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');

      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => NotificationScreen())));
    }
  }

  Widget buildbtn(String text, Function fun) {
    return Expanded(
        flex: 1,
        child: InkWell(
            onTap: () => fun(),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              radius: 20,
            )));
  }

  Future<bool> orderdialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: 300,
          height: 250,
          child: AlertDialog(
            backgroundColor: Colors.black,
            title: Row(
              //    mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            content: Container(
              height: 280,
              child: Column(
                children: [
                  TextFormField(
                    controller: priceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "*Required";
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      fillColor: Colors.grey,
                      focusColor: Colors.grey,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.white)),
                      contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                priceController.text += "1";
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                radius: 20,
                              ))),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                priceController.text += "2";
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                radius: 20,
                              ))),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                priceController.text += "3";
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  "3",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                radius: 20,
                              ))),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                priceController.text += "4";
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  "4",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                radius: 20,
                              ))),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                priceController.text += "5";
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  "5",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                radius: 20,
                              ))),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                priceController.text += "6";
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  "6",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                radius: 20,
                              ))),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                priceController.text += "7";
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  "7",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                radius: 20,
                              ))),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                priceController.text += "8";
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  "8",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                radius: 20,
                              ))),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                priceController.text += "9";
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  "9",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                radius: 20,
                              ))),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                priceController.text += "\.";
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  ".",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                radius: 20,
                              ))),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                priceController.text += "0";
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  "0",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                radius: 20,
                              ))),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                              onTap: () {
                                priceController.text += priceController.text
                                    .substring(
                                        0, priceController.text.length - 1);
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Text(
                                  "⌫",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                radius: 20,
                              ))),
                    ],
                  ),
                ],
              ),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: [
              CustomButton(() {
                _firestore
                    .collection('livestream')
                    .doc(widget.channelId)
                    .update({
                  "price": priceController.text,
                  "order number": count++
                });
                smallpricedialog();
              },
                  text: "ok",
                  textColor: Colors.white,
                  color: Colors.blue,
                  radius: 5),
              SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
    );
    return await true;
  }

  Future<bool> finaldialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 200,
            width: double.infinity,
            child: AlertDialog(
              backgroundColor: Colors.black.withOpacity(.5),
              title: Row(
                //mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Live has ended",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: HexColor("#f7b6b8")),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    color: Colors.blue,
                    height: 3,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
              // content: Container(
              //   height: 120,
              //   child: Column(
              //     children: [
              //       SizedBox(
              //         height: 20,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             "Earning",
              //             style: TextStyle(
              //                 fontSize: 20,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //           Text(
              //             "${0}",
              //             style: TextStyle(
              //                 fontSize: 20,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: 10,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             "Orders",
              //             style: TextStyle(
              //                 fontSize: 20,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //           Text(
              //             "${0}",
              //             style: TextStyle(
              //                 fontSize: 20,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: 10,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             "Views",
              //             style: TextStyle(
              //                 fontSize: 20,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //           Text(
              //             "${0}",
              //             style: TextStyle(
              //                 fontSize: 20,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: 20,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             "Duration",
              //             style: TextStyle(
              //                 fontSize: 20,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //           Text(
              //             "${0}",
              //             style: TextStyle(
              //                 fontSize: 20,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // contentPadding: EdgeInsets.all(10),
              actions: [
                // Column(
                //   children: [
                //     Container(
                //       width: double.infinity,
                //       padding: EdgeInsets.symmetric(horizontal: 15),
                //       color: Colors.blue,
                //       height: 3,
                //     ),
                //     SizedBox(
                //       height: 10,
                //     ),
                //     Row(
                //       children: [
                //         Text("Add to My Stream"),
                //         Checkbox(
                //             value: checkboxvalue,
                //             onChanged: (val) {
                //               setState(() {
                //                 checkboxvalue = val!;
                //               });
                //             }),
                //       ],
                //     ),
                //     SizedBox(
                //       height: 10,
                //     ),
                //     CustomButton(
                //       () {
                //         if (widget.isBroadcaster) {
                //           _leaveChannel();
                //           _stopMediaRecording();
                //         }
                //       },
                //       text: "OK",
                //       textColor: Colors.white,
                //       color: Colors.blue,
                //       height: 30,
                //       width: 200,
                //       radius: 0,
                //     )
                //   ],
                // )
              ],
            ),
          ),
        );
      },
    );
    return await true;
  }

  smallpricedialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: double.infinity,
                height: 130,
                child: AlertDialog(
                  backgroundColor: Colors.pinkAccent,
                  title: Row(
                    //    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Shop Now ${priceController.text}",
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  _saved(image) async {
    final result = await ImageGallerySaver.saveImage(image);
    print("File Saved to Gallery");
  }
}
