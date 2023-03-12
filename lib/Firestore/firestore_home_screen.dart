import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_firebase/Firestore/firestore_add_to_post_screen.dart';
import 'package:tutorial_firebase/screens/add_to_post_screen.dart';
import 'package:tutorial_firebase/screens/image_picker_screen.dart';
import 'package:tutorial_firebase/screens/login_screen.dart';
import 'package:tutorial_firebase/utils/utils.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';

class FirestoreHomeScreen extends StatefulWidget {
  const FirestoreHomeScreen({super.key});

  @override
  State<FirestoreHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FirestoreHomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("post");

  final firestoreSnapshotRef = // In order to get the stream
      FirebaseFirestore.instance.collection("users").snapshots();
  final firestoreCollectionRef = FirebaseFirestore.instance.collection("users");

  TextEditingController searchPostController = TextEditingController();
  TextEditingController updatePostController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchPostController.dispose();
    updatePostController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: addPostButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: homeAppBar(context),

        // Real Time Database through "FlutterAnimatedList"
        body: Column(
          children: [
            searchInput(),
            // listOfItems(),

            fetchDataByStream(),
          ],
        )

        // Real Time Database through "StreamBuilder"
        // body: fetchDataByStream(),
        );
  }

  AppBar homeAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text("Firestore Home"),
      centerTitle: true,
      backgroundColor: Colors.pink,
      leading: IconButton(
        onPressed: navigateToImagePickerScreen,
        icon: const Icon(Icons.add_a_photo_sharp),
      ),
      actions: [logOutButton(context)],
    );
  }

  Future<void> navigateToImagePickerScreen() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const ImagePickerScreen(),
      ),
    );
  }

  Future<dynamic> showMyDialouge(
      {required String id, required updatedDesc}) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Update",
        ),
        content: updateInput(desc: updatedDesc),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: alertBarButtonText(title: "Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              updatePost(id: id);
            },
            child: alertBarButtonText(title: "Update"),
          ),
        ],
      ),
    );
  }

  Text alertBarButtonText({required String title}) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.pink,
      ),
    );
  }

  void moveToAddPostScreen() async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const FirestoreAddToPostScreen(),
      ),
    );
  }

  FloatingActionButton addPostButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: moveToAddPostScreen,
      elevation: 5,
      backgroundColor: Colors.pink,
      child: const Icon(Icons.add),
    );
  }

  Expanded fetchDataByStream() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        // child: StreamBuilder<QuerySnapshot>(
        stream: firestoreSnapshotRef,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // return (!snapshot.hasData)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return showCircleLoading();
          }
          if (snapshot.hasError) {
            return const Text("Oops! some error occured");
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              // itemCount: snapshot.data!.snapshot.children.length,
              itemBuilder: (context, index) {
                // Firebase Real Time Data base part
                // Map<dynamic, dynamic> map =
                //     snapshot.data!.snapshot.value
                //         as dynamic; // Storing snapshot data's into map,
                // List<dynamic> list = map.values
                //     .toList(); // then storing these map values in list

                // Firebase Firestore part
                final items = snapshot.data!.docs[index];
                final titleOfItems = items["title"].toString().toLowerCase();
                if (searchPostController.text.isEmpty) {
                  // If search bar is empty, then show all items
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(items["title"]),
                      subtitle: Text(items["id"]),
                      trailing:
                          listOptions(id: items["id"], newDesc: items["title"]),
                      // title: Text(list[index]["desc"]),
                      // subtitle: Text(
                      //     "${list[index]["Morshed"]} ${list[index]["id"]}"),
                    ),
                  );
                } else if (titleOfItems
                    .toLowerCase()
                    .contains(searchPostController.text.toLowerCase())) {
                  // Logic: Filter out the items by "search bar"
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(items["title"]),
                      subtitle: Text(items["id"]),
                      trailing:
                          listOptions(id: items["id"], newDesc: items["title"]),
                    ),
                  );
                }
              },
            );
          }
          return const Text("Nothing to show");
        },
      ),
    );
  }

  Expanded listOfItems() {
    return Expanded(
      child: FirebaseAnimatedList(
          query: ref,
          defaultChild: showCircleLoading(),
          itemBuilder: (context, sn, _, index) {
            final desc = sn.child("desc").value.toString().toLowerCase();

            if (searchPostController.text.isEmpty) {
              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text(sn.child("desc").value.toString()),
                  subtitle: Text(
                      "${sn.child("name").value.toString()} ${sn.child("id").value.toString()}"),
                  trailing: listOptions(
                    id: sn.child("id").value.toString(),
                    newDesc: sn
                        .child("desc")
                        .value
                        .toString(), // In order to show the previous "desc", which will be updated
                  ),
                ),
              );
            } else if (desc
                .toLowerCase()
                .contains(searchPostController.text.toLowerCase())) {
              return Card(
                elevation: 5,
                child: ListTile(
                  title: Text(sn.child("desc").value.toString()),
                  subtitle: Text(
                      "${sn.child("name").value.toString()} ${sn.child("id").value.toString()}"),
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }

  PopupMenuButton listOptions({required String id, required newDesc}) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert_outlined),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit"),
            onTap: () async {
              Navigator.pop(
                  context); // In order to off the "listOptions" just after pressing "edit"
              await showMyDialouge(id: id, updatedDesc: newDesc);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete_forever_outlined),
            title: const Text("Delete"),
            onTap: () async {
              Navigator.pop(context);
              // await ref.child(id).remove();
              await firestoreCollectionRef.doc(id).delete();
            },
          ),
        ),
      ],
    );
  }

  Widget updateInput({required String desc}) {
    updatePostController.text = desc;
    return TextFormField(
      controller: updatePostController,
      decoration: InputDecoration(
          labelText: "Update",
          labelStyle: const TextStyle(
            color: Colors.pink,
          ),
          prefixIcon: const Icon(Icons.update_outlined),
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

  Padding searchInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
      child: TextFormField(
        controller: searchPostController,
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
            labelText: "Search",
            labelStyle: const TextStyle(
              color: Colors.pink,
            ),
            prefixIcon: const Icon(Icons.search_rounded),
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
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  Center showCircleLoading() {
    return const Center(
        child: CircularProgressIndicator(
      color: Colors.pink,
    ));
  }

  void moveToLoginScreen() {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  IconButton logOutButton(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await auth.signOut().then((value) {
            Utils.toastMessage("Account Logout Successful ✓");
            moveToLoginScreen();
          }).onError((error, stackTrace) {
            // if error occurs,
            Utils.toastMessage(error.toString());
          });
        },
        icon: const Icon(Icons.logout_outlined));
  }

  updatePost({required String id}) async {
    await firestoreCollectionRef.doc(id).update({
      "title": updatePostController.text,
    });
  }
}
