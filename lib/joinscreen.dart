import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sls/resources/firestore_methods.dart';
import 'package:sls/responsive/resonsive_layout.dart';
import 'package:sls/screens/broadcast/broadcast_screen.dart';
import 'package:sls/screens/widget/video_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:io';
import 'model/livestream.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(
            top: 10,
          ),
          child: Column(
            children: [
              const Text(
                'Live Users',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              StreamBuilder<dynamic>(
                stream: FirebaseFirestore.instance
                    .collection('livestreamimage')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return Expanded(
                    child: ResponsiveLatout(
                      desktopBody: GridView.builder(
                        itemCount: snapshot.data.docs.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          LiveStream post = LiveStream.fromMap(
                              snapshot.data.docs[index].data());
                          return InkWell(
                            onTap: () async {
                              await FirestoreMethods()
                                  .updateViewCount(post.channelId, true);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BroadcastScreen(
                                    isBroadcaster: false,
                                    channelId: post.channelId,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.35,
                                    child: VideoWidget(File(" "))
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.username,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),

                                      Text('${post.viewers} watching'),
                                      Text(
                                        'Started ${timeago.format(post.startedAt.toDate())}',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      mobileBody: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            LiveStream post = LiveStream.fromMap(
                                snapshot.data.docs[index].data());

                            return InkWell(
                              onTap: () async {
                                await FirestoreMethods()
                                    .updateViewCount(post.channelId, true);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BroadcastScreen(
                                      isBroadcaster: false,
                                      channelId: post.channelId,

                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: size.height * 0.1,
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: VideoWidget(File(snapshot.data.docs[index]["record"])),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.username,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),

                                        Text('${post.viewers} watching'),
                                        Text(
                                          'Started ${timeago.format(post.startedAt.toDate())}',
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.more_vert,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
