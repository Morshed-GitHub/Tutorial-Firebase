import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_firebase/utils/utils.dart';
import 'package:tutorial_firebase/widget/round_button.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirestoreAddToPostScreen extends StatefulWidget {
  const FirestoreAddToPostScreen({super.key});

  @override
  State<FirestoreAddToPostScreen> createState() => _AddToPostScreenState();
}

class _AddToPostScreenState extends State<FirestoreAddToPostScreen> {
  TextEditingController newPostController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // final databaseRef = FirebaseDatabase.instance.ref("post");

  // Firestore is a non relational database
  final firestoreRef = FirebaseFirestore.instance
      .collection("users"); // Creating "collection" in firestore
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Firestore Add to Post"),
        centerTitle: true,
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: newPostInput(newPostController),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundButton(
                title: "Post",
                loading: isLoading,
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });

                    // Getting id's by millisecond as it is always unique
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    await firestoreRef.doc(id).set({
                      // Setting data into "firestore"
                      "title": newPostController.text,
                      "id": id,
                    }).then((value) {
                      // if successfully posted....
                      setState(() {
                        isLoading = false;
                      });
                      Utils.toastMessage("User posted successfully ✓");
                    }).onError((error, stackTrace) {
                      setState(() {
                        isLoading = false;
                      });
                      Utils.toastMessage(error.toString());
                    });
                  }
                })
          ],
        ),
      ),
    );
  }

  TextFormField newPostInput(TextEditingController newPostController) {
    return TextFormField(
      controller: newPostController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Post is empty";
        }
        return null;
      },
      maxLines: 4,
      decoration: InputDecoration(
        labelText: "Post",
        labelStyle: const TextStyle(
          color: Colors.pink,
        ),
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
