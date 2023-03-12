import 'package:flutter/material.dart';

class FirebaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonEnabled;

  const FirebaseAppBar(
      {Key? key, required this.title, this.isBackButtonEnabled = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),
      centerTitle: true,
      leading: isBackButtonEnabled
          ? IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_sharp))
          : const SizedBox(),
      backgroundColor: Colors.pink,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
