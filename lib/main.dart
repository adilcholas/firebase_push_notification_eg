import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_push_notification_eg/providers/notification_provider.dart';
import 'package:firebase_push_notification_eg/view/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'services/notification_service.dart';  

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    final notifierProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    NotificationService().setUpInteractedMessage((remoteMessage) {
      notifierProvider.addMessage(remoteMessage);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationScreen(),
    );
  }
}
