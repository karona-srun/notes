import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';
import 'sign_in_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    print('isEmailVerified $isEmailVerified');

    if (isEmailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email Successfully Verified")));
      timer?.cancel();
      Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const SignInScreen()),
          (route) => false);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myColorTittle,
        centerTitle: true,
        title: Text('lbVerify'.tr(),textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Hanuman',
              fontWeight: FontWeight.normal,
              fontSize: 20,
              color: AppColors.myColorBlack),),
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: AppColors.myColorBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 45),
            Center(
              child: Text(
                'lbCheckEmail'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Hanuman"),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Center(
                child: Text(
                  '${'lbCheck1Email'.tr()} \n${FirebaseAuth.instance.currentUser?.email}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Hanuman"),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.0),
              child: Center(
                child: Text(
                  'lbCheck2Email'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Hanuman")
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
                margin: const EdgeInsets.symmetric( vertical: 20, horizontal: 30),
                height: 45.0,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.white,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: const BorderSide(
                          color: Colors.white), // Set border color here
                    ),
                  ),
                  onPressed: () async {
                    try {
                    FirebaseAuth.instance.currentUser?.sendEmailVerification();
                  } catch (e) {
                    debugPrint('$e');
                  }
                  },
                  icon: Image.asset(
                    "assets/images/icon/resend.png",
                    width: 30,
                    height: 30,
                  ),
                  label: Text(
                    'btnResend'.tr(),
                    style: TextStyle(
                        color: Colors.amber[6000],
                        fontSize: 17,
                        fontFamily: "Hanuman"),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
