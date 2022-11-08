import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:sls/model/user_model.dart';
import 'package:sls/screens/account/acount_bloc/account_cubit.dart';
import 'package:sls/screens/account/edit_profile_screen.dart';
import 'package:sls/screens/account/my_orders_screen.dart';
import 'package:sls/screens/account/shipping_address.dart';
import 'package:sls/screens/auth/first_screen.dart';
import 'package:sls/shared/netWork/local/cache_helper.dart';
import '../../contance.dart';
import '../user_profile/my_profile.dart';
import '../widget/custom_button.dart';
import 'customer_support_screen.dart';
import 'notifications_settings_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  @override
  Widget build(BuildContext context) {
    Future<UserModel> readUser() async {
      final docUser = FirebaseFirestore.instance.collection("Users").doc(
          CacheHelper.getData(key: "uId"));
      final snapshot = await docUser.get();
      if (snapshot.exists) {
        return UserModel.fromJson(snapshot.data());
      } else {
        return UserModel(name: '');
      }
    }
    return BlocProvider(
      create: (context) => AccountCubit(),
      child: BlocConsumer<AccountCubit, AccountState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return Scaffold(
              backgroundColor: HexColor("#f7b6b8"),
              body: FutureBuilder<UserModel?>(
                future: readUser(),
                builder: (context, AsyncSnapshot<UserModel?> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      child: Column(
                        children: [
                          SizedBox(height: 40,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(onPressed: () {
                                Navigator.pop(context);
                              },
                                  icon: Icon(
                                    Icons.close, color: Colors.blue[700],)),
                              SizedBox(width: 20,)
                            ],
                          ),
                          SizedBox(height: 10,),

                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,

                            ),
                            child: Image.network(
                              snapshot.data!.photo!,
                              width: 160,
                              height: 160,
                              fit: BoxFit.fill,
                            ),
                          ),

                          SizedBox(height: 20,),
                          Text(snapshot.data!.name!, style: TextStyle(fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),),
                          SizedBox(height: 20,),
                          Container(
                            color: Colors.blue,
                            height: 1,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 1.2,
                          ),

                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        Icons.person_outline_sharp,
                                        color: Colors.white,),
                                      title: Text("My Profile", style:
                                      TextStyle(fontWeight: FontWeight.bold,
                                          color: Colors.white),),
                                      trailing: Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: Colors.white),
                                      onTap: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(
                                            builder: (context) =>
                                                MyProfileScreen()));
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.edit, color: Colors.white,),
                                      title: Text("Edit Profile", style:
                                      TextStyle(fontWeight: FontWeight.bold,
                                          color: Colors.white),),
                                      trailing: Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: Colors.white),
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            useRootNavigator: true,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            clipBehavior: Clip
                                                .antiAliasWithSaveLayer,
                                            builder: (context) {
                                              return Container(
                                                  color: postColor,
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height - 30,
                                                  padding: EdgeInsets.all(10),
                                                  child: EditProfileScreen());
                                            });
                                      },
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder:
                                            (context) =>
                                            ShippingAddressScreen()));
                                      },
                                      leading: Icon(
                                        CupertinoIcons.map_pin_ellipse,
                                        color: Colors.white,),
                                      title: Text("Shipping Address", style:
                                      TextStyle(fontWeight: FontWeight.bold,
                                          color: Colors.white),),
                                      trailing: Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: Colors.white),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder:
                                            (context) => MyOrdersScreen()));
                                      },
                                      leading: Icon(
                                        Icons.card_travel, color: Colors.white,),
                                      title: Text("My Orders", style:
                                      TextStyle(fontWeight: FontWeight.bold,
                                          color: Colors.white),),
                                      trailing: Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: Colors.white),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationsSettingsScreen()));
                                      },
                                      leading: Icon(Icons.notifications_none,
                                        color: Colors.white,),
                                      title: Text(
                                        "Notification Settings", style:
                                      TextStyle(fontWeight: FontWeight.bold,
                                          color: Colors.white),),
                                      trailing: Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: Colors.white),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerSupportScreen()));
                                      },
                                      leading: Icon(Icons.support_agent,
                                        color: Colors.white,),
                                      title: Text("Customer Support", style:
                                      TextStyle(fontWeight: FontWeight.bold,
                                          color: Colors.white),),
                                      trailing: Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: Colors.white),
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle),
                                            height: 40,
                                            width: 40,
                                            clipBehavior: Clip
                                                .antiAliasWithSaveLayer,
                                            child: Image.asset(
                                              "assets/german.jpg",
                                              fit: BoxFit.fill,)
                                        ),
                                        SizedBox(width: 50,),
                                        Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle),
                                          clipBehavior: Clip
                                              .antiAliasWithSaveLayer,
                                          child: Flag.fromCode(
                                            FlagsCode.GB,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20,),
                                    Container(
                                      color: Colors.blue,
                                      height: 1,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 1.2,
                                    ),
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50.0),
                                      child: CustomButton(
                                            () {

                                        },
                                        color: Colors.deepPurple[900]!,
                                        height: 50,
                                        text: "DASHBOARD",
                                        textColor: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    InkWell(
                                      onTap: () {
                                        CacheHelper.saveData(
                                            key: "uId", value: "");
                                        Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FirstScreen()), (
                                                route) => false);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: const [
                                          Icon(Icons.remove_circle_outline,
                                            color: Colors.red,),
                                          SizedBox(width: 10,),
                                          Text(
                                            "LOG OUT",
                                            style: TextStyle(
                                                color: Colors.red),)
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 40,),

                                  ],
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )

          );
        },
      ),
    );
  }
}
