import 'package:flutter/material.dart';
import 'dart:io';

class SelectImageFileContainer extends StatelessWidget {
  const SelectImageFileContainer({
    super.key,
    required this.image,
  });

  final File? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: (image != null)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                image!.absolute,
                fit: BoxFit.cover,
              ),
            )
          : const Icon(
              Icons.photo_library_sharp,
              size: 50,
              color: Colors.white,
            ),
    );
  }
}
