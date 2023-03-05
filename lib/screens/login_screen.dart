import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutorial_firebase/screens/home_screen.dart';
import 'package:tutorial_firebase/screens/registration_screen.dart';
import 'package:tutorial_firebase/utils/utils.dart';
import 'package:tutorial_firebase/widget/other_using_options.dart';
import 'package:tutorial_firebase/widget/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void moveToHomeScreen() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        // Pressing "login" button, that time showing CirculaProgressIndicator
        isLoading = true;
      });
      _auth
          .signInWithEmailAndPassword(
        // Email & password verification
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      )
          .then((value) async {
        setState(() {
          // If login successful, then loading off
          isLoading = false;
        });
        Utils.toastMessage(
            // "${value.user!.email.toString()} login successful ✓"); // -> By using [value.user], we can access user properties
            "Account login successful ✓");

        // If verfied, then navigate to home_page
        await Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => const HomeScreen()));
        setState(
            () {}); // Refresh screen in order to clear the "Email" & "Password" from login page (Pop action case)
      }).onError((error, stackTrace) {
        setState(() {
          // if error occurs, then loading off
          isLoading = false;
        });
        // if error occurs,
        // then show error message on toast
        Utils.toastMessage(error.toString());
      });
    }
  }

  // TextController holds the value/ input of TextFormField programmatically.
  //          MyController.text = 'new value' == (value){}

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double availableScreenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      // Android User's can simply exit from app by pressing back button
      onWillPop: () async {
        await SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Login"),
          centerTitle: true,
          backgroundColor: Colors.pink,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          shrinkWrap: true,
          children: [
            SizedBox(
              height: availableScreenHeight * .15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        emailInput(),
                        const SizedBox(
                          height: 20,
                        ),
                        passwordInput(),
                      ],
                    )),
                const SizedBox(
                  height: 30,
                ),
                RoundButton(
                  title: "Login",
                  loading: isLoading,
                  onTap: () {
                    moveToHomeScreen();
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                signupQueryOption(context),
                const SizedBox(
                  height: 10,
                ),
                const OtherUsingOptions(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row signupQueryOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
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
            await Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => const SignupScreen(),
                ));
          },
          child: const Text(
            "Sign up",
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
        prefixIcon: const Icon(Icons.lock_outline_rounded),
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
        hintText: "example@gmail.com",
        prefixIcon: const Icon(Icons.email_outlined),
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
