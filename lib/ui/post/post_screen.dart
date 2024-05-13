import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/auth/login_screen.dart';
import 'package:flutter_firebase/ui/post/add_post.dart';
import 'package:flutter_firebase/utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final searchController = TextEditingController();
  final editController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _databaseRef = FirebaseDatabase.instance.ref('Posts');

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut().then((value) {
                Utils().showToast('Logout success');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().showToast(error.toString());
              });
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          'Post Screen',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Expanded(
              child: StreamBuilder(
                stream: _databaseRef.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.blue,
                    ));
                  } else {
                    Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                    List<dynamic> list = [];
                    list.clear();
                    list = map.values.toList();

                    return ListView.builder(
                      itemCount: snapshot.data!.snapshot.children.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(list[index]['title']),
                        );
                      },
                    );
                  }
                },
              ),
            ),*/
            TextFormField(
              controller: searchController,
              onChanged: (String value) {
                setState(() {});
              },
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.search_outlined),
                hintText: 'Search',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: const Center(
                    child: CircularProgressIndicator(
                  color: Colors.blue,
                )),
                query: _databaseRef,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();

                  if (searchController.text.isEmpty) {
                    return ListTile(
                      title: Text(
                        snapshot.child('title').value.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.child('id').value.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert_outlined, color: Colors.black,),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              onTap: (){
                                Navigator.pop(context);
                                showMyDialog();
                              },
                              leading: const Icon(Icons.edit),
                              title: const Text('Edit'),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 2,
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase())) {
                    return ListTile(
                      title: Text(
                        snapshot.child('title').value.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.child('id').value.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPost()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> showMyDialog(String title) async{
    editController.text = title;

    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Update'),
        content: Container(child: TextFormField(
          controller: editController,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.update),
            hintText: 'Enter update text',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 2,
              ),
            ),
          ),
        ),),
        actions: [
          TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Update')),
          TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Cancel')),
        ],
      );
    });
  }
}
