import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

class ToDoPage extends StatefulWidget {
  // const ToDoPage(User user, {Key? key}) : super(key: key);
  const ToDoPage(this.user, {super.key});

  final User user;
  @override
  // ignore: library_private_types_in_public_api
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final CollectionReference _todos =
      FirebaseFirestore.instance.collection('todo');

  /*
  * 【メソッド】アップサート
  * documentSnapshot（firebaseのデータ）がある場合、更新。ない場合は削除
  * */
  Future<void> _addOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String mode = 'addition';
    if (documentSnapshot != null) {
      mode = 'update';
      _todoController.text = documentSnapshot['todo'];
      _contentController.text = documentSnapshot['content'].toString();
    }
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _todoController,
                  decoration: const InputDecoration(labelText: 'ToDo'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    final String todo = _todoController.text;
                    final String content = _contentController.text;
                    if (mode == 'addition') {
                      _todos.add({
                        "user_id": widget.user.uid,
                        "todo": todo,
                        "content": content
                      });
                      // Show the snack bar for the add
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Added $todo!',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white),
                          )));
                    }
                    // Editing process
                    if (mode == 'update') {
                      // Update the product
                      _todos.doc(documentSnapshot!.id).update({
                        "user_id": widget.user.uid,
                        "todo": todo,
                        "content": content
                      });
                      // Show the snack bar for the edit
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Updated Content!',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white,
                                backgroundColor: Colors.yellowAccent),
                          )));
                    }
                    // Clear the text fields
                    _todoController.text = '';
                    _contentController.text = '';

                    // Hide the bottom sheet
                    Navigator.of(context).pop();
                  },
                  child: Text(mode == 'addition' ? 'Add' : 'Update'),
                )
              ],
            ),
          );
        });
  }

  /*
  * 【メソッド】削除機能
  * */
  Future<void> _deleteProduct(String productId) async {
    _todos.doc(productId).delete();

    // Show the snack bar for the exclusion
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Deleted Content!',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
        )));
  }

  /*
  * 画面表示用ヴィジェット
  * */
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fire Project_${widget.user.email}'),
          backgroundColor: Colors.red,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                // ログイン画面に遷移
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return const AuthAppPage();
                }));
              },
            ),
          ],
        ),
        // StreamBuilder to pass Firestorm values to ListView.builder
        body: StreamBuilder(
          stream: _todos.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              // Display FireStore values in list format
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  // View documents in the card widget
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['todo']), // ToDo
                      subtitle: Text(
                          documentSnapshot['content'].toString()), // Content

                      trailing: SizedBox(
                        width: 100,
                        child: documentSnapshot['user_id'] == widget.user.uid
                            ? Row(children: [
                                // Edit Button
                                IconButton(
                                    color: Colors.red,
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _addOrUpdate(documentSnapshot)),
                                // Delete Button
                                IconButton(
                                    color: Colors.red,
                                    icon: const Icon(Icons.delete),
                                    onPressed: () =>
                                        _deleteProduct(documentSnapshot.id)),
                              ])
                            : null,
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        // Add Button
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () => _addOrUpdate(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
