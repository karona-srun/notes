import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/app_colors.dart';

class UpdateTransctionScreen extends StatefulWidget {
  const UpdateTransctionScreen({super.key});

  @override
  State<UpdateTransctionScreen> createState() => _UpdateTransctionScreenState();
}

class _UpdateTransctionScreenState extends State<UpdateTransctionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:AppColors.myColorBackground,
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: hexToColor('#f2f2ff'),//bottom bar icons
    ),
      ),
      backgroundColor: AppColors.myColorBackground,
    );
  }
}