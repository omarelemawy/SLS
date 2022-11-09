import 'dart:io';

import 'package:flutter/material.dart';

import '../model/livestream.dart';

class LiveProvider extends ChangeNotifier {
  LiveStream _live = LiveStream(username: '', channelId: '', viewers:0, uid: '',photoprofile:'', startedAt:0,islive: false,record: ''
  );

  LiveStream get live => _live;

  setlive(LiveStream live) {
    _live = live;
    notifyListeners();
  }
  bool isLoading =false;
  changeisLoading(bool value)
  {
    isLoading=value;
    notifyListeners();
  }
}