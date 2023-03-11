import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_firebase/utils/utils.dart';
import 'package:tutorial_firebase/widget/appbar.dart';

import '../widget/round_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;
  final String checkEmailMessage =
      "Check Email\nWe just sent you an email with a link to reset your password 🙂";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FirebaseAppBar(title: "Forget Password"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            emailInput(emailController),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: "Send Email",
              loading: isLoading,
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                await auth
                    .sendPasswordResetEmail(
                        email: emailController.text) // Reset email sending here
                    .then((value) {
                  // if successfully done, then...
                  setState(() {
                    isLoading = false;
                  });
                  Utils.toastMessage(checkEmailMessage);
                }).onError((error, stackTrace) {
                  // if any error occurs, then...
                  setState(() {
                    isLoading = false;
                  });
                  Utils.toastMessage(error.toString());
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  TextFormField emailInput(TextEditingController emailController) {
    return TextFormField(
      controller: emailController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Email can't be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: const TextStyle(
          color: Colors.pink,
        ),
        hintText: "example@gmail.com",
        prefixIcon: const Icon(Icons.mark_email_unread_sharp),
        prefixIconColor: Colors.pink,
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
