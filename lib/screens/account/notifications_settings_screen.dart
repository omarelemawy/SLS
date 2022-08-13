import 'package:flutter/material.dart';
import 'package:sls/contance.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: postColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50,),
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width/5.5,),
              Text("Notifications Settings",style: TextStyle(color: Colors.blue[900],
                  fontWeight: FontWeight.bold,fontSize: 22),),
              SizedBox(width: 20,),
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
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                SizedBox(height: 30,),
                Row(
                  children: [
                   Expanded(
                      flex:5,
                        child: Text("Allow post notifications of following profiles",
                          style: TextStyle(color: Colors.blue[900],fontSize: 16,fontWeight: FontWeight.bold),)),
                     SizedBox(width: 10,),
                    Expanded(
                      flex: 1,
                      child: Switch(value: true, onChanged: (value){
                      },activeColor: Colors.blue[900],),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Allow live notifications",style: TextStyle(color: Colors.blue[900],
                        fontSize: 16,fontWeight: FontWeight.bold),),
                    Spacer(),
                    Switch(value: true, onChanged: (value){

                    },activeColor: Colors.blue[900],)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Allow delivered orders notifications",style: TextStyle(color: Colors.blue[900]
                        ,fontSize: 16,fontWeight: FontWeight.bold),),
                    Spacer(),
                    Switch(value: true, onChanged: (value){

                    },activeColor: Colors.blue[900],)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Allow cancelled orders notifications",style: TextStyle(color: Colors.blue[900]
                        ,fontSize: 16,fontWeight: FontWeight.bold),),
                    Spacer(),
                    Switch(value: true, onChanged: (value){

                    },activeColor: Colors.blue[900],)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Allow new message",style: TextStyle(color: Colors.blue[900]
                        ,fontSize: 16,fontWeight: FontWeight.bold),),
                    Spacer(),
                    Switch(value: true, onChanged: (value){

                    },activeColor: Colors.blue[900],)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Allow replay comment",style: TextStyle(color: Colors.blue[900]
                        ,fontSize: 16,fontWeight: FontWeight.bold),),
                    Spacer(),
                    Switch(value: true, onChanged: (value){

                    },activeColor: Colors.blue[900],)
                  ],
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),

        ],

      ),
    );
  }
}
