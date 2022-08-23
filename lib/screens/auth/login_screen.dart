import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sls/screens/auth/register_screen.dart';
import '../../contance.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text.dart';
import 'bloc_auth/cubit.dart';
import 'bloc_auth/states.dart';
import 'first_screen.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes:[
    'email',
  ],
);
GoogleSignInAccount? _currentUser;
@override
void initState() {
  _googleSignIn.onCurrentUserChanged.listen((event) {
    _currentUser=event;
  });

}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldFormKeySingIn = GlobalKey<
      ScaffoldState>();

  final GlobalKey<FormState> _formKeySingIn = GlobalKey<FormState>();

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        builder: (context, state) {
          return Scaffold(
            key: scaffoldFormKeySingIn,
            backgroundColor: HexColor("#f7b6b8"),
            /*appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: CustomText(
                text: " Sign Up",
                color: HexColor("#3593FF"),
                fontWeight: FontWeight.bold,
                font: 15,
              ),
            ),*/
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0, right: 30, left: 30),
                child: Form(
                  key: _formKeySingIn,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                        builder: (context) => FirstScreen())
                                    , (route) => false);
                              },
                              icon: Icon(Icons.arrow_back_ios, size: 20, color:
                              Colors.pinkAccent)),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      RegisterScreen()));
                            },
                            child: CustomText(
                              text: "SIGN UP",
                              font: 25,
                              fontWeight: FontWeight.bold,
                              color: HexColor("#5B67CA"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset("assets/logo.png", width: 200, height: 150,),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        controller: emailController,
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
                            label: Text("Email ID or Username",
                              style: TextStyle(color: Colors.white),),
                            prefixIcon: Icon(CupertinoIcons.mail_solid,
                              color: Colors.white,)),

                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        controller: passController,
                        decoration: InputDecoration(
                          label: Text("Password",
                            style: TextStyle(color: Colors.white),),
                          prefixIcon: Icon(CupertinoIcons.padlock_solid,
                            color: Colors.white,),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),


                      const SizedBox(
                        height: 30,
                      ),
                      state is LoginLoadingState ?
                      const Center(child: CircularProgressIndicator()) :
                      CustomButton(
                            () {
                          if (_formKeySingIn.currentState!.validate()) {
                            RegisterCubit.get(context).loginToFireBase(
                                context, emailController.text,
                                passController.text);
                          }
                        },
                        color: HexColor("#3593FF"),
                        height: 50,
                        text: "LOG IN",
                        textColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            value: isChecked,
                            fillColor: MaterialStateProperty.resolveWith(
                                getColor),
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          SizedBox(width: 5,),
                          Text("Keep me sign in",
                            style: TextStyle(color: Colors.white),)
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            height: .5,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 4,
                            color: Colors.grey[300],
                          ),
                          SizedBox(width: 10,),
                          Center(
                            child: CustomText(
                              text: "Or Sign in Using",
                              color: Colors.blue,
                              fontWeight: FontWeight.w300,
                              font: 13,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            color: Colors.grey[300],
                            height: .5,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 4,
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                           state is RegisterWithGoogleLoadingState?
                           CircularProgressIndicator():
                            InkWell(
                              onTap: () async {
                                _googleSignIn.signIn().then((value) {
                                  if (value != null) {
                                    RegisterCubit.get(context).signInWithGoogle(
                                        context, value);
                                    print(value);
                                  }
                                });
                              },
                              child: CircleAvatar(
                                child: Image.asset("assets/google-logo.png"),
                                radius: 25,
                                backgroundColor: Colors.white,
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),
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

                                      RegisterCubit.get(context).signInWithFace(context,value);
                                    });
                                  }

                                });
                              },
                              child: CircleAvatar(
                                child: Image.asset("assets/facebook.png"),
                                radius: 25,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: SizedBox(
                          width: double.infinity,
                          child: CustomText(
                            fontWeight: FontWeight.w300,
                            text: "Forgot Password ?",
                            font: 13,
                            color: primaryColor,
                          ),
                        ),
                      ),

                      SizedBox(height: 60,)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is LoginErrorState) {
            scaffoldFormKeySingIn.currentState!.showSnackBar(
                SnackBar(content: Text(state.error,
                  style: const TextStyle(color: Colors.white),),
                  duration: const Duration(seconds: 3),
                  backgroundColor: Colors.blue,));
          }
        },
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blue;
  }
}
