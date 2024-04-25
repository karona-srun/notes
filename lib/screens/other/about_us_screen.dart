import 'package:flutter/material.dart';

import '../../app_colors.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myColorTittle,
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'អំពីយើងខ្ញុំ',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Hanuman',
              fontWeight: FontWeight.normal,
              fontSize: 20,
              color: AppColors.myColorBlack),
        ),
      ),
      backgroundColor: AppColors.myColorBackground,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.all(25),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(0.0),
                ),
                clipBehavior: Clip.hardEdge,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/qr_code.png",
                  width: MediaQuery.of(context).size.width - 120,
                  height: MediaQuery.of(context).size.width - 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 50, right: 50),
              child: const Text(
                "កត់ត្រាចំណាយ",
                style: TextStyle(
                    letterSpacing: 0,
                    wordSpacing: 0,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 50, right: 50, top: 5),
              child: const Text(
                "កម្មវិធី កំណែៈ V 0.0.10",
                style: TextStyle(
                    letterSpacing: 0,
                    wordSpacing: 0,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
