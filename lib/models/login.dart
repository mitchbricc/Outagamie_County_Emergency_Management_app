import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/user.dart';


class LoginModel extends ChangeNotifier {
  late User user; 
  final _usersdb = FirebaseDatabase.instance.ref('users');

//   void printMapContents(Map<String, dynamic> map, {int indent = 0}) {
//   final indentString = ' ' * indent;

//   map.forEach((key, value) {
//     if (value is Map<String, dynamic>) {
//       print('$indentString$key:');
//       printMapContents(value, indent: indent + 2); 
//     } else {
//       print('$indentString$key: $value');
//     }
//   });
// }


  Future<void> fetchPassword(String email) async {
    String key = makeFirebaseKeySafe(email);
    try {
       Map<String, dynamic> map = {};
       await _usersdb.child(key).get().then((snapshot) {
        map = Map<String, dynamic>.from(snapshot.value as Map);
      });
      if(map['password'] == null){
        user = User(eventRecords: [], email: email, password: 'not found', firstName: 'not found', lastName: 'not found', type: 'not found', phone: 'not found', salt: 'not found');
      }
      //user = User(email: email, password: map['password'], firstName: map['firstname'], lastName: map['lastname'], type: map['type'], phone: map['phone'], salt: map['salt']);
      user = User.fromMap(map);
      notifyListeners();
    } catch (e) {
      print(e);
    }

    // _usersdb.onValue.listen((event) {
    //   user = User.fromRTDB(event.snapshot.value);
    //   notifyListeners();
    // });
  }

  String makeFirebaseKeySafe(String input) {
  final forbiddenCharacters = RegExp(r'[.$\[\]#/]');
  return input.replaceAll(forbiddenCharacters, '');
}

}
