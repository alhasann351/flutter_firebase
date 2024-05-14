import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/ui/firestore/firestore_screen.dart';
import 'package:flutter_firebase/ui/forgot_password.dart';
import 'package:flutter_firebase/ui/post/post_screen.dart';
import 'package:flutter_firebase/ui/uploaded_image.dart';
import 'package:flutter_firebase/ui/widgets/round_button.dart';
import 'package:flutter_firebase/utils/utils.dart';

import 'login_phone_number.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;

  final _auth = FirebaseAuth.instance;

  void login(){
    setState(() {
      loading = true;
    });

    _auth.signInWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString(),).then((value){
      Utils().showToast('Login success');
      Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadedImage()));

      setState(() {
        loading = false;
      });

    }).onError((error, stackTrace){
      Utils().showToast(error.toString());

      setState(() {
        loading = false;
      });

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (pop) async {
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: const Text(
            'Login Screen',
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
                      controller: emailController,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.email_outlined),
                        labelText: 'Email',
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
                          return 'Enter email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.password_outlined),
                        labelText: 'Password',
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
                          return 'Enter password';
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
                  title: 'Login',
                  loading: loading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
                  }),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword()));
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?", style: TextStyle(
                    fontSize: 15,
                  ),),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                      },
                      child: const Text(
                        'Signup',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login with phone number?", style: TextStyle(
                    fontSize: 15,
                  ),),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPhoneNumber()));
                      },
                      child: const Text(
                        'Click here',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
