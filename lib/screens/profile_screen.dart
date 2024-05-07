import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../app_colors.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
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
            child: const Center(
              child: Text(
                "ផ្សេងទៀត",
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
              borderRadius: BorderRadius.only(
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
            offset: Offset(0, 10), // Changes position of shadow
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
                        top: 0, left: 20, right: 10, bottom: 30),
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
                          child: const Text(
                            'គណនី',
                            style: TextStyle(
                                fontFamily: 'Hanuman',
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const Text(
                          "karonasrun.ks@gmail.com",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'Hanuman',
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerRight,
                      margin:
                          const EdgeInsets.only(top: 0, bottom: 40, right: 20),
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
            height: 50 * 7,
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: ListView(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 233, 233, 233),
                      ),
                    ),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    title: const Text("កាបូបរបស់ខ្ញុំ"),
                    leading: Image.asset("assets/images/icon/wallet.png",
                        height: 28, width: 28),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const WalletScreen()));
                    },
                  ),
                ),
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 233, 233, 233))),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    title: const Text("ការកំណត់"),
                    leading: Image.asset("assets/images/icon/settings.png",
                        height: 28, width: 28),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SettingScreen()));
                    },
                  ),
                ),
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 233, 233, 233))),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    title: const Text("គាំទ្រការអភិវឌ្ឍន៍"),
                    leading: Image.asset("assets/images/icon/support.png",
                        height: 28, width: 28),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SupportScreen()));
                    },
                  ),
                ),
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 233, 233, 233))),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    title: const Text("អំពីយើងខ្ញុំ"),
                    leading: Image.asset("assets/images/icon/about.png",
                        height: 28, width: 28),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AboutUsScreen()));
                    },
                  ),
                ),
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 233, 233, 233))),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    title: const Text("ចាកចេញ"),
                    leading: Image.asset("assets/images/icon/logout.png",
                        height: 28, width: 28),
                    onTap: () {
                      _handleSignOut();
                      Navigator.pushAndRemoveUntil<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                const StartUpScreen(),
                          ),
                          (route) => false);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
