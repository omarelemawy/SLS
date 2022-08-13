import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:sls/screens/auth/register_screen.dart';

import '../widget/custom_button.dart';
import 'first_register.dart';
import 'login_screen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#191919"),
      body: SingleChildScrollView(
        child: Column(
          children: [
             SizedBox(
              height: MediaQuery.of(context).size.height/3,
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
             SizedBox(
              height: MediaQuery.of(context).size.height/5.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomButton(
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  LoginScreen()));
                },
                font: 16,
                color: HexColor("#3593FF"),
                textColor: Colors.white,
                text: "LOG IN",
                height: 50,
                elevation: 0,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomButton(
                  (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  FirstRegisterScreen()));
                  },
                  elevation: 2,
                  color: HexColor("#3593FF"),
                  text:"SIGN UP",
                 textColor:  Colors.white,
                radius: 15,
                  height: 50,

              ),
            ),
            const SizedBox(
              height:20,
            )
          ],
        ),
      ),
    );
  }
}
