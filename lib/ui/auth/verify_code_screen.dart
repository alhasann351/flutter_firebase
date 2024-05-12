import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/post/post_screen.dart';
import 'package:flutter_firebase/utils/utils.dart';

import '../widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;

  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final otpCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    otpCodeController.dispose();
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
          'Verify Code Screen',
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
                    controller: otpCodeController,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.sms_outlined),
                      labelText: '6 digit code',
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
                        return 'Enter 6 digit code';
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
                title: 'Verify',
                loading: loading,
                onTap: () async{
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });

                    final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: otpCodeController.text.toString(),
                    );

                    try{
                      await _auth.signInWithCredential(credential);
                      
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PostScreen()));

                      setState(() {
                        loading = false;
                      });

                    }catch(e){
                      setState(() {
                        loading = false;
                      });

                      Utils().showToast(e.toString());
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }
}
