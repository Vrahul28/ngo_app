import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ngo_app/res/app_colors/app_colors.dart';
import 'package:ngo_app/res/routes/routes.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

