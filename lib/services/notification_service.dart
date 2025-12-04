import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Local notifications (Android & iOS)
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification tapped: ${details.payload}');
      },
    );

    // FCM background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showLocalNotification(
          message.notification!.title ?? 'Title',
          message.notification!.body ?? 'Body',
        );
      }
    });
  }

  static Future<void> showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'Channel Name',
          channelDescription: 'Description',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      0,
      title,
      body,
      platformDetails,
      payload: 'item x',
    );
  }
}

// Background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseMessaging.instance;
  debugPrint('Handling a background message: ${message.messageId}');
}
