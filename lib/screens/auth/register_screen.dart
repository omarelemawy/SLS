import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sls/screens/auth/first_screen.dart';

import '../../contance.dart';
import '../home/home_Screen.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text.dart';
import 'bloc_auth/cubit.dart';
import 'bloc_auth/states.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
   RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<ScaffoldState> keyScaffold = GlobalKey<ScaffoldState>();
  File? _file;
  Future getFile() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null) {
      _file = File(image.path);
    } else
    {
    }

  }

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

   bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>RegisterCubit(),
      child:  BlocConsumer<RegisterCubit,RegisterStates>(
        builder: (context,state){
          return Scaffold(
            key: keyScaffold,
            backgroundColor:HexColor("#f7b6b8"),
            body: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 30, left: 30),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40,),
                      Row(
                        children: [
                          IconButton(
                              onPressed: (){
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>FirstScreen())
                                    , (route) => false);
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
                      SizedBox(height: 20,),
                      Image.asset("assets/logo.png",width: 180,height: 80,),
                      SizedBox(height: 20,),

                      InkWell(
                        onTap: (){
                          getFile().then((value) {
                            RegisterCubit.get(context).getImage();
                          });
                        },
                        child: Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                height: 160,
                                width: 160,
                                decoration: BoxDecoration(
                                  color: HexColor("#f7b6b8"),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: HexColor("#F899C0"),width: 2)
                                ),
                                child: _file!=null? CircleAvatar(
                                  backgroundColor: HexColor("#191919"),
                                  backgroundImage: FileImage(_file!),
                                ):CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  child:Icon(CupertinoIcons.person_fill,color: Colors.grey[600],size: 140,),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.pinkAccent,
                                    shape: BoxShape.circle
                                  ),
                                  child: Icon(Icons.arrow_upward_outlined,
                                    color: Colors.white,))
                            ],
                          ),
                        ),
                      ),


                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required";
                          }
                          return null;
                        },

                        style: TextStyle(color: Colors.white) ,
                        decoration:  InputDecoration(
                            label:  Text("Username",style: TextStyle(color: Colors.white)),
                            prefixIcon: Icon(CupertinoIcons.person_fill,color: Colors.white,),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                           enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),



                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white) ,
                        decoration:  InputDecoration(
                            label:  Text("Email",style: TextStyle(color: Colors.white)),
                            prefixIcon: Icon(CupertinoIcons.mail_solid,color: Colors.white,),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      TextFormField(
                        controller: passController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white) ,
                        decoration:  InputDecoration(
                            label:  Text("Password",style: TextStyle(color: Colors.white),),
                            prefixIcon:  Icon(CupertinoIcons.lock_fill,color: Colors.white,),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            value: isChecked,
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          SizedBox(width: 5,),
                          Text("I accept the Terms of Use",style: TextStyle(color: Colors.blue),)
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      state is RegisterLoadingState?
                      const Center(child: CircularProgressIndicator()):
                      CustomButton(
                            () {
                              if(_formKey.currentState!.validate()) {
                                if (_file != null) {
                                  if(isChecked) {
                                    /* RegisterCubit.get(context).uploadeImage(_file!);*/
                                    RegisterCubit.get(context).singUpToFireBase(
                                        context, usernameController.text,
                                        emailController.text,
                                        passController.text,
                                        _file);
                                  }else{
                                    keyScaffold.currentState!.showSnackBar(
                                        const  SnackBar(content: Text( "Please Accept The Terms",
                                          style:  TextStyle(color: Colors.white),),
                                          duration:  Duration(seconds: 3),
                                          backgroundColor: Colors.blue,));
                                  }
                                }else{
                                  keyScaffold.currentState!.showSnackBar(
                                      const  SnackBar(content: Text( "please select profile image",
                                        style:  TextStyle(color: Colors.white),),
                                        duration:  Duration(seconds: 3),
                                        backgroundColor: Colors.blue,));
                                }
                              }

                      /*if(_formKey.currentState!.validate()) {
                        RegisterCubit.get(context).singUpToFireBase(
                            context, usernameController.text,
                            emailController.text,
                            phoneController.text, passController.text, "");
                      }*/
                      },
                        color: HexColor("#3593FF"),
                        height: 40,
                        text: "SIGN UP",
                        textColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),




                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener:(context,state){
          if(state is CreateUserSuccessState){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
                (context)=>HomeScreen()), (route) => false);
          }else if(state is RegisterErrorState){
            keyScaffold.currentState!.showSnackBar(
                SnackBar(content: Text( state.error,
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
