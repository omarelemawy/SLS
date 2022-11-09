import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../providers/user_provider.dart';


class AuthMethods {
  final _userRef = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getCurrentUser(String? uid) async {
    if (uid != null) {
      final snap = await _userRef.doc(uid).get();
      return snap.data();
    }
    return null;
  }

  Future<bool> sigpUser(
    BuildContext context,
    String email,
    String username,
    String password,
  ) async {
    bool res = false;
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (cred.user != null) {
        UserModel user = UserModel(
          name: username.trim(),
          email: email.trim(),
          uId: cred.user!.uid,
        );
        await _userRef.doc(cred.user!.uid).set(user.toMap());
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        res = true;
      }
    } on FirebaseAuthException catch (e) {
    //  showSnackBar(context, e.message!);
    }
    return res;
  }

  Future<bool> lognUser(
    BuildContext context,
    String email,
    String password,
  ) async {
    bool res = false;
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (cred.user != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(
         UserModel.fromJson(
            await getCurrentUser(cred.user!.uid) ?? {},
          ),
        );
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("**********"+e.message!);

    }
    return res;
  }
}
