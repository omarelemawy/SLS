
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../model/user_model.dart';

Future sendMessage({var chatRoomId , Message? message}) async {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  String imgUrl = "";
  await _firestore.collection(
      "messages/$chatRoomId/Messages"
  ).add(message!.toMap());
  print("Sent");
}
