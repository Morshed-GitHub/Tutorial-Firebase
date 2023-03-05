import 'package:flutter/material.dart';
import 'mobile_connection_option.dart';

class OtherUsingOptions extends StatelessWidget {
  const OtherUsingOptions({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            // "Or connect with"  part
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 3,
                  width: (screenWidth / 4.5),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const Text(
                  " Or connect using ",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: 3,
                  width: (screenWidth / 4.5),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),

            // Mobile Verification Rounded Button
            const MobileConnectOption()
          ],
        ),
      ),
    );
  }
}
