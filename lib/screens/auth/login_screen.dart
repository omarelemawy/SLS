import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sls/providers/adminmode.dart';
import 'package:sls/providers/user_provider.dart';
import 'package:sls/screens/auth/register_screen.dart';
import '../../contance.dart';
import '../dashboard/dashboardscreen.dart';
import '../home/home_Screen.dart';
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
  scopes: [
    'email',
  ],
);
GoogleSignInAccount? _currentUser;

@override
void initState() {
  _googleSignIn.onCurrentUserChanged.listen((event) {
    _currentUser = event;
  });
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController emailforgetController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldFormKeySingIn =
      GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKeySingIn = GlobalKey<FormState>();

  bool isChecked = false;
  bool isadmin = true;
  bool isobscure = true;

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
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FirstScreen()),
                                    (route) => false);
                              },
                              icon: Icon(Icons.arrow_back_ios,
                                  size: 20, color: Colors.pinkAccent)),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()));
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
                      Image.asset(
                        "assets/logo.png",
                        width: 200,
                        height: 150,
                      ),
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
                          }else{
                            if(!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value))
                            {
                              return "email isn't valid format ";
                            }
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.white)),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 18.0),
                            label: Text(
                              "Email ID or Username",
                              style: TextStyle(color: Colors.white),
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.mail_solid,
                              color: Colors.white,
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: isobscure ,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        controller: passController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState((){
                                  isobscure = !isobscure;
                                });
                              },
                              icon: isobscure
                                  ? Icon(Icons.remove_red_eye)
                                  : Icon(Icons.remove_red_eye_outlined)),
                          label: Text(
                            "Password",
                            style: TextStyle(color: Colors.white),
                          ),
                          prefixIcon: Icon(
                            CupertinoIcons.padlock_solid,
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      state is LoginLoadingState
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              () {
                                if (_formKeySingIn.currentState!.validate()) {
                                  // if (Provider.of<AdminMode>(context,
                                  //         listen: false)
                                  //     .isAdmin) {
                                  //   if (passController.text == "admin123") {
                                  //     // Provider.of<UserProvider>(context, listen: false).changeisLoading(false);
                                  //     FirebaseAuth.instance
                                  //         .signInWithEmailAndPassword(
                                  //             email: emailController.text,
                                  //             password: passController.text)
                                  //         .then((value) {
                                  //       Navigator.pushAndRemoveUntil(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   HomeScreen()),
                                  //           (context) => false);
                                  //     }).catchError((error) {
                                  //       print(error
                                  //           .toString()
                                  //           .replaceRange(0, 14, '')
                                  //           .split(']')[1]);
                                  //     });
                                  //   } else {
                                  //     Provider.of<UserProvider>(context,
                                  //             listen: false)
                                  //         .changeisLoading(false);
                                  //     Scaffold.of(context).showSnackBar(
                                  //         SnackBar(
                                  //             content:
                                  //                 Text("something is wrong")));
                                  //   }
                                  // } else {
                                    RegisterCubit.get(context).loginToFireBase(
                                        context,
                                        emailController.text,
                                        passController.text,
                                        isChecked);
                                 // }
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
                            activeColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Keep me sign in",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            height: .5,
                            width: MediaQuery.of(context).size.width / 4,
                            color: Colors.grey[300],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Center(
                            child: CustomText(
                              text: "Or Sign in Using",
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              font: 13,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            color: Colors.grey[300],
                            height: .5,
                            width: MediaQuery.of(context).size.width / 4,
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
                            state is RegisterWithGoogleLoadingState
                                ? CircularProgressIndicator()
                                : InkWell(
                                    onTap: () async {
                                      _googleSignIn.signIn().then((value) {
                                        if (value != null) {
                                          RegisterCubit.get(context)
                                              .signInWithGoogle(context, value);
                                          print(value);
                                        }
                                      });
                                    },
                                    child: CircleAvatar(
                                      child:
                                          Image.asset("assets/google-logo.png"),
                                      radius: 25,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                            state is RegisterWithFacebookLoadingState
                                ? CircularProgressIndicator()
                                : InkWell(
                                    onTap: () {
                                      FacebookAuth.instance.login(permissions: [
                                        'email',
                                        'public_profile'
                                      ]).then((value) {
                                        if (value.status ==
                                            LoginStatus.success) {
                                          final OAuthCredential credential =
                                              FacebookAuthProvider.credential(
                                                  value.accessToken!.token);

                                          FirebaseAuth.instance
                                              .signInWithCredential(credential)
                                              .then((value) {
                                            print(
                                                "Facebook Data with Credentials -> ${value.user!.providerData[0]}");

                                            // RegisterCubit.get(context)
                                            //     .signInWithFace(context, value);
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
                      InkWell(
                        onTap: () {
                          dialog();
                        },
                        child: Container(
                          child: SizedBox(
                            width: double.infinity,
                            child: CustomText(
                              fontWeight: FontWeight.bold,
                              text: "Forgot Your Password ?",
                              font: 13,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is LoginErrorState) {
            scaffoldFormKeySingIn.currentState!.showSnackBar(SnackBar(
              content: Text(
                state.error,
                style: const TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.blue,
            ));
          }
        },
      ),
    );
  }

  // void navigatetodashboard(){
  //   if (Provider.of<AdminMode>(context, listen: false).isAdmin)
  //   {
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) =>
  //                 Dashboardscreen(isseller: false,)),
  //         (route) => false);
  //   }
  // }

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

  Future<bool> dialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: HexColor("#f7b6b8").withOpacity(.8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          content: Container(
            height: 150,
            child: Column(
              children: [
                Text(
                  "Forget Your password ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Just type email address and you will receive reset password email.....",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "*Required";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.white),
                  controller: emailforgetController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white)),
                      contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                      label: Text(
                        "Email",
                        style: TextStyle(color: Colors.white),
                      ),
                      prefixIcon: Icon(
                        CupertinoIcons.mail_solid,
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.all(10),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 5,
                ),
                CustomButton(
                  () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false);
                  },
                  color: Colors.white,
                  height: 50,
                  text: "Send",
                  textColor: HexColor("#f7b6b8").withOpacity(.8),
                  width: 300,
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        );
      },
    );
    return await true;
  }
}
