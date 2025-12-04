import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MealApp());
}

class MealApp extends StatelessWidget {
  const MealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission on iOS
    messaging.requestPermission(alert: true, badge: true, sound: true);

    // Print FCM token (you’ll use this to send a test notification)
    messaging.getToken().then((token) {
      print('FCM Token: $token');
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a foreground message: ${message.notification?.title}');
    });

    // When app opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.notification?.title}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Firebase Messaging Test')));
  }
}
