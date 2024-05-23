import 'package:flutter/material.dart';

import '../../../app_colors.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.myColorTittle,
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'ឯកជនភាព',
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
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "By installing Money Tracker or in other way use or accessing our services, you accept the terms and conditions of this Privacy Policy and the processing of your personal data. You may use Money Tracker in a way that doesn't require any of your information. In such case, no Personal Data is collected or processed.",
                overflow: TextOverflow.fade,
                style:
                    TextStyle(letterSpacing: 0, wordSpacing: -0, fontSize: 14.5),
              ),
              SizedBox(height: 10),
              ExpansionTile(
                title: Text(
                  "Personal data we collect",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                collapsedBackgroundColor: Color.fromARGB(255, 225, 225, 225),
                backgroundColor: Color.fromARGB(255, 225, 225, 225),
                collapsedShape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                children: <Widget>[
                  ListTile(
                      subtitle: Text(
                          "When using Money Tracker you might be prompted to input personal information such as: \n- Your Email address \n- First and last name Currency preference \n- Information about your personal finance (income and expenses) Input of personal data is optional but required for certain features of Money Tracker to work properly. By entering any personal data you agree that you provide it voluntarily. In an ongoing effort to improve our applications, additional personal data may be collected from you. In such case, we will notify you when the personal data collection takes place.")),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ExpansionTile(
                title: Text(
                  "Our use of your personal data",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                collapsedBackgroundColor: Color.fromARGB(255, 225, 225, 225),
                backgroundColor: Color.fromARGB(255, 225, 225, 225),
                collapsedShape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                children: <Widget>[
                  ListTile(
                    subtitle: Text(
                        "Primarily, we use your personal data to enable features in Money Tracker such as:\nData synchronisation between multiple devices. Backup of your data in case you need to install Money Tracker from scratch on a new device. Data synchronisation between members of a budget Contacting you back after sending us feedback or questions. We may use your personal data for the purposes of further develop Money Tracker and analyse usage of Money Tracker. Money Tracker will not share your personal data with third parties without your permission, except in the limited circumstances provided below. Personal data collected from you may be shared with our affiliates, agents and business partners. We may disclose your personal data in order to comply with a legal or regulatory obligation, if we reasonably believe that this is required by law, regulation or other legislation, or in order to protect and defend Money Tracker, our business partners or users' rights and interests. Money Tracker may use your aggregated data with third parties to perform analysis. Technical and Anonymous Data You hereby agree that Provider may collect and use technical data, including but not limited to information about your mobile device and system, Internet connection or your use of Money Tracker. The purpose of the collection of technical data is to ensure quality, increase your comfort and further analyse and develop Money Tracker and related services. You also agree that Provider may anonymise your personal data, where possible, and use the anonymous data at its sole discretion for any purpose, particularly for creating anonymous analyses and statistics. You acknowledge that the anonymous data may be disclosed or sold to third parties, including outside the territory of the European Union."),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ExpansionTile(
                title: Text(
                  "Your rights",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                collapsedBackgroundColor: Color.fromARGB(255, 225, 225, 225),
                backgroundColor: Color.fromARGB(255, 225, 225, 225),
                collapsedShape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                children: <Widget>[
                  ListTile(
                    subtitle: Text(
                        "You have the right to ask what personal data that we hold about you and to ask us to update and correct any out-of date or incorrect personal data that we hold about you. Your consent to the processing of your personal data may only be withdrawn by sending a written notice signed by you to the address of the Provider. If your consent to personal data processing is withdrawn, the Provider will delete your Money Tracker account and personal data with the consequences\nset out in the Terms."),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ExpansionTile(
                title: Text(
                  "Changes to our Privacy Policy",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                collapsedBackgroundColor: Color.fromARGB(255, 225, 225, 225),
                backgroundColor: Color.fromARGB(255, 225, 225, 225),
                collapsedShape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                children: <Widget>[
                  ListTile(
                    subtitle: Text(
                        "From time to time, it may become necessary to make changes to this Privacy Policy. Therefore, we reserve the right to update and/or modify this Privacy Policy at any time. Please review this Privacy Policy frequently, and especially before you register an account with Money Tracker. The date of the last modification is listed at the bottom of this Privacy Policy"),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ExpansionTile(
                title: Text(
                  "Contact",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                collapsedBackgroundColor: Color.fromARGB(255, 225, 225, 225),
                backgroundColor: Color.fromARGB(255, 225, 225, 225),
                collapsedShape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                children: <Widget>[
                  ListTile(
                    subtitle: Text(
                        "We may communicate with you by email and notices posted in your mobile device. If you do not wish to receive notices in your mobile device, you can always turn off this service in Money Tracker and your device native settings. Please be aware that if you unsubscribe from our mailing list you will still be receiving answers to your questions sent to our feedback/ support but you will not be receiving promotional emails. We welcome your feedback regarding our Services. If you have any questions or suggestions regarding our Privacy Policy please contact us at hello@apppeppers.com."),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
