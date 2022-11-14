import 'package:flutter/material.dart';

import '../model/adminmodel.dart';

class AdminMode extends ChangeNotifier{
  AdminModel _admin = AdminModel(
    email: '',
    uId: '', name: '',
  );

  AdminModel get admin => _admin;

  setAdmin(AdminModel admin) {
    _admin = admin;
    notifyListeners();
  }

  bool isAdmin=false;
  changeisadmin(bool value)
  {
    isAdmin=value;
  }



}