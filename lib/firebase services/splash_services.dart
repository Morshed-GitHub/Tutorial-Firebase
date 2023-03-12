import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:tutorial_firebase/Firestore/firestore_home_screen.dart';
import 'package:tutorial_firebase/screens/image_picker_screen.dart';
import 'package:tutorial_firebase/screens/login_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      // Check if user is signed in,
      Timer(
          const Duration(
            seconds: 2,
          ), () async {
        await Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            // builder: (context) => const HomeScreen(),
            // builder: (context) => const FirestoreHomeScreen(),
            builder: (context) => const FirestoreHomeScreen(),
          ),
        );
      });
    } else {
      // else if user not signed in then,
      Timer(
          const Duration(
            seconds: 2,
          ), () async {
        await Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => const LoginScreen()));
      });
    }
  }
}
