import 'package:flutter/material.dart';

import '../../contance.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
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
                SizedBox(width: MediaQuery.of(context).size.width/3,),
                Text("My Orders",style: TextStyle(color: Colors.blue[900],
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
            Container(
              height: 400,
              child: Center(
                child: Text("Nothing here"
                  ,style: TextStyle(color: Colors.white,
                      fontSize: 25,fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
