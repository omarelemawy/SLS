import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../contance.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({Key? key}) : super(key: key);

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: postColor,
      body: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width/2.5,),
              Text("My Cart",style: TextStyle(color: Colors.blue[900],fontSize: 20,fontWeight: FontWeight.bold),),
              Spacer(),
              InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close,color: Colors.blue[800],)),
              SizedBox(width: 10,),
            ],
          ),

        ],
      ),
    );
  }
}
