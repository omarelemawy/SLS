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