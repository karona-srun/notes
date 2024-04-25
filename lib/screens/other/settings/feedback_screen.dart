import 'package:flutter/material.dart';

import '../../../app_colors.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myColorTittle,
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'ផ្តល់មតិយោបល់',
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
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "សរសេរមតិយោបល់របស់អ្នក ឬ ស្នើសុំលក្ខណៈបន្ថែម\nក្នុងកម្មវិធី",
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      letterSpacing: 0, wordSpacing: -0, fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  height: 90.0,
                  width: double.infinity,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    autofocus: true,
                    decoration: const InputDecoration(
                        hintText: "សរសេរមតិយោបល់",
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey))),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {},
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 50),
                  height: 50.0,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: Colors.orange), // Set border color here
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'ផ្ញើ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
