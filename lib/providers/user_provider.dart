import 'package:flutter/material.dart';

import '../model/user_model.dart';


class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    email: '',
    uId: '', name: '',
  );

  UserModel get user => _user;

  setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
  bool isLoading =false;
  changeisLoading(bool value)
  {
    isLoading=value;
    notifyListeners();
  }
}
