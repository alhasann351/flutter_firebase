import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/utils.dart';

import '../widgets/round_button.dart';

class AddFireStoreData extends StatefulWidget {
  const AddFireStoreData({super.key});

  @override
  State<AddFireStoreData> createState() => _AddFireStoreDataState();
}

class _AddFireStoreDataState extends State<AddFireStoreData> {

  bool loading = false;

  final fireStore = FirebaseFirestore.instance.collection('users');

  final _formKey = GlobalKey<FormState>();

  final dataController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dataController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          'Add Data Screen',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 4,
                    controller: dataController,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.post_add),
                      labelText: 'Add data',
                      labelStyle: const TextStyle(
                        fontSize: 18,
                      ),
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Write some text in input field';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });

                    String id = DateTime.now().millisecondsSinceEpoch.toString();

                    fireStore.doc(id).set({
                      'id' : id,
                      'title' : dataController.text.toString(),
                    }).then((value){
                      setState(() {
                        loading = false;
                      });
                      Utils().showToast('Data added success');

                    }).onError((error, stackTrace){
                      Utils().showToast(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
