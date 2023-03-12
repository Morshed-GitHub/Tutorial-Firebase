import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutorial_firebase/utils/utils.dart';
import 'package:tutorial_firebase/widget/appbar.dart';
import 'package:tutorial_firebase/widget/round_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../widget/select_image_file_container.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image;
  final picker = ImagePicker();

  void getImageGallery() async {
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        Utils.toastMessage("User don't picked any picture");
      }
    });
  }

  final firestoreRef = FirebaseFirestore.instance.collection("users");

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FirebaseAppBar(title: "Image Picker"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: getImageGallery,
                child: SelectImageFileContainer(image: _image),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundButton(
              title: "Upload",
              loading: isLoading,
              onTap: () {
                uploadImageFile();
              },
            )
          ],
        ),
      ),
    );
  }

  void uploadImageFile() async {
    setState(() {
      // loading starts
      isLoading = true;
    });

    // Uploading part
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(
        "/folderName/"
        "fileName"); // -> .ref("inside storage/folder name/file insider folder" + "file name")
    firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);
    String newUrlFile = await ref
        .getDownloadURL(); // Get the url of image, which is uploaded on the firebase storage

    await Future.value(uploadTask).then((value) {
      // if image file successsfully uploaded, then...

      // Storing image url in firestore part
      uploadFileLinkInFirestore(url: newUrlFile);

      setState(() {
        // Loading off
        isLoading = false;
      });
      Utils.toastMessage("File uploaded successfully ✓");
    }).onError((error, stackTrace) {
      // If any error occurs, then...
      Utils.toastMessage(error.toString());
      setState(() {
        // Loading off
        isLoading = false;
      });
    }); // Upload image, wait until file itself uploaded
  }

  Future<void> uploadFileLinkInFirestore({required String url}) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await firestoreRef.doc(id).set({
      "id": id,
      "fileUrl": url,
    });
  }
}
