import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:sls/screens/chat.dart';
import 'package:sls/screens/chat/chatt.dart';

import '../model/user_model.dart';

class SearchScreen extends StatefulWidget {
   UserModel user;
   SearchScreen(this.user);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;

// UserModel user;
//   _SearchScreenState({required this.user});
//   final _auth = FirebaseAuth.instance;
//   late User signInUser;
//   void getCurrentUser() {
//     try {
//       final user = _auth.currentUser;
//       user?.reload();
//       if (user != null) {
//         signInUser = user;
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
  void onSearch() async {
    setState(() {
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .where("userName", isEqualTo: searchController.text)
        .get()
        .then((value) {
      if (value.docs.length < 1) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No User Found")));
        setState(() {
          isLoading = false;
        });
        return;
      }
      value.docs.forEach((user) {
        //  if(user.data()['email'] != widget.user.email){
        searchResult.add(user.data());
        // }
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#f7b6b8"),
      ),
      backgroundColor: HexColor("#f7b6b8"),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        hintText: "type username....",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    onSearch();
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          if (searchResult.length > 0)
            Expanded(
                child: ListView.builder(
                    itemCount: searchResult.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child:
                              Image.network(searchResult[index]['profileImg']),
                        ),
                        title: Text(searchResult[index]['userName']),
                        subtitle: Text(searchResult[index]['email']),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                searchController.text = "";
                              });
                              if(searchResult[index]['email']!=widget.user.email) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Chatscreen(
                                              friendname: searchResult[index]
                                              ['userName'],
                                              friendimage: searchResult[index]
                                              ['profileImg'],
                                              user: widget.user,
                                              friendid: searchResult[index]
                                              ['uId'],
                                            )));
                              }
                            },
                            icon: Icon(Icons.message)),
                      );
                    }))
          else if (isLoading == true)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
