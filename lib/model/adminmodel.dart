import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../shared/netWork/local/cache_helper.dart';

class AdminModel{
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? photo;
  bool? isEmailVerification;bool? becomeaseller;

  AdminModel({this.name, this.email, this.phone, this.uId, this.photo,this.isEmailVerification,this.becomeaseller});

  AdminModel.fromJson(Map<String,dynamic>? json){
    name=json!["userName"];
    email=json["email"];
    phone=json["phone"];
    uId=json["uId"];
    photo=json["profileImg"];
    isEmailVerification=json["isEmailVerification"];
    becomeaseller=json["becomeaseller"];
  }
  Map<String,dynamic> toMap(){
    return {
      "userName":name,
      "email":email,
      "uId":uId,
      "profileImg":photo,
      "isEmailVerification":isEmailVerification,
      "becomeaseller":becomeaseller
    };
  }
}


