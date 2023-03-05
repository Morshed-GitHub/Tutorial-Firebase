import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_firebase/screens/login_screen.dart';
import 'package:tutorial_firebase/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
              onPressed: () async {
                await auth.signOut().then((value) {
                  Utils.toastMessage("Account Logout Successful ✓");
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                }).onError((error, stackTrace) {
                  // if error occurs,
                  Utils.toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: const Center(
        child: Text(
          "Home Screen",
          style: TextStyle(
            color: Colors.pink,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
