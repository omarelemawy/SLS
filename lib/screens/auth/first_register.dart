import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sls/model/user_model.dart';
import 'package:sls/screens/auth/bloc_auth/cubit.dart';
import 'package:sls/screens/auth/bloc_auth/states.dart';
import 'package:sls/screens/auth/register_screen.dart';

import '../widget/custom_text.dart';
import 'login_screen.dart';

class FirstRegisterScreen extends StatefulWidget {
  //UserModel usermodel;
  //FirstRegisterScreen({required this.usermodel}) ;

  @override
  State<FirstRegisterScreen> createState() => _FirstRegisterScreenState();
}
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes:[
    'email',
  ],
);
class _FirstRegisterScreenState extends State<FirstRegisterScreen> {

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((event) {
       _currentUser=event;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => RegisterCubit(),
  child: BlocConsumer<RegisterCubit, RegisterStates>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return Scaffold(
      backgroundColor: HexColor("#f7b6b8"),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, right: 30, left: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40,),
              Row(
                children: [
                  IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon:Icon(Icons.arrow_back_ios,size: 20,color:
                      Colors.pinkAccent)),
                  Spacer(),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          LoginScreen()));
                    },
                    child: CustomText(
                      text: "LOG IN",
                      font: 25,
                      fontWeight: FontWeight.bold,
                      color: HexColor("#5B67CA"),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/5,
              ),
              Text("Welcome to",style: TextStyle(
                color: Colors.white,
                fontSize: 20,

              ),),
              const SizedBox(
                height: 10,
              ),
              Text("SLS APP",style: TextStyle(
                  color: HexColor("#ae904b"),
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),),
              Image.asset("assets/logo.png",width: 200,height: 150,),
              SizedBox(height: 30,),

              state is RegisterWithFacebookLoadingState?
              CircularProgressIndicator():
              InkWell(
                onTap: (){
                  FacebookAuth.instance.login(
                      permissions: ['email','public_profile']
                  ).then((value) {
                    if (value.status == LoginStatus.success) {

                      final OAuthCredential credential =
                      FacebookAuthProvider.credential(value.accessToken!.token);

                      FirebaseAuth.instance
                          .signInWithCredential(credential).then((value) {
                        print("Facebook Data with Credentials -> ${value.user!.providerData[0]}");

                      //  RegisterCubit.get(context).signInWithFace(context,value);
                      });
                    }

                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HexColor("#3593FF"),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                          child: CustomText(text: "SIGN UP WITH FACEBOOK",color: Colors.white,font: 14,fontWeight: FontWeight.bold,)),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: CircleAvatar(
                            child: Image.asset("assets/facebook.png"),
                            radius: 20,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20,),
              state is RegisterWithGoogleLoadingState?
              CircularProgressIndicator():
              InkWell(
                onTap: ()async{
                     _googleSignIn.signIn().then((value) {
                       if(value!=null){
                         RegisterCubit.get(context).signInWithGoogle(context, value);
                         print(value);
                       }
                     });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HexColor("#3593FF"),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: CustomText(text: "SIGN UP WITH GOOGLE",color: Colors.white,font: 14,fontWeight: FontWeight.bold,)),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: CircleAvatar(
                            child: Image.asset("assets/google.png"),
                            radius: 20,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),

              InkWell(
                onTap: (){

                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>RegisterScreen()),
                           (route) => false);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HexColor("#3593FF"),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: CustomText(text: "SIGN UP WITH EMAIL",color: Colors.white,font: 14,fontWeight: FontWeight.bold,)),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: CircleAvatar(
                            child: Icon(Icons.mail,size: 30,color: Colors.black,),
                            radius: 20,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  },
),
);
  }
}
