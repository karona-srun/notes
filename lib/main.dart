import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app_colors.dart';
import 'firebase_options.dart';
import 'screens/main_screen.dart';
import 'screens/start_up_screen.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.black.withOpacity(0), //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons
      systemNavigationBarColor: Colors.white, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  MobileAds.instance.initialize()
    .then((initializationStatus) {
      initializationStatus.adapterStatuses.forEach((key, value) {
        print('Adapter status for $key: ${value.description}');
      });
  });
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting('en', null).then((_) => runApp(const MyWidget()));
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  
  bool isLoggedIn = false;

  @override
  void initState(){
    super.initState();
    setState(() {
      isLoggedIn = checkAuth();
    });
  }

  bool checkAuth() {
    if (FirebaseAuth.instance.currentUser != null) {
      if (kDebugMode) {
        print(FirebaseAuth.instance.currentUser);
      }
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'កត់ត្រា',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Colors.black,
        colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.black),
        highlightColor: AppColors.myColorBackground,
        focusColor: AppColors.myColorBackground,
        splashColor: AppColors.myColorBackground,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLoggedIn ? const MainScreen() : const StartUpScreen(),
    );
  }
}
