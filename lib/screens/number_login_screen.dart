import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_firebase/screens/number_verification_screen.dart';
import 'package:tutorial_firebase/utils/utils.dart';
import 'package:tutorial_firebase/widget/round_button.dart';

import '../widget/appbar.dart';

class NumberLoginScreen extends StatefulWidget {
  const NumberLoginScreen({super.key});

  @override
  State<NumberLoginScreen> createState() => _NumberLoginScreenState();
}

class _NumberLoginScreenState extends State<NumberLoginScreen> {
  final formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController mobileNumberController = TextEditingController();
  bool isLoading = false;

  void moveToMobileNumberVerificationScreen() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      auth.verifyPhoneNumber(
          phoneNumber: mobileNumberController.text,
          verificationCompleted: (_) {
            setState(() {
              isLoading = false;
            });
          },
          verificationFailed: (error) {
            setState(() {
              isLoading = false;
            });
            Utils.toastMessage(error.toString());
          },
          codeSent: (verificationId, forceResendingToken) async {
            setState(() {
              isLoading = false;
            });
            await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    NumberVerificationScreen(verificationID: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (error) {
            setState(() {
              isLoading = false;
            });
            // In case, time out of 1 minute
            Utils.toastMessage(error.toString());
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FirebaseAppBar(
        title: "Login with number",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "You number will safe with us. We won't share your details with anyone.",
              style: TextStyle(
                fontSize: 18,
                height: 1.75,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: mobileNumberInput(),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundButton(
              title: "Get OTP",
              loading: isLoading,
              onTap: () {
                moveToMobileNumberVerificationScreen();
              },
            )
          ],
        ),
      ),
    );
  }

  TextFormField mobileNumberInput() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: mobileNumberController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Mobile number is required!";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "+1 234 3455 234",
        hintStyle: const TextStyle(letterSpacing: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.pink,
            )),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.pink),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
