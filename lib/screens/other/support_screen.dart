import 'package:flutter/material.dart';

import '../../app_colors.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myColorTittle,
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'គាំទ្រការអភិវឌ្ឍន៍',
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
                height: MediaQuery.of(context).size.width - 100,
                width: MediaQuery.of(context).size.width - 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20.0),
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
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 50, right: 50),
              child: const Text(
                "បងប្អូនអាចចូលរួមវិភាគទានដើម្បីគាំទ្រការអភិវឌ្ឍន៍ កម្មវិធីចំណាយ តាមរយៈគណនី ABA ខាងលើ។\nសូមអរគុណសម្រាប់ការគាំទ្រ និង វិភាគទាន!",
                style: TextStyle(
                    letterSpacing: 0,
                    wordSpacing: 0,
                    fontFamily: 'Hanuman',
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
