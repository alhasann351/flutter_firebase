import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/auth/verify_code_screen.dart';
import 'package:flutter_firebase/utils/utils.dart';

import '../widgets/round_button.dart';

class LoginPhoneNumber extends StatefulWidget {
  const LoginPhoneNumber({super.key});

  @override
  State<LoginPhoneNumber> createState() => _LoginPhoneNumberState();
}

class _LoginPhoneNumberState extends State<LoginPhoneNumber> {
  final phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneNumberController.dispose();
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
          'Login With Phone Number',
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
                    keyboardType: TextInputType.number,
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.phone_outlined),
                      labelText: 'Phone number',
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
                        return 'Enter phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            RoundButton(
                title: 'Login',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    _auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text,
                      verificationCompleted: (_){
                        setState(() {
                          loading = false;
                        });
                      },
                      verificationFailed: (e){
                        Utils().showToast(e.toString());
                        setState(() {
                          loading = false;
                        });
                      },
                      codeSent: (String verificationId, int? token){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCodeScreen(verificationId: verificationId,)));
                        setState(() {
                          loading = false;
                        });
                        },
                      codeAutoRetrievalTimeout: (e){
                        Utils().showToast(e.toString());
                        setState(() {
                          loading = false;
                        });
                      },
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
