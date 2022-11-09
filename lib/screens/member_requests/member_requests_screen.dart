import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import '../../providers/user_provider.dart';
import '../../shared/netWork/local/cache_helper.dart';
import '../auth/bloc_auth/cubit.dart';
import '../auth/bloc_auth/states.dart';
import '../home/home_Screen.dart';
import '../widget/custom_button.dart';

class memberrequestscreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _memberrequestscreenstate();
}

class _memberrequestscreenstate extends State<memberrequestscreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _postStream =
        FirebaseFirestore.instance.collection('Users').where("confirmState",isEqualTo: "pending").snapshots();
    //String id = CacheHelper.getData(key: 'uId');
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        builder: (context, state) {
          return StreamBuilder(
              stream: _postStream,
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
                                      snapshot.data!.docs[index]["userName"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.indigo[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      " wants to join SLS App!",
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
                                        .collection('Users')
                                        .doc(snapshot.data!.docs[index]["uId"])
                                        .update({
                                      'isEmailVerification': true
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
        },
        listener: (context, state) {
          if (state is CreateUserSuccessState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false);
          }
          // else if(state is RegisterErrorState){
          //   keyScaffold.currentState!.showSnackBar(
          //       SnackBar(content: Text( state.error,
          //         style: const TextStyle(color: Colors.white),),
          //         duration: const Duration(seconds: 3),
          //         backgroundColor: Colors.blue,));
          // }
        },
      ),
    );
  }
}
//     .then((value) async {
// String uid =
// CacheHelper.getData(key: 'uId');
// bool isexist =
//     await checkIfDocExists(uid);
// if (isexist) {
// Navigator.pushAndRemoveUntil(
// context,
// MaterialPageRoute(
// builder: (context) =>
// HomeScreen()),
// (context) => false);
// }
// });
