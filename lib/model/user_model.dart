import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../shared/netWork/local/cache_helper.dart';

class UserModel{
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? photo;
  bool? isEmailVerification;

  UserModel({this.name, this.email, this.phone, this.uId, this.photo,this.isEmailVerification});

  UserModel.fromJson(Map<String,dynamic>? json){
    name=json!["userName"];
    email=json["email"];
    phone=json["phone"];
    uId=json["uId"];
    photo=json["profileImg"];
    isEmailVerification=json["isEmailVerification"];
  }
  Map<String,dynamic> toMap(){
   return {
     "userName":name,
     "email":email,
     "uId":uId,
     "profileImg":photo,
     "isEmailVerification":isEmailVerification,
   };
  }
}

class PostModel {
  int? comments;
  Context? context;
  String? id;
  List<String>? likes;
  String? postType;
  String? time;
  String? uid;

  PostModel({
    this.comments,
    this.context,
    this.likes,
    this.postType,
    this.time,
    this.uid,
    this.id});

  PostModel.fromJson(Map<String,dynamic>? json){
    comments=json!["comments"];
    context=json["context"];

    if (json['likes'] != null) {
      likes=json["likes"];
    }
    else{
      likes =  [];
    }

    id=json["id"];
    postType=json["postType"];
    time=json["time"];
    uid=json["uid"];
  }
  Map<String,dynamic> toMap(){
   return {
     "comments":comments,
     "email":context,
     "id":id,
     "postType":postType,
     "likes":likes,
     "time":time,
     "uid":uid,

   };
  }
}

class Context {
  String? duration;
  List<String>? images;
  String? live;
  String? productPrice;
  String? text;
  String? video;
  String? videoPreview;
  String? views;
  Context({
    this.duration,
    this.images,
    this.live,
    this.productPrice,
    this.text,
    this.video,
    this.videoPreview,
    this.views,});

  Context.fromJson(Map<String,dynamic>? json){
    duration=json!["duration"];

    if (json['images'] != null) {
      images= json['images'];
    }
    else{
      images =  [];
    }
    live=json["live"];
    productPrice=json["productPrice"];
    text=json["text"];
    video=json["video"];
    videoPreview=json["videoPreview"];
    views=json["views"];

  }
  Map<String,dynamic> toMap(){
    return {
      "duration":duration,
      "images":images,
      "live":live,
      "productPrice":productPrice,
      "text":text,
      "videoPreview":videoPreview,
    };
  }
}


class Message {
  String? message;
  List<String>? messageImage;
  String? user;
  String? time;
  bool? seen;

  Message({this.message, this.messageImage,this.user,this.time,this.seen});

  factory Message.fromMap(QueryDocumentSnapshot map) {
    return Message(
        seen: map["seen"],
        time: timeago.format(map["time"].toDate()),
        message: map["messageText"],
        messageImage: map["messageImage"],
    );
  }

  static List<Message> toList(QuerySnapshot data) => data.docs.map((chatMap) => Message.fromMap(chatMap)).toList();

  Map<String, dynamic> toMap(){
    return {
      "messageText" : message,
      "messageImage" : messageImage,
      "time" : Timestamp.now(),
      "seen" : false,
    };
  }
}
