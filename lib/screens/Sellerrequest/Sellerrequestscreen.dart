import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/netWork/local/cache_helper.dart';
import '../widget/custom_button.dart';

class Sellerreuestscreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>Sellerrequeststate();
}
class Sellerrequeststate extends State<Sellerreuestscreen>{
  final Stream<QuerySnapshot> _sellerStream =
  FirebaseFirestore.instance.collection('Users').where("role",isEqualTo: "PendingSeller").snapshots();
  @override
  Widget build(BuildContext context) {
   return StreamBuilder(
       stream: _sellerStream,
       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
         if (!snapshot.hasData) {
           return CircularProgressIndicator();
         }
         return Container(
           color: Colors.indigo[700],
           width: double.infinity,
           height: double.infinity,
           child: ListView.separated(
             itemCount: snapshot.data!.docs.length,
             itemBuilder: (BuildContext context, int index) {
               return  AlertDialog(
                 backgroundColor: Colors.white,
                 title: Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
                     IconButton(
                       onPressed: () {
                         Navigator.of(context).pop(false);
                       },
                       icon: Icon(
                         Icons.close,
                         color: Colors.indigo,
                       ),
                     ),
                   ],
                 ),
                 content: Container(
                   height: 50,
                   child: Column(
                     children: [
                       SizedBox(
                         height: 5,
                       ),
                       Row(
                         children: [
                           Text(
                             snapshot.data!.docs[index]["username"],
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               color: Colors.indigo[700],
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           Text(
                             " wants to become a seller SLS App!",
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               color: Colors.indigo[700],
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                         ],
                       ),
                     ],
                   ),
                 ),
                 contentPadding: EdgeInsets.all(10),
                 actions: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       SizedBox(
                         width: 10,
                       ),
                       CustomButton(
                             () {
                           CacheHelper.getData(key: 'uId');
                           FirebaseFirestore.instance
                               .collection('sellerreuest')
                               .doc(snapshot.data!.docs[index]["uId"])
                               .update({
                             'becomeseller': true
                           }).then((value) {
                             Navigator.of(context).pop(false);
                           });
                           // RegisterCubit.get(context).singUpToFireBase(
                           //     context,
                           //     snapshot.data!.docs[index]["username"],
                           //     snapshot.data!.docs[index]["email"],
                           //     snapshot.data!.docs[index]["password"])
                           //     .then((value) => FirebaseFirestore.instance
                           //     .collection('WaitingUsers')
                           //     .doc(id)
                           //     .delete());
                           //  _db.collection('jobs').document(jobId).delete();
                         },
                         color: Colors.indigo,
                         height: 50,
                         text: "Accept",
                         textColor: Colors.white,
                         width: 100,
                       ),
                       SizedBox(
                         width: 10,
                       ),
                       CustomButton(
                             () {
                           FirebaseFirestore.instance
                               .collection('Users')
                               .doc(snapshot.data!.docs[index]["uId"])
                               .delete();
                         },
                         color: Colors.indigo,
                         height: 50,
                         text: "refuse",
                         textColor: Colors.white,
                         width: 100,
                       ),
                       SizedBox(
                         width: 10,
                       ),
                     ],
                   ),
                   SizedBox(
                     height: 20,
                   )
                 ],
               );},


             separatorBuilder: (BuildContext context, int index) {
               return Container();
             },
           ),
         );
       });

  }
}