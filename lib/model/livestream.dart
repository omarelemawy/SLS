import 'dart:convert';
import 'dart:io';

class LiveStream {

  final String uid;
  final String username;
  final startedAt;
  final String photoprofile;
  final int viewers;
  final String channelId;
  final bool islive;
 final String record;
  LiveStream({
    required this.uid,
    required this.username,
    required this.viewers,
    required this.channelId,
    required this.startedAt,
    required this.photoprofile,
    required this.record,
    required this.islive
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'viewers': viewers,
      'channelId': channelId,
      'startedAt': startedAt,
      'islive':islive,
      'photoprofile':photoprofile,
      'record':record,

    };
  }

  factory LiveStream.fromMap(Map<String, dynamic> map) {
    return LiveStream(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      viewers: map['viewers']?.toInt() ?? 0,
      channelId: map['channelId'] ?? '',
      photoprofile:map['photoprofile']??'',
      startedAt: map['startedAt'] ?? '', //record:map['record'] ??"",
      islive: map['islive'] ?? false,
      record: map['record'] ?? false,
    );
  }
}
