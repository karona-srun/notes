import 'package:flutter/material.dart';
import '../../app_colors.dart';
import 'settings/feedback_screen.dart';
import 'settings/policy_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          'ការកំណត់',
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Container(
                height: 70 * 3,
                margin: const EdgeInsets.all(0),
                child: ListView(
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
                        title: const Text("ផ្តល់មតិយោបល់"),
                        leading: Image.asset("assets/images/icon/feedback.png",
                            height: 28, width: 28),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const FeedbackScreen()));
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
                        title: const Text("ចែករំលែកកម្មវិធី"),
                        leading: Image.asset("assets/images/icon/share.png",
                            height: 28, width: 28),
                        onTap: () {},
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
                        title: const Text("គោលការណ៍ឯកជនភាព"),
                        leading: Image.asset("assets/images/icon/policy.png",
                            height: 28, width: 28),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PolicyScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
