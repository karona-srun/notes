import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_colors.dart';
import '../utils/shared_pref.dart';
import 'main_screen.dart';
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
              builder: (BuildContext context) => const MainScreen(index: 0),
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
        backgroundColor: hexToColor('#fefcfe'),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.black.withOpacity(0), //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons
      systemNavigationBarColor: hexToColor('#fefcfe'), //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    ),
      ),
      backgroundColor: hexToColor('#fefcfe'),
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
                  child: Image.asset("assets/images/icon/ana.gif")),
              Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 10),
                width: MediaQuery.of(context).size.width - 50,
                child: Text(
                  "lbIntro",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      letterSpacing: 0,
                      wordSpacing: 0.0,
                      color: Colors.amber[600],
                      fontSize: 24,
                      fontFamily: 'Hanuman',
                      fontWeight: FontWeight.normal),
                ).tr(),
              ),
              Container(
                margin: const EdgeInsets.only(top: 0.0, bottom: 20),
                width: MediaQuery.of(context).size.width - 50,
                height: 45,
                child: const Text(
                  "lbIntro1",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      letterSpacing: 0,
                      wordSpacing: 0.0,
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Hanuman',
                      fontWeight: FontWeight.normal),
                ).tr(),
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
                  label: Text(
                    'btnSignWithEmail'.tr(),
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
                  label: Text(
                    'btnSignWithGoogle'.tr(),
                    style: const TextStyle(
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
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('lbSelectLangauge',style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: "Hanuman"),).tr(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10), // Set the border radius here
                      ),
                      child:Row(
                        children: [
                          TextButton(onPressed: (){
                            context.locale = const Locale("km", "KH"); 
                            SharedPref.addLang('km');
                          }, child: Image.asset('assets/images/icon/kh_flag.png')),
                          const Text("|"),
                          TextButton(onPressed: (){
                              context.locale = const Locale("en", "US"); 
                              SharedPref.addLang('en');
                           }, child: Image.asset('assets/images/icon/us_flag.png'))
                        ],
                      )
                    )
                  ],
                )
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
