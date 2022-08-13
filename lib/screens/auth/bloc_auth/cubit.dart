import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sls/model/user_model.dart';
import 'package:sls/screens/auth/bloc_auth/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../shared/netWork/local/cache_helper.dart';
import '../../home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(InitialShopStates());

  static RegisterCubit get(context) => BlocProvider.of(context);

  Future singUpToFireBase(context, name, email,  password,photo,) async {

    emit(RegisterLoadingState());

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email.toString(), password: password.toString())
          .then((value) {
        CacheHelper.saveData(key: 'uId', value: value.user!.uid);
        print(value.user!.uid);
        userCreate(context, name, email, value.user?.uid, photo);
      }).catchError((error) {
        print(error.toString().replaceRange(0, 14, '').split(']')[1]);
        emit(RegisterErrorState(error.toString().replaceRange(0, 14, '').split(']')[1]));
      });
  }

  Future<String?> uploadeImage(File file)async{
    final storageRef = FirebaseStorage.instance.ref();
    String? dowurl;
    //Upload the file to firebase
    Reference reference = storageRef.child('UsersRefs/${file.path.split('/').last}');
    UploadTask uploadTask = reference.putFile(file);
    dowurl = await (await uploadTask).ref.getDownloadURL();
    return dowurl;
  }


  void userCreate(context, name, email,  uId,photo) {
    uploadeImage(photo).then((value) {
      if(value !=null) {
        UserModel userModel = UserModel(photo: value,
          email: email,
          name: name,
          uId: uId,
          isEmailVerification: false,);
        FirebaseFirestore.instance.collection('Users').doc(uId).set(
            userModel.toMap()).then((value) {
          emit(CreateUserSuccessState());
        }).catchError((error) {
          emit(CreateUserErrorState(error.toString()));
        });
      }
    });
  }

  Future loginToFireBase(context, email, password) async {
    emit(LoginLoadingState());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email.toString(), password: password.toString())
        .then((value) {
      CacheHelper.saveData(key: 'uId', value: value.user!.uid);
      emit(LoginSuccessState());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (context) => false);
    }).catchError((error) {
      print(error.toString().replaceRange(0, 14, '').split(']')[1]);
      emit(LoginErrorState(error.toString().replaceRange(0, 14, '').split(']')[1]));
    });
  }

  String handlingError(error){
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

  void getImage()
  {
    emit(RegisterGetImageState());
  }

  void signInWithGoogle(context,GoogleSignInAccount? _currentUser){
    emit(RegisterWithGoogleLoadingState());
    print("object");
    UserModel userModel = UserModel(photo: _currentUser!.photoUrl,
      email: _currentUser.email,
      name: _currentUser.displayName,
      uId: _currentUser.id,
      isEmailVerification: false,);
    FirebaseFirestore.instance.collection('Users').doc(_currentUser.id).set(
        userModel.toMap()).then((value) {
      CacheHelper.saveData(key: 'uId', value: _currentUser.id);
      print("object1");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
          (context)=>HomeScreen()), (route) => false);
    }).catchError((error) {
      print("objecdvt2");
      emit(CreateUserErrorState(error.toString()));
    });
  }

  void signInWithFace(context,UserCredential? _currentUser){
    emit(RegisterWithFacebookLoadingState());
    UserModel userModel = UserModel(photo: _currentUser!.user!.providerData[0].photoURL,
      email:  _currentUser.user!.providerData[0].email,
      name:  _currentUser.user!.providerData[0].displayName,
      uId:  _currentUser.user!.providerData[0].uid,
      isEmailVerification: false,);
    FirebaseFirestore.instance.collection('Users').doc( _currentUser.user!.providerData[0].uid).set(
        userModel.toMap()).then((value) {
      CacheHelper.saveData(key: 'uId', value:  _currentUser.user!.providerData[0].uid);
      print("object1");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
          (context)=>HomeScreen()), (route) => false);
    }).catchError((error) {
      print("objecdvt2");
      emit(CreateUserErrorState(error.toString()));
    });
  }
}
