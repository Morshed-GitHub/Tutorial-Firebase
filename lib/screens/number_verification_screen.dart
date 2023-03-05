import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_firebase/screens/home_screen.dart';

import '../utils/utils.dart';
import '../widget/round_button.dart';

class NumberVerificationScreen extends StatefulWidget {
  final String verificationID;
  const NumberVerificationScreen({super.key, required this.verificationID});

  @override
  State<NumberVerificationScreen> createState() =>
      _NumberVerificationScreenState();
}

class _NumberVerificationScreenState extends State<NumberVerificationScreen> {
  final formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController verificationCodeController = TextEditingController();
  bool isLoading = false;

  void signInComplete() async {
    await Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Verification"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.pink,
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
              child: sixDigitVerificationCode(),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundButton(
              title: "Verify",
              loading: isLoading,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  // Firebase return's "token", which we have to store in database later
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget
                          .verificationID, // getting from previousPage "sentCode"
                      smsCode: verificationCodeController.text
                          .toString()); // Took from textFormField input

                  // In order to checkout any error, we use "try catch"
                  try {
                    setState(() {
                      // In order to show loading
                      isLoading = true;
                    });
                    auth.signInWithCredential(credential);
                    signInComplete();
                    // setState(() {
                    //   // In order to show loading
                    //   isLoading = false;
                    // });
                  } catch (error) {
                    setState(() {
                      isLoading = false;
                    });
                    Utils.toastMessage(error.toString());
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  TextFormField sixDigitVerificationCode() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: verificationCodeController,
      validator: (value) {
        if (value!.isEmpty) {
          return "6 digit code required!";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "  6 digit code",
        hintStyle: const TextStyle(letterSpacing: 2),
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
