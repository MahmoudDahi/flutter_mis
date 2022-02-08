import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification {
  final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'mis_channel', // 
    'mis', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
    enableLights: true,
    
    enableVibration: true,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialise() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    final _fcm = FirebaseMessaging.instance;

    _fcm.getToken().then((value) => print('token is :$value'));

    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onselectNotification);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen(_showNotification);

      FirebaseMessaging.onBackgroundMessage(_showNotification);

       flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    var notification = message.data;
    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification['title'],
        notification['body'],
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id, channel.name,
            channelDescription: channel.description,
            priority: Priority.max,
            // other properties...
          ),
        ),
        payload: notification['onClick'],
      );
    }
  }

  void _onselectNotification(String id) async {
    print(id);
    // await Navigator.of(context).pushNamed(
    //   SplashScreen.routeName,
    //   arguments: id,
    // );
  }
}
