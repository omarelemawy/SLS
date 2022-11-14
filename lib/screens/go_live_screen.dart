import 'dart:io';
import 'dart:typed_data';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/media_recorder.dart' as media_recorder;
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/firestore_methods.dart';
import '../responsive/responsive.dart';
import '../shared/netWork/local/cache_helper.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import 'broadcast/broadcast_screen.dart';


class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({Key? key}) : super(key: key);

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  final TextEditingController _titleController = TextEditingController();
  Uint8List? image;
  File? video;
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  goLiveStream() async {
    // String channelId = await FirestoreMethods()
    //     .startLiveStream(context,"",true);

    // if (channelId.isNotEmpty) {
    //   showSnackBar(context, 'Livestream has started successfully!');
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => BroadcastScreen(
    //         isBroadcaster: true,
    //         channelId: channelId,
    //         userid:""
    //       ),
    //     ),
    //   );
    // }
  }
  media_recorder.MediaRecorder? mediaRecorder;
  // Future<void> _startMediaRecording() async {
  //   media_recorder.MediaRecorderObserver observer =
  //   media_recorder.MediaRecorderObserver(
  //     onRecorderStateChanged: (RecorderState state, RecorderErrorCode error) {
  //       print('onRecorderStateChanged state: $state, error: $error');
  //     },
  //     onRecorderInfoUpdated: (RecorderInfo info) {
  //       print('onRecorderInfoUpdated info: ${info.toJson()}');
  //       GallerySaver.saveVideo(info.fileName).then((value) {
  //         print("done");
  //         File file=File(info.fileName);
  //       });
  //     },
  //   );
  //
  //   mediaRecorder = media_recorder.MediaRecorder.getMediaRecorder(
  //     _engine!,
  //     callback: observer,
  //   );
  //
  //   Directory appDocDir = Platform.isAndroid
  //       ? (await getExternalStorageDirectory())!
  //       : await getApplicationDocumentsDirectory();
  //   String p = path.join(appDocDir.path, 'testing.mp4');
  //
  //   await mediaRecorder?.startRecording(MediaRecorderConfiguration(
  //       storagePath: p, containerFormat: MediaRecorderContainerFormat.MP4));
  //
  //   setState(() {
  //     _recordingFileStoragePath = 'Recording file storage path: $p';
  //     _isStartedMediaRecording = true;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Responsive(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [

                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Title',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child:  TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "*Required";
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.black),
                              controller: _titleController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.white)
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  label: Text("title",
                                    style: TextStyle(color: Colors.black),),),

                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: ElevatedButton(
                       onPressed: () { goLiveStream(); }, child:Text("Go Live!"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
