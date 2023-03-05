import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/number_login_screen.dart';

class MobileConnectOption extends StatelessWidget {
  const MobileConnectOption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void moveToNumberLoginInputScreen() {
      Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => const NumberLoginScreen()));
    }

    return Column(
      children: [
        GestureDetector(
          onTap: moveToNumberLoginInputScreen,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration:
                BoxDecoration(color: Colors.pink[600], shape: BoxShape.circle),
            child: const Icon(
              Icons.phone_android,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Phone",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
