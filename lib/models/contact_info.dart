import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/user.dart';


class ContactInfoModel extends ChangeNotifier {
  List<User> people = [];
  final _usersdb = FirebaseDatabase.instance.ref('users');
  bool isLoaded = false;

  Future<void> getVolunteers() async {
  try {
       Map<String, dynamic> map = {};
       await _usersdb.get().then((snapshot) {
        map = Map<String, dynamic>.from(snapshot.value as Map);
        map.forEach((key, value) async {
        User user = User.fromMap(jsonDecode(jsonEncode(map[key])));
        people.add(user);
        });
        isLoaded = true;
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }

}

}
