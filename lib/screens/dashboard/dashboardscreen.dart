import 'package:flutter/material.dart';
import 'package:sls/screens/widget/custom_button.dart';

import '../../resources/firestore_methods.dart';
import '../../utils/utils.dart';
import '../account/account_screen.dart';
import '../broadcast/broadcast_screen.dart';
import '../go_live_screen.dart';
import '../member_requests/member_requests_screen.dart';
import '../widget/custom_text.dart';

class Dashboardscreen extends StatefulWidget {
bool isseller;
String userid;
String username;
Dashboardscreen({required this.isseller,required this.userid,required this.username});
  @override
  State<StatefulWidget> createState() => Dashboardstate();
}

class Dashboardstate extends State<Dashboardscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[700],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 120.0),
                    child: Text(
                      "DASHBOARD",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      MaterialPageRoute(
                          builder: (context) =>
                              AccountScreen());
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              ],
            ),
            SizedBox(height: 10,),
            Container(
              width:double.infinity,height:3 ,color: Colors.white,padding: EdgeInsets.symmetric(horizontal: 15),
            ),
            SizedBox(height: 5,),
            Container(
              width:double.infinity,height:70 ,padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Expanded(flex:1,child: Column(children: [
                    Text("Total Revenue",style: TextStyle(color: Colors.indigo[700],fontSize: 15),),
                    Text("${0.00}\$",style: TextStyle(color: Colors.indigo[200],fontSize: 20,fontWeight: FontWeight.bold,),),

                  ],)),
                  Container(width: 3,height: double.infinity,color: Colors.grey,),
                  Expanded(flex:1,child: Column(children: [
                    Text("Orders",style: TextStyle(color: Colors.indigo[700],fontSize: 15),),
                    Text("${0}\$",style: TextStyle(color: Colors.indigo[700],fontSize: 20,fontWeight: FontWeight.bold,),),

                  ],)),
                  Container(width: 3,height: double.infinity,color: Colors.grey,),
                  Expanded(flex:1,child: Column(children: [
                    Text("Followers",style: TextStyle(color: Colors.indigo[700],fontSize: 15),),
                    Text("${11}\$",style: TextStyle(color: Colors.indigo[700],fontSize: 20,fontWeight: FontWeight.bold,),),
                  ],)
                  ),
                ],
              ),

            ),
            SizedBox(height: 10,),
            Container(
              width:double.infinity,height:3 ,color: Colors.grey,padding: EdgeInsets.symmetric(horizontal: 15),
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){},
              child: Container(
                width:double.infinity,height:70 ,padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                child: ListTile(leading:Icon(Icons.event_note_outlined) ,title:CustomText(text: "All Order",font: 20,color: Colors.indigo[700],fontWeight: FontWeight.bold,) ,trailing: Icon(Icons.arrow_forward_ios,color: Colors.indigo[300],),),
              ),
            ),
            SizedBox(height: 5,),
            InkWell(
              onTap: (){},
              child: Container(
                width:double.infinity,height:70 ,padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                child: ListTile(leading:Icon(Icons.payment) ,title:CustomText(text: "Payment Details",font: 20,color: Colors.indigo[700],fontWeight: FontWeight.bold,) ,trailing: Icon(Icons.arrow_forward_ios,color: Colors.indigo[300],),),
              ),
            ),
            SizedBox(height: 5,),
            InkWell(
              onTap: (){},
              child: Container(
                width:double.infinity,height:70 ,padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                child: ListTile(leading:Icon(Icons.payments_outlined) ,title:CustomText(text: "Pay to the app",font: 20,color: Colors.indigo[700],fontWeight: FontWeight.bold,) ,trailing: Icon(Icons.arrow_forward_ios,color: Colors.indigo[300],),),
              ),
            ),
            SizedBox(height: 5,),
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => memberrequestscreen()));
              },
              child: Visibility(
                visible:!widget.isseller,
                child: Container(
                  width:double.infinity,height:80 ,padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                  child: ListTile(leading:Icon(Icons.people_outline) ,title:CustomText(text: "New Member",font: 20,color: Colors.indigo[700],fontWeight: FontWeight.bold,) ,trailing: Icon(Icons.arrow_forward_ios,color: Colors.indigo[300],),),
                ),
              ),
            ),
            SizedBox(height: 5,),
            InkWell(
              onTap: (){},
              child: Visibility(
                visible:!widget.isseller,
                child: Container(
                  width:double.infinity,height:80 ,padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                  child: ListTile(leading:Icon(Icons.waves) ,title:CustomText(text: "New Seller",font: 20,color: Colors.indigo[700],fontWeight: FontWeight.bold,) ,trailing: Icon(Icons.arrow_forward_ios,color: Colors.indigo[300],),),
                ),
              ),
            ),
            SizedBox(height: 5,),
             InkWell(
               onTap: (){},
              child: Visibility(
                  visible:!widget.isseller,
                child: Container(
                  width:double.infinity,height:80 ,padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                  child: ListTile(leading:Icon(Icons.live_tv_sharp) ,title:CustomText(text: "New Live Revenue",font: 20,color: Colors.indigo[700],fontWeight: FontWeight.bold,) ,trailing: Icon(Icons.arrow_forward_ios,color: Colors.indigo[300],),),
                ),
              ),
            ),
            SizedBox(height: 5,),
            InkWell(
              onTap: (){},
              child: Visibility(
                visible:!widget.isseller,
                child: Container(
                  width:double.infinity,height:80 ,padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                  child: ListTile(leading:Icon(Icons.wifi_tethering) ,title:CustomText(text: "Live Now",font: 20,color: Colors.indigo[700],fontWeight: FontWeight.bold,) ,trailing: Icon(Icons.arrow_forward_ios,color: Colors.indigo[300],),),
                ),
              ),
            ),
            CustomButton((){
              goLiveStream();
            },text: "go live".toUpperCase(),textColor: Colors.white,color: Colors.red,font: 25,radius: 15,width: double.infinity-15,)


          ],
        ),
      ),
    );
  }
  goLiveStream() async {
    // String channelId = await FirestoreMethods()
    //     .startLiveStream(context,widget.userid,true);

    //if (channelId.isNotEmpty) {
      showSnackBar(context, 'Livestream has started successfully!');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BroadcastScreen(
            isBroadcaster: true,
            channelId: "${widget.userid}${widget.username}",
            userid: widget.userid,

          ),
        ),
      );
   // }
  }
}
