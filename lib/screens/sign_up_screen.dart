import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/screens/email_verification_screen.dart';

import '../app_colors.dart';
import 'main_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  Future<bool> createUserWithEmail(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User registered successfully: ${credential.user!.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          print('The password provided is too weak.');
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("The password provided is too weak.")));
          break;
        case 'email-already-in-use':
          print('The account already exists for that email.');
          ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("The account already exists for that email.")));
          break;
        default:
          print('Failed to create user: ${e.message}');
      }
    } catch (e) {
      // Handle other unexpected errors
      print('Failed to create user: $e');
    }
    // Authentication failed
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myColorTittle,
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: hexToColor('#ffffff'),//bottom bar icons
    ),
      ),
      backgroundColor: AppColors.myColorBackground,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        child: Container(
          margin: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(0.0),
                    alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.width - 100,
                    child: Image.asset("assets/images/sign_up.png"),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 10),
                    width: MediaQuery.of(context).size.width - 50,
                    child: Text(
                      "ចុះឈ្មោះប្រើប្រាស់",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          letterSpacing: 0,
                          wordSpacing: 0.0,
                          fontFamily: "Hanuman",
                          color: Colors.amber[600],
                          fontSize: 24,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0.0, bottom: 20),
                    width: MediaQuery.of(context).size.width - 50,
                    child: const Text(
                      "បញ្ចូលឈ្មោះ បញ្ចូលអ៊ីមែល និងពាក្យសម្ងាត់របស់អ្នកអោយបានត្រឹមត្រូវដើម្បីធ្វើការចុះឈ្មោះ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          letterSpacing: 0,
                          wordSpacing: 0.0,
                          color: Colors.black,
                          fontFamily: "Hanuman",
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: nameController,
                      cursorHeight: 25,
                      style: const TextStyle(
                          letterSpacing: 0,
                          decoration: TextDecoration.none,
                          decorationStyle: TextDecorationStyle.dotted,
                          decorationColor: Colors.white,
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal),
                      decoration: const InputDecoration(
                        hintText: "វាយបញ្ចូលឈ្មោះ",
                        hintStyle: TextStyle(
                            letterSpacing: 0,
                            fontSize: 18.0,
                            color: Colors.black),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        prefixIcon: Icon(
                          Icons.person_2_rounded,
                          color: Colors.grey,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: emailController,
                      cursorHeight: 25,
                      style: const TextStyle(
                          letterSpacing: 0,
                          decoration: TextDecoration.none,
                          decorationStyle: TextDecorationStyle.dotted,
                          decorationColor: Colors.white,
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal),
                      decoration: const InputDecoration(
                        hintText: "វាយបញ្ចូលអ៊ីម៉ែល",
                        hintStyle: TextStyle(
                            letterSpacing: 0,
                            fontSize: 18.0,
                            color: Colors.black),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        prefixIcon: Icon(
                          Icons.mail_sharp,
                          color: Colors.grey,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: passwordController,
                      cursorHeight: 25,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: const TextStyle(
                          letterSpacing: 0,
                          decoration: TextDecoration.none,
                          decorationStyle: TextDecorationStyle.dotted,
                          decorationColor: Colors.white,
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal),
                      decoration: const InputDecoration(
                        hintText: "វាយបញ្ចូលពាក្យសម្ងាត់",
                        hintStyle: TextStyle(
                            letterSpacing: 0,
                            fontSize: 18.0,
                            color: Colors.black),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.grey,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: passwordConfirmController,
                      cursorHeight: 25,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: const TextStyle(
                          letterSpacing: 0,
                          decoration: TextDecoration.none,
                          decorationStyle: TextDecorationStyle.dotted,
                          decorationColor: Colors.white,
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal),
                      decoration: const InputDecoration(
                        hintText: "វាយបញ្ចូលពាក្យសម្ងាត់ម្តងទៀត",
                        hintStyle: TextStyle(
                            letterSpacing: 0,
                            fontSize: 18.0,
                            color: Colors.black),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.grey,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                          side: const BorderSide(
                              color: Colors.amber), // Set border color here
                        ),
                      ),
                      onPressed: () async {
                        bool isCreated = await createUserWithEmail(emailController.text, passwordController.text);
                        if(isCreated){
                          Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const EmailVerificationScreen()));
                        }
                        // Navigator.pushAndRemoveUntil<dynamic>(
                        //     context,
                        //     MaterialPageRoute<dynamic>(
                        //         builder: (BuildContext context) =>
                        //             const MainScreen()),
                        //     (route) => false);
                      },
                      child: const Text(
                        'ចុះឈ្មោះ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Hanuman"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}