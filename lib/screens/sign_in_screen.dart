import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';
import 'main_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    // Authentication failed
    return false;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(242, 242, 255, 1.000),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color.fromRGBO(242, 242, 255, 1.000),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    child: Image.asset(
                      "assets/images/sign_in.png",
                      width: 250,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 10),
                    width: MediaQuery.of(context).size.width - 50,
                    child: Text(
                      "ចាប់ផ្តើមកត់ត្រាជាមួយគ្នា...",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          letterSpacing: 0,
                          wordSpacing: 0.0,
                          fontFamily: "Hanuman",
                          color: Colors.amber[600],
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0.0, bottom: 20),
                    width: MediaQuery.of(context).size.width - 50,
                    child: const Text(
                      "បញ្ចូលអ៊ីមែល និងពាក្យសម្ងាត់របស់អ្នកដើម្បីចូលប្រើប្រាស់",
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
                    margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    alignment: AlignmentDirectional.topStart,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'មិនមានគណនីមែនទេ? ',
                            style: const TextStyle(
                                fontFamily: 'Hanuman',
                                fontSize: 16,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'បង្កើត​គណនី​ថ្មី!',
                                  style: const TextStyle(
                                      fontFamily: 'Hanuman',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push<dynamic>(
                                          context,
                                          MaterialPageRoute<dynamic>(
                                            builder: (BuildContext context) =>
                                                const SignUpScreen(),
                                          ),
                                        )),
                            ],
                          ),
                        ),
                      ],
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
                        bool isLogdgedIn = await signInWithEmail(
                            emailController.text, passwordController.text);
                        print('isLogdgedIn $isLogdgedIn');
                        if (isLogdgedIn) {
                          Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      const MainScreen()),
                              (route) => false);
                        }
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
                ]),
          ),
        ),
      ),
    );
  }
}
