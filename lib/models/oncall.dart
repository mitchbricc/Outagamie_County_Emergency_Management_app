
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outagamie_emergency_management_app/classes/oncallschedule.dart';
import '../classes/user.dart';

class OnCallModel extends ChangeNotifier {
  late User user; 
  List<String> onCallPeople = [];
  OnCallSchedule monthOnCallSchedule = OnCallSchedule(month: DateTime.now(), schedule: {});
  List<Map<String, dynamic>> teamMembers = [];
  bool loaded = false;
  OnCallModel() {  
    getPeople();
  }



  Future<void> getPeople() async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('oncall/people');
    final snapshot = await ref.get();

    if (snapshot.exists && snapshot.value is List) {
      onCallPeople = (snapshot.value as List).cast<String>();
    } else {
      print('No data available.');
    }
    await getCurrentMonth(DateTime.now());
    await getContactInfo();
    setOnCall();
    loaded = true;
    notifyListeners();
  }

  void setOnCall(){
      final f = DateFormat('yyyy-MM-dd');
      var name = monthOnCallSchedule.schedule[f.format(DateTime.now())];
      if(name != null){
        for (var i = 0; i < teamMembers.length; i++) {
          var n = teamMembers[i]['firstName'] + ' ' + teamMembers[i]['lastName'];
          if(n == name){
            teamMembers[i]['onCall'] = true;
          }
        }
      }
  }

  Future<void> getContactInfo() async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('users');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key,value){
        Map<String,dynamic> map = Map<String, dynamic>.from(value);
        teamMembers.add({
          'firstName': map['firstname'],
          'lastName': map['lastname'],
          'email': map['email'],
          'phone': map['phone'],
          'onCall': false,
        });
      });
    } else {

    }
    notifyListeners();
  }

  Future<void> getCurrentMonth(DateTime date) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('oncall/schedule');
    final f = DateFormat('yyyy-MM');
    final snapshot = await ref.child(f.format(date)).get();

    if (snapshot.exists) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
      monthOnCallSchedule = OnCallSchedule.fromMap((Map<String, dynamic>.from(data)));
    } else {

    }
    notifyListeners();
  }
}
