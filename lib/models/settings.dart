import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/user.dart';


class SettingsModel extends ChangeNotifier {
  final _usersdb = FirebaseDatabase.instance.ref('users');
  bool isLoaded = false;
  List<Map<String, dynamic>> volunteers = [];

  Future<void> updateUser(User user) async {
    String key = makeFirebaseKeySafe(user.email);
    try {
      _usersdb.update({key:  user.toMap()});
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  String makeFirebaseKeySafe(String input) {
    final forbiddenCharacters = RegExp(r'[.$\[\]#/]');
    return input.replaceAll(forbiddenCharacters, '');
  }
}
