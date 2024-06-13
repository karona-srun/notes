import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/screens/main_screen.dart';
import '../../app_colors.dart';
import '../../utils/shared_pref.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int? _selectedValue;
  late Locale locale;
  late Future<String?> deviceLanguage;

  @override
  void initState() {
    super.initState();
    deviceLanguage = SharedPref.getLang();
    deviceLanguage.then((value) => {
      setState(() {
        if(value == 'en'){
          _selectedValue = 1;
        } else {
          _selectedValue = 0;
        }
      })
    });
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
          'lbTitleLangauge'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Hanuman',
              fontWeight: FontWeight.normal,
              fontSize: 20,
              color: AppColors.myColorBlack),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: AppColors.myColorBackground,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        scrollDirection: Axis.vertical,
        child: Column(children: [
          Container(
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'lbTitleIntroLangauge'.tr(),
              style: const TextStyle(
                  fontFamily: 'Hanuman',
                  letterSpacing: 0,
                  wordSpacing: 0,
                  fontWeight: FontWeight.normal,
                  fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Your onPressed code here!
                    print('Button Pressed');
                    setState(() {
                      _selectedValue = 0;
                      locale = const Locale('km', 'KH');
                      SharedPref.addLang('km');
                      context.setLocale(locale);
                      context.savedLocale;
                    });
                    // context.locale = const Locale("km", "KH");
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Colors.orange,
                    elevation: 2,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // Adjust the radius as needed
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<int>(
                        value: 0,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value;
                            locale = const Locale('km', 'KH');
                            SharedPref.addLang('km');
                            context.setLocale(locale);
                            context.savedLocale;
                          });
                        },
                      ),
                      Image.asset(
                        'assets/images/icon/kh_flag.png',
                        height: 32,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'btnKhmer'.tr(),
                        style: const TextStyle(
                            fontFamily: 'Hanuman',
                            letterSpacing: 0,
                            wordSpacing: 0,
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Your onPressed code here!
                    print('Button Pressed');
                    setState(() {
                      _selectedValue = 1;
                      locale = const Locale('en', 'US');
                      SharedPref.addLang('en');
                      context.setLocale(locale);
                      context.savedLocale;
                    });
                    // context.locale = const Locale("en", "US");
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Colors.orange,
                    elevation: 2,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // Adjust the radius as needed
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<int>(
                        value: 1,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value;
                            locale = const Locale('en', 'US');
                            SharedPref.addLang('en');
                            context.setLocale(locale);
                            context.savedLocale;
                          });
                        },
                      ),
                      Image.asset(
                        'assets/images/icon/us_flag.png',
                        height: 32,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'btnEnglish'.tr(),
                        style: const TextStyle(
                            fontFamily: 'Hanuman',
                            letterSpacing: 0,
                            wordSpacing: 0,
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(5), // Set the border radius here
        ),
        margin: EdgeInsets.symmetric( horizontal: 20, vertical: 20 ),
        child: TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      const MainScreen(index: 2)),
                              (route) => false);
          },
          child: Text('btnConfirm'.tr(),style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: "Hanuman"),)
        ),
      ),
    );
  }
}
