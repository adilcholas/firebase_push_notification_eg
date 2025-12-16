import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling background message: ${message.messageId}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  //Initialization of Firebase, Flutter Local Notification
  Future<void> initialize() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("User authorized");
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(
      initializationSettings,

      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
            debugPrint("Notification Resopnse $notificationResponse");
          },
    );
  }

  //Method Calling

  void setUpInteractedMessage(Function(RemoteMessage) remoteMessage) {
    // On Killed
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        onMessageReceived(remoteMessage);
      }
    });

    //On Background

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      onMessageReceived(remoteMessage);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      _showLocalNotification(remoteMessage);

      onMessageReceived(remoteMessage);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage? remoteMessage) async {
    RemoteNotification? notification = remoteMessage!.notification;

    AndroidNotification? android = remoteMessage.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // Channel ID
            'High Importance Notifications', // Channel Name
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: remoteMessage.data.toString(),
      );
    }

    // await _localNotifications.show(
    //   notification.hashCode,
    //   notification!.title,
    //   notification.body,
    //   NotificationDetails(),
    // );
  }

  void onMessageReceived(RemoteMessage? remoteMessage) {
    debugPrint(remoteMessage!.data['title']);
  }

  Future<String?> getToken() async {
    return _firebaseMessaging.getToken();
  }
}
