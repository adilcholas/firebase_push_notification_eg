import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  final List<RemoteMessage> _messages = [];

  List<RemoteMessage> get messages => _messages;

  void addMessage(RemoteMessage message) {
    _messages.add(message);

    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
