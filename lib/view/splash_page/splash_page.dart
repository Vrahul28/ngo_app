import 'package:flutter/material.dart';
import 'package:ngo_app/view_models/splash_service/splash_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashService s= SplashService();

  @override
  void initState() {
    super.initState();
    s.login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/logo.jpeg'),
      ),
    );
  }
}
