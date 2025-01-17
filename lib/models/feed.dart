import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/chat.dart';


class FeedModel extends ChangeNotifier {
  late Chat chat;
  final _chatsdb = FirebaseDatabase.instance.ref('chats');
  bool isLoaded = false;

  Future<void> getChat(String eventId, String eventName) async {
    try {
      
       Map<String, dynamic> map = {};
       await _chatsdb.child(eventId).get().then((snapshot) async {
        if(!snapshot.exists){
          await updateChat(Chat(eventName: eventName, eventId: eventId, messages: []));
          await getChat(eventId, eventName);
          return;
        }
        map = Map<String, dynamic>.from(snapshot.value as Map);
      });
      chat = Chat.fromMap(map);
      notifyListeners();
    } catch (e) {
      print(e);
    }
    isLoaded = true;
  }

  Future<void> updateChat(Chat chat) async {

    try {
      _chatsdb.update({chat.eventId :  chat.toMap()});
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

}
