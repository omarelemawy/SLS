import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../contance.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: postColor,
      bottomNavigationBar: Container(
          padding: MediaQuery.of(context).viewInsets,
          color: postColor,
          child: Row(
            children: [
              Expanded(flex: 1,
                  child: Icon(Icons.emoji_emotions_outlined,color: Colors.blue,size: 40,)),
              SizedBox(width: 15,),
              Expanded(
                flex: 7,
                child: TextField(
                  style: TextStyle(color: Colors.grey[200]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'write comment',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue[500]!)
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15,),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Colors.blue,shape: BoxShape.circle),
                  child: Icon(Icons.arrow_forward,color: Colors.white,),
                ),
              )
            ],
          )
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            children: [
              SizedBox(width: 15,),
              Text("1 Comments",style: TextStyle(color: Colors.white),),
              Spacer(),
              Text("Newest first",style: TextStyle(color: Colors.blue[700],fontWeight: FontWeight.bold),),
              SizedBox(width: 20,),
              InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close,color: Colors.blue[800],)),
              SizedBox(width: 10,),
            ],
          ),
          Container(
            height: .5,
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              SizedBox(width: 15,),
              Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
                  width: 50,
                  height: 50,
                  fit: BoxFit.fill,

                ),
              ),
              SizedBox(width: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(" Omer Mohamed Elmawy",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  SizedBox(height: 4,),
                  Container(
                    width: MediaQuery.of(context).size.width/1.5,
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[300],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("Nice",style: TextStyle(color: Colors.blueGrey[900]),),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/profile_icons/like.svg",
                        semanticsLabel: 'Acme Logo',
                        color: Colors.grey[100],
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 8,),
                      Text("2",style: TextStyle(color: Colors.grey[100]),),
                      const SizedBox(width: 18,),
                      SvgPicture.asset(
                        "assets/profile_icons/share.svg",
                        semanticsLabel: 'Acme Logo',
                        color: Colors.blue,
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: 70,),
                      Text("Jun 20,2022",style: TextStyle(color: Colors.grey[700],fontSize: 12),)
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Text("1",style: TextStyle(color: Colors.blue,fontSize: 13),),
                      SizedBox(width: 5,),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,

                        ),
                        child: Image.network(
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
                          width: 15,
                          height: 15,
                          fit: BoxFit.fill,

                        ),
                      ),
                      SizedBox(width: 15,),
                      Text("Show replies",style: TextStyle(color: Colors.blue,fontSize: 13,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
