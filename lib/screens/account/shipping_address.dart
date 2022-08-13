import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:sls/contance.dart';

import '../widget/custom_button.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({Key? key}) : super(key: key);

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: postColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width/4,),
                Text("Shipping Address",style: TextStyle(color: Colors.blue[900],
                    fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(width: 60,),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue[900]!)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.blue[900]!)
                  ),
                ),
                maxLines: 5,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/1.9,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: CustomButton(
                    (){
                },
                elevation: 2,
                color: HexColor("#3593FF"),
                text:"SAVE",
                textColor:  Colors.white,
                radius: 15,
                height: 50,

              ),
            ),
            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}
