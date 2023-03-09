import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutorial_firebase/screens/add_to_post_screen.dart';
import 'package:tutorial_firebase/screens/login_screen.dart';
import 'package:tutorial_firebase/utils/utils.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("post");
  TextEditingController searchPostController = TextEditingController();
  TextEditingController updatePostController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.onValue.listen(
        (event) {}); // Data would be ready initially, but also worked for me
    // Keep in mind that, "FirebaseAnimatedContainer" is a widget & "StreamBuilder" is a pure stream.
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
            listOfItems(),
          ],
        )

        // Real Time Database through "StreamBuilder"
        // body: fetchDataByStream(),
        );
  }

  AppBar homeAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text("Home"),
      centerTitle: true,
      backgroundColor: Colors.pink,
      actions: [logOutButton(context)],
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
        builder: (context) => const AddToPostScreen(),
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

  // StreamBuilder<DatabaseEvent> fetchDataByStream() {
  //   return StreamBuilder(
  //       stream: ref.onValue,
  //       builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
  //         return (!snapshot.hasData)
  //             ? showCircleLoading()
  //             : ListView.builder(
  //                 itemCount: snapshot.data!.snapshot.children.length,
  //                 itemBuilder: (context, index) {
  //                   Map<dynamic, dynamic> map = snapshot.data!.snapshot.value
  //                       as dynamic; // Storing snapshot data's into map,
  //                   List<dynamic> list = map.values
  //                       .toList(); // then storing these map values in list
  //                   return Card(
  //                     elevation: 3,
  //                     child: ListTile(
  //                       title: Text(list[index]["desc"]),
  //                       subtitle: Text(
  //                           "${list[index]["Morshed"]} ${list[index]["id"]}"),
  //                     ),
  //                   );
  //                 });
  //       });
  // }

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
              await ref.child(id).remove();
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

  updatePost({required String id}) {
    ref.child(id).update({"desc": updatePostController.text}).then((value) {
      Utils.toastMessage("Post updated successfully ✓");
    }).onError((error, stackTrace) {
      Utils.toastMessage(error.toString());
    });
  }
}
