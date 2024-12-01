import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../res/colors.dart';
import 'navigation.dart';
import 'signup_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      user != null
          ? Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Navigation()))
          : Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SignupScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var heightX = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colours.kScaffoldColor,
      body: Stack(
        children: [
          Container(
            height: heightX * 1,
            color: Colours.kGreenColor,
            child: Center(
                child: Text(
              'Welcome To SEA',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ],
      ),
    );
  }
}
