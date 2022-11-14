import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sls/providers/liveprovider.dart';
import 'package:sls/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import '../model/livestream.dart';
import '../model/user_model.dart';
import '../providers/user_provider.dart';
import '../shared/netWork/local/cache_helper.dart';
import '../utils/utils.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final StorageMethods _storageMethods = StorageMethods();

  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
int count=0;
  Future<String?> uploadeImage(File file, String id) async {
    final storageRef = FirebaseStorage.instance.ref();
    String? dowurl;
    count++;
    //Upload the file to firebase
    Reference reference = storageRef
        .child('PostsRefs/"record${id}${count}"/videos/${file.path.split('/').last}');
    UploadTask uploadTask = reference.putFile(file);
    dowurl = await (await uploadTask).ref.getDownloadURL();
    return dowurl;
  }

  Future<String> startLiveStream(
      BuildContext context, String userid, bool islive, String record) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    String liveId = const Uuid().v1();
    String channelId = '';
    DocumentReference doc = _firestore.collection("Post").doc();
    uploadeImage(File(record) , doc.id).then((value) async {
      try {
        channelId = '${user.user.uId}${user.user.name}';
        Context context = Context(
            duration: "${DateTime.now()}",
            views: "${0}",
            images: [],
            video: record,
            live: false);
        LiveStream liveStream = LiveStream(
          uid: userid,
          username: user.user.name!,
          viewers: 0,
          channelId: liveId,
          startedAt: DateTime.now(),
          photoprofile: user.user.photo ?? " ",
          //record:recordd,
          islive: islive,
          record: record,
        );
        // final querySnapshot = await _firestore.collection('Post').where("uid",isEqualTo:user.user.uId).get();
        // querySnapshot.docs.map((e) {
        //   final model = PostModel.fromJson(e.data());
        //   model.id = e.id;
        //   if(model.id!.isNotEmpty) {
        //     _firestore.collection('Post').doc(model.id).update({
        //       "context": {
        //         "duration": "${DateTime.now()}",
        //         "views": "${0}",
        //         "images": [],
        //         "video": record,
        //         "live": false
        //       }
        //     });
        //   }
        //   else
        //     {
        doc.set({
          "id": doc.id,
          "userName": user.user.name,
          "uid": user.user.uId,
          "postType": "TextPostWithLive",
          "likes":[],
          "profile": user.user.photo,
          "context": {
            "duration": DateTime.now(),
            "views": "${0}",
            "images": [],
            "videoPreview": value,
            "live": true
          }
        });
        //}
        // });

        CacheHelper.setString(key: "liveid", value: doc.id);
        // _firestore.collection('lives').doc(liveId)
        //     .update(liveStream.toMap());
        // } else {
        //   showSnackBar(
        //       context, 'Two Livestreams cannot start at the same time.');
        // }

      } on FirebaseException catch (e) {
        // showSnackBar(context, e.message!);
      }
    });
    return channelId;
  }

  Future<void> chat(
      String text,  BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    try {
      String commentId = const Uuid().v1();

      await _firestore
          .collection('Post')
          .doc(CacheHelper.getString(key: "liveid"))
          .collection("commentslive")
          .doc(commentId)
          .set({
        'username': user.user.name,
        "photo": user.user.photo,
        'message': text,
        'uid': user.user.uId,
        'createdAt': DateTime.now(),
        'commentId': commentId,
      });
    } on FirebaseException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> updateViewCount(String id, bool isIncrease) async {
    try {
      await _firestore
          .collection('Post')
          .doc(CacheHelper.getString(key: "liveid"))
          .update({
        'viewers': FieldValue.increment(isIncrease ? 1 : -1),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> endLiveStream(String id, BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    DocumentReference doc = _firestore.collection("Post").doc();

    _firestore
        .collection('Post')
        .doc(CacheHelper.getString(key: "liveid"))
        .update({"context":{"live": false}});
  }
}
