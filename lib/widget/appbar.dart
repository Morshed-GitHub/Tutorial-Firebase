import 'package:flutter/material.dart';

class FirebaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const FirebaseAppBar({Key? key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.pink,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
