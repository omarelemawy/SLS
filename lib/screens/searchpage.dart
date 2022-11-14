import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_svg/svg.dart';
import '../model/user_model.dart';
import 'chat/chatt.dart';

class MySearchPage extends StatefulWidget {
//   UserModel user;
// MySearchPage({required this.user}) ;

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  List<String> country = ["alex", "cairo", "giza"];

  TextEditingController textcontroller = TextEditingController();
  List<String> itemlistnme = [];
  String nname = "";

  @override
  void initState() {
    super.initState();
  }

  late DocumentSnapshot idd;
  List<String> keyword = [];
String users="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#f7b6b8"),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("#f7b6b8"),
        // The search area here
        title: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: TextFormField(
            onChanged: (searchedcharcter) {
              filtercountry(searchedcharcter);
            },
            controller: textcontroller,
            style: TextStyle(color: Colors.grey[200]),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "*Required";
              }
              return null;
            },
            decoration: InputDecoration(
                label: Text(
                  "Search...",
                  style: TextStyle(color: Colors.grey),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue, width: 1.5),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 30)),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
//List<String>userslist=snapshot.data.docs["userName"];
          return ListView.separated(
              itemBuilder: (context, index) {
                //  idd=snapshot.data.docs()[index];
              // List item=snapshot.data.docs["index"]["userName"];
                return Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     InkWell(onTap:(){
                    //     //  item.clear();
                    //     },child: Text("clear all",style: TextStyle(color: Colors.blue),)),
                    //     SizedBox(height: 10,),
                    //   ],
                    // ),
                    InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Chat()));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text("u"),
                                ),
                                Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  height: 7,
                                  width: 7,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle, color: Colors.green),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Text(
                              textcontroller.text.isEmpty
                                  ? snapshot.data.docs[index]["userName"]
                                  : buildsearchuser( index),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                Text(
                                  snapshot.data.docs[index]["email"],
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        )),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width - 20,
                  color: Colors.grey[400],
                  margin: const EdgeInsets.symmetric(vertical: 20),
                );
              },
              itemCount: textcontroller.text.isEmpty
                  ? snapshot.data.docs.length
                  : listofuserouttput.length);
        },
      ),
    );
  }
String buildsearchuser(int index){
    return listofuserouttput[index];
}
  List<String> listofusername = [];
  List<String> listofuseroutput = [];
  List<String> listofuserouttput = [];
  final _fireStore = FirebaseFirestore.instance;

  Container buildcontent() {
    final Orientation orientation=MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          children: [
            SvgPicture.asset(
              "assets/searchh.png",
              height: 300,
            ),
            Text(
              "Find users",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal,fontWeight: FontWeight.w600,fontSize: 60.0),

            )
          ],
        ),
      ),
    );
  }

  void filtercountry(String searchedname) {
    setState(() {
      _fireStore.collection("Users").get().then((value) => {
            value.docs.forEach((element) {
              nname = element.data()["userName"];
              listofusername.add(nname.toLowerCase());
              listofuserouttput = listofusername
                  .where((element) => element
                      .toLowerCase()
                      .contains(searchedname.toLowerCase()))
                  .toList();
            })
          });
    });
  }
}
