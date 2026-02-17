import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngo_app/res/app_colors/app_colors.dart';
import 'package:ngo_app/res/routes/routes.dart';
import 'package:ngo_app/view_models/notification_service/local_notification_service.dart';
import 'firebase_options.dart';


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("Background Notification Received: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 1️⃣ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// 2️⃣ Initialize Local Notification Channel
  await LocalNotificationService.initialize();

  /// 3️⃣ Register background handler (MUST BE BEFORE runApp)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  /// 4️⃣ Ask notification permission (Android 13+ + iOS)
  NotificationSettings settings =
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  debugPrint("Permission status: ${settings.authorizationStatus}");

  /// 5️⃣ Force FCM to generate token on app start
  String? token = await FirebaseMessaging.instance.getToken();

  debugPrint("FCM TOKEN AT APP START: $token");

  /// 6️⃣ Token refresh listener (VERY IMPORTANT)
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    debugPrint("FCM TOKEN REFRESHED: $newToken");
    // later we will update Firestore here
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NGO Hope Foundation',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme()
        ),
      getPages: Routes.appRoutes(),
    );
  }
}

