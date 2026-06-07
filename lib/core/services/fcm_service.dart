import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../firebase_options.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await _requestPermission();

    _getToken();

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_onOpenNotification);

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }

  static Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static void _getToken() async {
    final token = await _messaging.getToken();
    print("🔥 FCM TOKEN: $token");
  }

  static void _onForegroundMessage(RemoteMessage message) {
    print("📩 Foreground:");
    print(message.notification?.title);
    print(message.notification?.body);
  }

  static void _onOpenNotification(RemoteMessage message) {
    print("👉 Clicked Notification");
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print("📥 Background:");
    print(message.notification?.title);
  }
}