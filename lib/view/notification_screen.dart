import 'package:firebase_push_notification_eg/providers/notification_provider.dart';
import 'package:firebase_push_notification_eg/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Cloud Messaging(FCM) Example")),

      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.messages.isEmpty) {
            return Center(
              child: Text("No messages yet, please add a message to continue!"),
            );
          }
          return ListView.builder(
            itemCount: provider.messages.length,
            itemBuilder: (context, index) {
              final msg = provider.messages[index];
              return Card(
                margin: EdgeInsets.all(4),
                child: ListTile(
                  title: Text(msg.notification?.title ?? "No title"),
                  subtitle: Text(msg.notification?.body ?? "No body"),
                  leading: Icon(Icons.notifications),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? token = await NotificationService().getToken();

          debugPrint("FCM Token : $token");

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Token recieved!")));
        },

        child: Icon(Icons.token),
      ),
    );
  }
}
