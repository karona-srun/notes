import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastNotification {
  dynamic showNotify(BuildContext context, String title, String msg) async {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      title: Text(title,
      style: const TextStyle(
        fontFamily: 'Hanuman',
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.white),
      ),
      description: RichText(text: TextSpan(text: msg,style: const TextStyle(
        fontFamily: 'Hanuman',
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.white),)),
      autoCloseDuration: const Duration(seconds: 7),
    );
  }

}