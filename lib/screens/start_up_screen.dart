import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_colors.dart';
import 'sign_in_screen.dart';

class StartUpScreen extends StatefulWidget {
  const StartUpScreen({super.key});

  @override
  State<StartUpScreen> createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen> {
  ValueNotifier userCredential = ValueNotifier('');
  bool visible = false;
  bool isSignedIn = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  late final SharedPreferences _prefs;
  String displayName = '';
  String email = '';
  String lastSignInTime = '';
  String photoURL = '';

  _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  _saveData(String name, String email, String time, String url) async {
    setState(() {
      displayName = name;
      email = email;
      lastSignInTime = time;
      photoURL = url;
    });
    await _prefs.setString('displayName', displayName);
    await _prefs.setString('email', email);
    await _prefs.setString('lastSignInTime', lastSignInTime);
    await _prefs.setString('photoURL', photoURL);
  }

  Future<User?> signInwithGoogle() async {
    try {
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        _saveData(user!.displayName.toString(), user.email.toString(), '',
            user.photoURL.toString());
        if (kDebugMode) {
          print('SignIn is success: $user');
        }

        setState(() {
          visible = false;
          isSignedIn = true;
        });
        Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const MainScreen(),
            ),
            (route) => false);
        return user;
      }
    } catch (error) {
      setState(() {
        visible = false;
        isSignedIn = false;
      });
      if (kDebugMode) {
        print('Error $error');
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      if (kDebugMode) {
        print(FirebaseAuth.instance.currentUser);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myColorTittle,
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: AppColors.myColorBackground,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          margin: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.all(0.0),
                  width: MediaQuery.of(context).size.width - 100,
                  child: Image.asset("assets/images/concept_set_up.png")),
              Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 10),
                width: MediaQuery.of(context).size.width - 50,
                child: Text(
                  "Start tracking your money effectively",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      letterSpacing: 0,
                      wordSpacing: 0.0,
                      color: Colors.amber[600],
                      fontSize: 24,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 0.0, bottom: 20),
                width: MediaQuery.of(context).size.width - 50,
                child: const Text(
                  "Keep your data safe by storage it in the cloud.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      letterSpacing: 0,
                      wordSpacing: 0.0,
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: const BorderSide(
                          color: Colors.amber), // Set border color here
                    ),
                  ),
                  onPressed: () {
                    Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => const SignInScreen(),
                      ),
                    );
                    // QuickAlert.show(
                    //   context: context,
                    //   type: QuickAlertType.success,
                    //   text: 'Transaction Completed Successfully!',
                    //   autoCloseDuration: const Duration(seconds: 4),
                    //   showConfirmBtn: false,
                    // );
                  },
                  icon: Image.asset(
                    "assets/images/icon/email.png",
                    width: 30,
                    height: 30,
                  ),
                  label: const Text(
                    'បន្តជាមួយអ៊ីមែល',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: "Hanuman"),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: const BorderSide(
                          color: Colors.amber), // Set border color here
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      visible = true;
                    });
                    signInwithGoogle();
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => UserInfoScreen(
                    //       user: user,
                    //     ),
                    //   ),
                  },
                  icon: Image.asset(
                    "assets/images/icon/google.png",
                    width: 30,
                    height: 30,
                  ),
                  label: const Text(
                    'បន្តជាមួយ Google',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: "Hanuman"),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: visible,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 20,
                    margin: const EdgeInsets.only(),
                    child: LinearProgressIndicator(
                      minHeight: 2,
                      backgroundColor: Colors.amber[600],
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
