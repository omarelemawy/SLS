import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../shared/netWork/local/cache_helper.dart';

class UserModel{
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? photo;
  String ? confirmState;
  String? role;
  //List <String>?followers;
  //List <String>?following;
  //List <String>?hiddenPosts;
  //List <String>?liveNotificationsBlackList;

  UserModel({this.name, this.email, this.phone, this.uId, this.photo,this.confirmState,this.role,
   });

  UserModel.fromJson(Map<String,dynamic>? json){
    name=json!["userName"];
    email=json["email"];
    phone=json["phone"];
    uId=json["uId"];
    photo=json["profileImg"];
    confirmState=json["confirmState"];
    role=json["role"];

    //if (json['followers'] != null) {
      //followers= [];
    // }
    // else{
    //   followers =  [];
    // }
  //  if (json['following'] != null) {
    //  following= [];
    // }
    // else{
    //   following =  [];
    // }
    // if (json['hiddenPosts'] != null) {
    //   hiddenPosts= json['hiddenPosts'];
    // }
    // else{
     // hiddenPosts =  [];
    //}
   // if (json['liveNotificationsBlackList'] != null) {
   //   liveNotificationsBlackList= [];
    // }
    // else{
    //   liveNotificationsBlackList =  [];
    // }
  }
  Map<String,dynamic> toMap(){
    return {
      "userName":name,
      "email":email,
      "uId":uId,
      "profileImg":photo,
      "confirmState":confirmState,
      "role":role,
      //"followers":followers,
      //"following":following,
      //"hiddenPosts":hiddenPosts,
      //"liveNotificationsBlackList":liveNotificationsBlackList,
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
  int? shares;
  String? userName;
  String? email;
  String? profile;
  PostModel({
    this.comments,
    this.context,
    this.likes,
    this.userName,
    this.profile,
    this.email,
    this.postType,
    this.time,
    this.uid,
    this.id,this.shares});

  PostModel.fromJson(Map<String,dynamic>? json){
    comments=json!["comments"];
    context=json["context"];
    userName=json["userName"];
    email=json["email"];
    profile=json["profile"];
    shares=json["shares"];
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
"shares":shares
    };
  }
}

class Context {
  String? duration;
  List<String>? images;
  bool? live;
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
class Notifications{
   String? data;
   bool? seen;
   String? topic;
   String? time;
  relatedinfo? relatedinfoo;
  senderInfo? senderInfoo;
List<String>?targetusers;
  Notifications({this.data, this.seen, this.topic, this.time, this.relatedinfoo, this.senderInfoo, this.targetusers});

   Notifications.fromJson(Map<String, dynamic> json) {

      data= json["data"];
      seen=json["seen"].toLowerCase();
      topic= json["topic"];
      time= json["time"];
      relatedinfoo= relatedinfo.fromJson(json["relatedinfoo"]);
      senderInfoo= senderInfo.fromJson(json["senderInfoo"]);
        if (json['targetusers'] != null) {
      targetusers= json['targetusers'];
    }
    else{
    targetusers =  [];
    }

  }

   Map<String, dynamic> toJson() {
    return {
      "data": this.data,
      "seen": this.seen,
      "topic": this.topic,
      "time": this.time,
      "relatedinfoo": this.relatedinfoo,
      "senderInfoo": this.senderInfoo,
      "targetusers": this.targetusers,
    };
  }
//

}
class relatedinfo{
  final String orderNo;
  final String postId;

  relatedinfo({required this.orderNo,required this.postId});

  factory relatedinfo.fromJson(Map<String, dynamic> json) {
    return relatedinfo(
      orderNo: json["orderNo"],
      postId: json["postId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderNo": this.orderNo,
      "postId": this.postId,
    };
  }

//

}

class senderInfo{
  final String uid;
  final String userName;
  final String userImg;

  senderInfo({required this.uid,required this.userName,required this.userImg});

  factory senderInfo.fromJson(Map<String, dynamic> json) {
    return senderInfo(
      uid: json["uid"],
      userName: json["userName"],
      userImg: json["userImg"],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": this.uid,
      "userName": this.userName,
      "userImg": this.userImg,
    };
  }
}


