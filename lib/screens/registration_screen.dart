import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_firebase/Firestore/firestore_home_screen.dart';
import 'package:tutorial_firebase/screens/home_screen.dart';
import 'package:tutorial_firebase/screens/login_screen.dart';
import 'package:tutorial_firebase/utils/utils.dart';
import 'package:tutorial_firebase/widget/other_using_options.dart';
import 'package:tutorial_firebase/widget/round_button.dart';

import '../widget/appbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // TextController holds the value/ input of TextFormField programmatically.
  //          MyController.text = 'new value' == (value){}

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void moveToHomeScreenWithSignup() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Enter into procedure then loading starts
      });

      _auth
          .createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      )
          .then((value) async {
        Utils.toastMessage("Account Registered Successfully ✓");

        // Procedure done then loading stops
        setState(() {
          isLoading = false;
        });

        await Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => const FirestoreHomeScreen()));

        setState(
            () {}); // Refresh screen in order to clear the "Email" & "Password" from login page (Pop action case)
      }).onError((error, stackTrace) {
        // When getting error,
        Utils.toastMessage(
          // show the error message through flutter toast
          error.toString(),
        );
        setState(() {
          // loading stops on error
          isLoading = false;
        });
      });
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FirebaseAppBar(title: "Signup"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        nameInput(
                          prefixName: "First",
                          controller: firstNameController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        nameInput(
                          prefixName: "Last",
                          controller: lastNameController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        emailInput(),
                        const SizedBox(
                          height: 20,
                        ),
                        passwordInput(),
                        const SizedBox(
                          height: 20,
                        ),
                        confirmPasswordInput(),
                      ],
                    )),
                const SizedBox(
                  height: 30,
                ),
                RoundButton(
                  title: "Sign Up",
                  loading: isLoading,
                  onTap: () {
                    moveToHomeScreenWithSignup();
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                accountQuery(context),
                const SizedBox(
                  height: 10,
                ),
                const OtherUsingOptions()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row accountQuery(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(
          width: 7,
        ),
        GestureDetector(
          onTap: () async {
            await Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (context) => const LoginScreen()));
          },
          child: const Text(
            "Login",
            style: TextStyle(
              color: Colors.pink,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  TextFormField confirmPasswordInput() {
    return TextFormField(
      obscureText: true,
      controller: confirmPasswordController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Confirm password can't be empty";
        } else if (value.length < 6) {
          return "Confirm password length should be atleast 6";
        } else if (passwordController.text != confirmPasswordController.text) {
          return "Both passwords are not same";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Confirm Password",
          labelStyle: const TextStyle(color: Colors.red),
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          prefixIconColor: Colors.pink,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.pink,
              )),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.pink,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      obscureText: true,
      controller: passwordController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password can't be empty";
        } else if (value.length < 6) {
          return "Password length should be atleast 6";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Password",
          labelStyle: const TextStyle(
            color: Colors.pink,
          ),
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          prefixIconColor: Colors.pink,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.pink,
              )),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.pink),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );
  }

  TextFormField emailInput() {
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
          prefixIcon: const Icon(Icons.email_outlined),
          prefixIconColor: Colors.pink,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.pink,
              )),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.pink),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );
  }

  TextFormField nameInput(
      {String? prefixName, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return "$prefixName name can't be empty";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "$prefixName Name",
          labelStyle: const TextStyle(
            color: Colors.pink,
          ),
          prefixIcon: const Icon(Icons.email_outlined),
          prefixIconColor: Colors.pink,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.pink,
              )),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.pink),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );
  }
}
