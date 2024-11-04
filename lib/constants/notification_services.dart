import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../views/message_screen.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // Consistent ID
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  Future<void> initializeNotifications(BuildContext context) async {
    // Request notification permissions
    await requestNotificationPermission();

    // Create notification channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Initialize the plugin with settings
    var androidInitializationSettings =
    const AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleNotificationClick(context);
      },
    );

    // Check for any initial notification payload
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      handleNotificationClick(context);
    }
  }

  Future<void> requestNotificationPermission() async {
    await Permission.notification.request();
  }

  Future<void> showNotification({required String title, required String body}) async {
    try {
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        0, // Notification ID (use unique ID if sending multiple notifications)
        title,
        body,
        notificationDetails,
      );
    } catch (e) {
      print("Notification Error: $e");
    }
  }

  void handleNotificationClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MessageScreen()),
    );
  }
}

