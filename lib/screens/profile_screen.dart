import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/screens/other/language_screen.dart';

import 'chart_screen.dart';
import 'other/about_us_screen.dart';
import 'other/setting_screen.dart';
import 'other/support_screen.dart';
import 'other/wallet_screen.dart';
import 'start_up_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String _displayName = "UserName";
  String _email = "example@moneytracker.com";
  late String _photoURL = "";

  Future<void> _handleSignOut() async {
    try {
      await googleSignIn.signOut();
      await _auth.signOut();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _displayName = FirebaseAuth.instance.currentUser!.displayName.toString();
      _email = FirebaseAuth.instance.currentUser!.email.toString();
      _photoURL = FirebaseAuth.instance.currentUser!.photoURL.toString();
    });
    print(FirebaseAuth.instance.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.orange,
            padding: const EdgeInsets.only(top: 35, bottom: 20),
            margin: const EdgeInsets.only(top: 0),
            child: Center(
              child: Text(
                "lbTitleAccount".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Hanuman',
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: const BorderRadius.only(
                bottomLeft:
                    Radius.circular(13.0), // Set bottom left corner radius
                bottomRight:
                    Radius.circular(13.0), // Set bottom right corner radius
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Shadow color
                  spreadRadius: 0, // Spread radius
                  blurRadius: 10, // Blur radius
                  offset: const Offset(0, 10), // Changes position of shadow
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            child: Card(
              elevation: 0,
              color: Colors.orange,
              surfaceTintColor: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0, left: 20, right: 10, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.white),
                            ),
                          ),
                          child: Text(
                            _displayName,
                            style: const TextStyle(
                                fontFamily: 'Hanuman',
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          _email,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'Hanuman',
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  _photoURL.isNotEmpty ? Container(
                      alignment: Alignment.centerRight,
                      margin:
                          const EdgeInsets.only(top: 0, bottom: 15, right: 20),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image:  NetworkImage(_photoURL),
                            fit: BoxFit.cover),
                      ),
                      child: null): Container(
                      alignment: Alignment.centerRight,
                      margin:
                          const EdgeInsets.only(top: 0, bottom: 15, right: 20),
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/icon/user.png'),
                            fit: BoxFit.cover),
                      ),
                      child: null),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, right: 25, top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 50, // Specify your desired height here
                  child: ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      surfaceTintColor: Colors.orange[100],
                      splashFactory: NoSplash.splashFactory,
                      elevation: 3,
                      alignment: Alignment.centerLeft,
                      textStyle: const TextStyle(color: Colors.blue),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () => {
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => const ChartScreen(),
                        ),
                      )
                    },
                    icon: Image.asset(
                      "assets/images/icon/icons8-chart-100.png",
                      width: 24,
                    ),
                    label: Text(
                      'menuGraph'.tr(),
                      style: TextStyle(
                        fontFamily: 'Hanuman',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Card(
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              color: Colors.grey[100],
              borderOnForeground: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  // ElevatedButton.icon(
                  //   icon: Image.asset("assets/images/icon/wallet.png",
                  //       height: 28, width: 28),
                  //   onPressed: () {
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => const WalletScreen()));
                  //   },
                  //   label: Text(
                  //     "menuMyWallet".tr(),
                  //     style: TextStyle(
                  //         fontFamily: 'Hanuman',
                  //         fontSize: 15,
                  //         color: Colors.black),
                  //   ),
                  //   style: ElevatedButton.styleFrom(
                  //     fixedSize: const Size(0, 50),
                  //     surfaceTintColor: Colors.transparent,
                  //     shadowColor: Colors.transparent,
                  //     backgroundColor: Colors.grey[100],
                  //     alignment: Alignment.centerLeft,
                  //     foregroundColor: Colors.grey[100],
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(5.0),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   margin: const EdgeInsets.symmetric(horizontal: 20),
                  //   width: sizeWidth, // Thickness
                  //   height: 0.7,
                  //   color: Colors.grey[400],
                  // ),
                  ElevatedButton.icon(
                    icon: Image.asset("assets/images/icon/language.png",
                        height: 28, width: 28),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LanguageScreen()));
                    },
                    label: Text(
                      "menuLanguage".tr(),
                      style: TextStyle(
                          fontFamily: 'Hanuman',
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(0, 50),
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.grey[100],
                      alignment: Alignment.centerLeft,
                      foregroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: sizeWidth, // Thickness
                    height: 0.7,
                    color: Colors.grey[400],
                  ),
                  ElevatedButton.icon(
                    icon: Image.asset("assets/images/icon/settings.png",
                        height: 24, width: 24),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SettingScreen()));
                    },
                    label: Text(
                      "menuSetting".tr(),
                      style: TextStyle(
                          fontFamily: 'Hanuman',
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(0, 50),
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.grey[100],
                      alignment: Alignment.centerLeft,
                      foregroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: sizeWidth, // Thickness
                    height: 0.7,
                    color: Colors.grey[400],
                  ),
                  ElevatedButton.icon(
                    icon: Image.asset("assets/images/icon/support.png",
                        height: 24, width: 24),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SupportScreen()));
                    },
                    label: Text(
                      "menuSupport".tr(),
                      style: TextStyle(
                          fontFamily: 'Hanuman',
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(0, 50),
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.grey[100],
                      alignment: Alignment.centerLeft,
                      foregroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: sizeWidth, // Thickness
                    height: 0.7,
                    color: Colors.grey[400],
                  ),
                  ElevatedButton.icon(
                    icon: Image.asset("assets/images/icon/about.png",
                        height: 24, width: 24),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AboutUsScreen()));
                    },
                    label: Text(
                      "menuAboutUs".tr(),
                      style: TextStyle(
                          fontFamily: 'Hanuman',
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(0, 50),
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.grey[100],
                      alignment: Alignment.centerLeft,
                      foregroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: sizeWidth, // Thickness
                    height: 0.7,
                    color: Colors.grey[400],
                  ),
                  ElevatedButton.icon(
                    icon: Image.asset("assets/images/icon/logout.png",
                        height: 24, width: 24),
                    onPressed: () {
                      _handleSignOut();
                      Navigator.pushAndRemoveUntil<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                const StartUpScreen(),
                          ),
                          (route) => false);
                    },
                    label: Text(
                      "menuSignOut".tr(),
                      style: TextStyle(
                          fontFamily: 'Hanuman',
                          fontSize: 15,
                          color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(0, 50),
                      surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.grey[100],
                      alignment: Alignment.centerLeft,
                      foregroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
