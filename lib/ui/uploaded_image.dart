import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/widgets/round_button.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/utils.dart';
import 'auth/login_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadedImage extends StatefulWidget {
  const UploadedImage({super.key});

  @override
  State<UploadedImage> createState() => _UploadedImageState();
}

class _UploadedImageState extends State<UploadedImage> {
  bool loading = false;

  final _auth = FirebaseAuth.instance;

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  final databaseRef = FirebaseDatabase.instance.ref('Posts');

  File? _image;
  final picker = ImagePicker();

  Future getGalleryImage() async{
    final pickedImage = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    
    setState(() {
      if(pickedImage != null){
        _image = File(pickedImage.path);
      }else{
        Utils().showToast('No image picked');
      }
    });
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
          'Upload Image Screen',
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: (){
                  getGalleryImage();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    )
                  ),
                  child: _image != null ? Image.file(_image!.absolute) : const Center(child: Icon(Icons.image_outlined)),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            RoundButton(title: 'Upload', loading: loading, onTap: () {

              setState(() {
                loading = true;
              });

              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/photos/${DateTime.now().millisecondsSinceEpoch}');
              firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

              Future.value(uploadTask).then((value) async{
                var newUrl = await ref.getDownloadURL();

                databaseRef.child('id').set({
                  'id' : '123456',
                  'title' : newUrl.toString(),
                }).then((value){
                  setState(() {
                    loading = false;
                  });
                  Utils().showToast('Upload success');

                }).onError((error, stackTrace){
                  setState(() {
                    loading = false;
                  });
                  Utils().showToast(error.toString());
                });
              }).onError((error, stackTrace){
                Utils().showToast(error.toString());
                setState(() {
                  loading = false;
                });
              });
            },),
          ],
        ),
      ),
    );
  }
}
