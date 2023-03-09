import 'package:flutter/material.dart';
import 'package:tutorial_firebase/utils/utils.dart';
import 'package:tutorial_firebase/widget/round_button.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class AddToPostScreen extends StatefulWidget {
  const AddToPostScreen({super.key});

  @override
  State<AddToPostScreen> createState() => _AddToPostScreenState();
}

class _AddToPostScreenState extends State<AddToPostScreen> {
  TextEditingController newPostController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final databaseRef = FirebaseDatabase.instance.ref("post");
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Add to Post"),
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

                    // Post in Firebase Real Time Database
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    await databaseRef.child(id).set({
                      "id": id,
                      "name": "Morshed",
                      "desc": newPostController.text.toString(),
                    }).then((value) {
                      // If post successfully posted, then....
                      setState(() {
                        isLoading = false;
                      });
                      Utils.toastMessage("Post added successfully ✓");
                    }).onError((error, stackTrace) {
                      // if any error occurs....
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
