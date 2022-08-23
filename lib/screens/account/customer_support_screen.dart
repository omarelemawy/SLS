import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';

import '../../contance.dart';
import '../widget/custom_button.dart';

class CustomerSupportScreen extends StatefulWidget {
  const CustomerSupportScreen({Key? key}) : super(key: key);

  @override
  State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: postColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width/4,),
                Text("Customer Support",style: TextStyle(color: Colors.blue[900],
                    fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(width: 40,),
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon:Icon(Icons.close,color: Colors.blue[900],)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: .5,
                color: Colors.blue[400],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height/1.4,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Call us in:",style: TextStyle(color: Colors.blue[900],fontSize: 16),),
                    SizedBox(height: 5,),
                    Text("+49 172 5446185",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 14),),
                    SizedBox(height: 15,),
                    Text("Email us in:",style: TextStyle(color: Colors.blue[900],fontSize: 18),),
                    SizedBox(height: 5,),
                    Text("Support@sls.com",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 14),),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 10),
              child: CustomButton(
                    () {
                },
                font: 16,
                color: HexColor("#3593FF"),
                textColor: Colors.white,
                text: "About Us",
                height: 50,
                elevation: 0,
              ),
            ),
            SizedBox(height: 30,)

          ],

        ),
      ),
    );
  }
}
