import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/user.dart';


class CreateAccountModel extends ChangeNotifier {
  final _usersdb = FirebaseDatabase.instance.ref('users');
  bool isAdded = false;

  Future<void> addUser(User user) async {
    String key = makeFirebaseKeySafe(user.email);
    try {
      // _usersdb.update({key:  {
      //   'firstname': user.firstName,
      //   'lastname': user.lastName,
      //   'email': user.email,
      //   'phone': user.phone,
      //   'type': 'volunteer',
      //   'active': true,
      //   'password': user.password,
      //   'salt' : user.salt
      //   }});
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
