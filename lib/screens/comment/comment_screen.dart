import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../contance.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  User? loggeruser;
  String collectionname = 'messages';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? messagetext;
  final textfield = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool spinner = false;
  int leng = 0;
  bool isdesending = false;

  void clear() {
    textfield.clear();
  }

  // String idcomment()
  // {
  //   List<String> listid=[];
  //   firestore.collection("Posts").get().then((valuee) => {
  //   valuee.docs.forEach((elementt) {
  //   idd = elementt.data()["id"] as String ;})});
  //
  //   return listid.add("h");
  // }
  String postid = "";
  String postname = "";
  String postidddd="";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: postColor,
      bottomNavigationBar: Container(
          padding: MediaQuery.of(context).viewInsets,
          color: postColor,
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.blue,
                    size: 40,
                  )),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 7,
                child: TextField(
                  controller: textfield,
                  onChanged: (value) {
                    messagetext = value;
                  },
                  style: TextStyle(color: Colors.grey[200]),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Write comment",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue[500]!)),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration:
                  BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  child: InkWell(
                    // DocumentReference doc = _fireStore.collection("Posts").doc();
                      onTap: () {
                        databae();
                        textfield.clear();
                      },
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          )),

      body: StreamBuilder(

          stream: FirebaseFirestore.instance.collection("comments").orderBy("time").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            return Stack(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Row(
                            children: [
                              Text(
                                "${leng} Comments",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ), //Spacer(),
                        Row(
                          children: [
                            Text(
                              idd,
                              style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.blue[800],
                                )),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      height: .5,
                      margin:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        postid = snapshot.data!.docs[index]["postid"];
                        postname = snapshot.data!.docs[index]["user"];
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final itemsort = isdesending
                            ? snapshot.data!.docs.reversed.toList()
                            : snapshot.data!.docs;
                        final items = itemsort[index];
                        leng = snapshot.data!.docs.length;
                        // DateTime dataNasc = DateTime.fromMicrosecondsSinceEpoch(
                        //     snapshot.data!.docs[index]["time"]
                        //         .microsecondsSinceEpoch);
                        // String formattedDate =
                        //     DateFormat('yyyy-MM-dd – kk:mm').format(dataNasc);
                        return Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  postname,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width / 1.5,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey[300],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    snapshot.data!.docs[index]["message"],
                                    style:
                                    TextStyle(color: Colors.blueGrey[900]),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/profile_icons/like.svg",
                                      semanticsLabel: 'Acme Logo',
                                      color: Colors.grey[100],
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "2",
                                      style: TextStyle(color: Colors.grey[100]),
                                    ),
                                    const SizedBox(
                                      width: 18,
                                    ),
                                    SvgPicture.asset(
                                      "assets/profile_icons/share.svg",
                                      semanticsLabel: 'Acme Logo',
                                      color: Colors.blue,
                                      width: 25,
                                      height: 25,
                                    ),
                                    const SizedBox(
                                      width: 70,
                                    ),
                                    Text(
                                      "",
                                      //formattedDate,
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "1",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 13),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
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
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "Show replies",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        );
                      }),
                )
              ],
            );
          }),
    );
  }

  Widget commentist() {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
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
        SizedBox(
          width: 20,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " Omer Mohamed Elmawy",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.blueGrey[300],
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "Nice",
                style: TextStyle(color: Colors.blueGrey[900]),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/profile_icons/like.svg",
                  semanticsLabel: 'Acme Logo',
                  color: Colors.grey[100],
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "2",
                  style: TextStyle(color: Colors.grey[100]),
                ),
                const SizedBox(
                  width: 18,
                ),
                SvgPicture.asset(
                  "assets/profile_icons/share.svg",
                  semanticsLabel: 'Acme Logo',
                  color: Colors.blue,
                  width: 25,
                  height: 25,
                ),
                const SizedBox(
                  width: 70,
                ),
                Text(
                  "Jun 20,2022",
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  "1",
                  style: TextStyle(color: Colors.blue, fontSize: 13),
                ),
                SizedBox(
                  width: 5,
                ),
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
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Show replies",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  final _fireStore = FirebaseFirestore.instance;
 String idd = "";
  String username = "";
  String f="";
  List<String>docc=[];
  databae() async {
    DocumentReference comments= _fireStore.collection("comments").doc();
    _fireStore.collection("Posts").get().then((value) => {

      for(int i=0;i<value.docs.length;i++)
      {
        idd=value.docs[i].data()["id"]
      },
    value.docs.forEach((element) {
            idd = element.data()["id"];
            username = element.data()["nameii"];
            // docc.add(idd);
            // for(int y=0;y<docc.length;y++)
            // {f=docc[0];}
          comments.set({
            'time':FieldValue.serverTimestamp(),
            'message': messagetext,
            "postid":idd,
            "user": username,
          });}),
        });
  }

// DocumentReference doc2 = firestore
//     .collection("Posts")
//     .doc();
//     //.collection("commenty")
//    // .doc();
// //  firestore.collection("Users").get().then((value) => {
// //value.docs.
// //            valuee.docs.forEach((element) {
// doc2. set ({
// "comments":{
// 'message': messagetext,
// 'email': _auth.currentUser?.email,
// // 'name': element.data()["nameii"],
// 'commentleng': leng,
// // 'image':  element.data()["profileImage"],
// 'time': DateTime.now(),
// }
// });
//
// })});
// });
//  }),
//});

// firestore.collection("Users").get().then((value) => {
//       //value.docs.
//       value.docs.forEach((element) {
//         doc.set({
//           'message': messagetext,
//           'email': _auth.currentUser?.email,
//           'name': element.data()["userName"],
//           'commentleng': leng,
//           // 'image':  element.data()["profileImage"],
//           'time': DateTime.now(),
//         });
//       })
//     });
//}
}

// void filtercountry(String iddfield) {
//   setState(() {
//
//     firestore.collection("Posts").get().then((valuee) => {
//       valuee.docs.forEach((elementt) {
//         idd = elementt.data()["id"];
//         countrycc.add(idd.toLowerCase());
//         countrycc=countrycc.where((element) =>element.toLowerCase(),isEqualTo:iddfield.toLowerCase()).toList();
//         //countrycc=  mapp.entries.map((e) =>UserModel( name: e.value.toString().toLowerCase())).toList();
//       })
//     });
//     // countrycc.contains(searchedname.toLowerCase()) ;
//     print("*********************************************");
//     //
//     print(countrycc);
//
//     countrycc=  itemlistnme.where((element) => element.contains(searchedname.toLowerCase()))
//         .toList();
//
//     //toLowerCase().contains(searchedname.toLowerCase()) as List<String>;
//     // .toList();
//   });
// }
