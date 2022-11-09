import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:sls/screens/home/home_screen.dart';
import 'package:sls/screens/widget/custom_button.dart';

class Shippingaddress extends StatefulWidget {

  final String userid;
  Shippingaddress({required this.userid});

  @override
  State<StatefulWidget> createState() => Shippingaddressstate();
}

class Shippingaddressstate extends State<Shippingaddress> {
  TextEditingController textEditingController = TextEditingController();
  final Stream<QuerySnapshot> _postStream =
      FirebaseFirestore.instance.collection('Users').snapshots();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _postStream =
        FirebaseFirestore.instance.collection('Users').snapshots();
    return Scaffold(
      body: StreamBuilder(
          stream: _postStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return ListView.separated(
              itemCount: 1,
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  width: 1,
                  height: 1,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Text(
                            "Shipping Address",
                            style: TextStyle(
                                color: HexColor("#f7b6b8"),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),

                          Icon(Icons.close,color: HexColor("#f7b6b8"),size: 10,),
                        ],
                      ),
                      Container(
                        width: double.infinity - 25,
                        height: 2,
                        color: HexColor("#f7b6b8"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          TextFormField(
                            //ترك مسافه بين الحاجز والكلمه
                            controller: textEditingController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "*Required";
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: HexColor("#f7b6b8"))),
                              contentPadding: EdgeInsets.symmetric(vertical: 50.0),
                            ),
                          ),
                          Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: CustomButton(() {

                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(snapshot.data!.docs[index]["uId"])
                                  .update({
                                'default address': textEditingController.text
                              });
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                      (context) => false);
                            }, text: "Save Address",color: HexColor("#f7b6b8"),textColor: Colors.white,),
                          )
                        ],
                      ),
                    // SizedBox(height: 120,),

                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
