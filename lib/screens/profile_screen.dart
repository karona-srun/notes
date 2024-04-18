import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myColorTittle,
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'ផ្សេងទៀត',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Hanuman',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.myColorBlack),
        ),
      ),
      backgroundColor: AppColors.myColorBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(0),
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 5,
                    shadowColor: const Color.fromARGB(255, 245, 245, 245),
                    surfaceTintColor: Colors.white,
                    color: Colors.orange,
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.all(0),
                      transformAlignment: Alignment.centerRight,
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 20, right: 10),
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
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                alignment: Alignment.centerRight,
                                margin: const EdgeInsets.only(
                                    top: 1, bottom: 10, right: 20),
                                height: 60,
                                width: 60,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/icon/user.png'),
                                      fit: BoxFit.cover),
                                ),
                                child: null),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 70 * 6,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Container(
                        height: 60,
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 233, 233, 233))),
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
                        height: 60,
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(255, 233, 233, 233))),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          title: const Text("ការកំណត់"),
                          leading: Image.asset(
                              "assets/images/icon/settings.png",
                              height: 28,
                              width: 28),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SettingScreen()));
                          },
                        ),
                      ),
                      Container(
                        height: 60,
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
                        height: 60,
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
                        height: 60,
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
              ]),
        ),
      ),
    );
  }
}
