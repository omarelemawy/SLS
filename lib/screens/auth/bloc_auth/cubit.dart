import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sls/model/user_model.dart';
import 'package:sls/screens/auth/bloc_auth/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sls/screens/waitingscreen/waitings_screen_user.dart';
import '../../../model/adminmodel.dart';
import '../../../providers/adminmode.dart';
import '../../../providers/user_provider.dart';
import '../../../shared/netWork/local/cache_helper.dart';
import '../../../utils/utils.dart';
import '../../home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shippingaddress/shippingaddressscreen.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(InitialShopStates());
  static RegisterCubit get(context) => BlocProvider.of(context);

  Future singUpToFireBase(context, name, email, password, photo, confirmed, isseller) async {
    emit(RegisterLoadingState());
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.toString(), password: password.toString())
        .then((value) {
      CacheHelper.saveData(key: 'uId', value: value.user!.uid);
      print(value.user!.uid);
      userCreate(
          context, name, email, value.user?.uid, photo, confirmed, isseller);
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString() + "33333"));
    });
  }

  Future<String?> uploadeImage(File file) async {
    final storageRef = FirebaseStorage.instance.ref();
    String? dowurl;
    //Upload the file to firebase
    Reference reference =
        storageRef.child('UsersRefs/${file.path.split('/').last}');
    UploadTask uploadTask = reference.putFile(file);
    dowurl = await (await uploadTask).ref.getDownloadURL();
    return dowurl;
  }

  void userCreate(context, name, email, uId, photo, confirmed, role) {
    uploadeImage(photo).then((value) {
      if (value != null) {

        UserModel userModel = UserModel(
            photo: value,
            email: email,
            name: name,
            uId: uId,
            confirmState: confirmed,
            role: role,
            followers: [],
          following: []
        );
        FirebaseFirestore.instance
            .collection('Users')
            .doc(uId)
            .set(userModel.toMap()).then((value) {
          emit(CreateUserSuccessState());
        }).catchError((error) {
          emit(CreateUserErrorState(error.toString()));
        });
        Provider.of<UserProvider>(context, listen: false).setUser(userModel);
       //  FirebaseFirestore.instance
       //      .collection('Users')
       //      .doc(uId)
       //      .set({"photo":value,"email": email,"name":name,"uId":uId,
       //    "confirmedState":confirmed,"role":role,})
       //      .then((value) {
       //    Provider.of<UserProvider>(context, listen: false).setUser(userModel);
       //    emit(CreateUserSuccessState());
       //    Navigator.pushAndRemoveUntil(
       //        context,
       //        MaterialPageRoute(builder: (context) => Waitingscreen()),
       //        (context) => false);
       //  }).catchError((error) {
       //    emit(CreateUserErrorState(error.toString()));
       //  });
      }
    });
  }

  Future<Map<String, dynamic>?> getCurrentUser(String? uid) async {
    if (uid != null) {
      final snap =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      return snap.data();
    }
    return null;
  }
  Future loginToFireBase(context, email, password,ischecked) async {
        emit(LoginLoadingState());
       // User? useraccount = FirebaseAuth.instance.currentUser;
        try {
          UserCredential cred = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
              email: email.toString(), password: password.toString());
         CacheHelper.saveData(key: 'uId', value: cred.user!.uid);
          emit(LoginSuccessState());
          if (cred.user != null) {
            Provider.of<UserProvider>(context, listen: false).setUser(
              UserModel.fromJson(
                await getCurrentUser(cred.user!.uid) ?? {},
              ),
            );

              final DocumentSnapshot getuserdoc= await FirebaseFirestore.instance.collection('Users')
                  .doc(cred.user!.uid).get();
             var status= getuserdoc['confirmState'];
            if (status=="confirmed") {
         if(ischecked){
           Navigator.pushAndRemoveUntil(
               context,
               MaterialPageRoute(builder: (context) => HomeScreen()),
                   (context) => false);
         }else{
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Shippingaddress(userid:cred.user!.uid)),
                    (context) => false);
          }}
          else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Waitingscreen()),
                    (context) => false);
          }}
        } on FirebaseAuthException catch (e) {
          showSnackBar(context, e.message!);
        }
    //  }
  }

  String handlingError(error) {
    String errorMessage;
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      default:
        errorMessage = error.toString();
    }
    return errorMessage;
  }

  void getImage() {
    emit(RegisterGetImageState());
  }

  void signInWithGoogle(context, GoogleSignInAccount? _currentUser) {
    emit(RegisterWithGoogleLoadingState());
    print("object");
    UserModel userModel = UserModel(
      photo: _currentUser!.photoUrl,
      email: _currentUser.email,
      name: _currentUser.displayName,
      uId: _currentUser.id,
      confirmState: "pending",

    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(_currentUser.id)
        .set(userModel.toMap())
        .then((value) {
      CacheHelper.saveData(key: 'uId', value: _currentUser.id);
      print("object1");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    }).catchError((error) {
      print("objecdvt2");
      emit(CreateUserErrorState(error.toString()));
    });
  }

  // void signInWithFace(context, UserCredential? _currentUser) {
  //   emit(RegisterWithFacebookLoadingState());
  //   UserModel userModel = UserModel(
  //     photo: _currentUser!.user!.providerData[0].photoURL,
  //     email: _currentUser.user!.providerData[0].email,
  //     name: _currentUser.user!.providerData[0].displayName,
  //     uId: _currentUser.user!.providerData[0].uid,
  //     confirmState: "pending",
  //   );
  //   FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(_currentUser.user!.providerData[0].uid)
  //       .set(userModel.toMap())
  //       .then((value) {
  //     CacheHelper.saveData(
  //         key: 'uId', value: _currentUser.user!.providerData[0].uid);
  //     print("object1");
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomeScreen()),
  //         (route) => false);
  //   }).catchError((error) {
  //     print("objecdvt2");
  //     emit(CreateUserErrorState(error.toString()));
  //   });
  // }
}
