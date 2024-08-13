import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app_colors.dart';
import '../../data/ad_helper.dart';
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

  late BannerAd _bottomBannerAd;
  int maxFailedLoadAttempts = 3;
  bool _isBottomBannerAdLoaded = false;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  String loading = '';
  static AdRequest request = const AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
            loading = '';
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  @override
  void initState() {
    _createInterstitialAd();
    _createBottomBannerAd();
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launchURL() async {
    final Uri url = Uri.parse("https://play.google.com/store/apps/details?id=com.k2digital.moneytracker.pro");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
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
          'menuSetting'.tr(),
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
                        title: Text(
                          "menuFeedback".tr(),
                          style: TextStyle(fontFamily: 'Hanuman'),
                        ),
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
                        title: Text(
                          "menuShare".tr(),
                          style: TextStyle(fontFamily: 'Hanuman'),
                        ),
                        leading: Image.asset("assets/images/icon/share.png",
                            height: 28, width: 28),
                        onTap: () async {
                          if (kDebugMode) {
                            print("Sharing");
                          }
                          _launchURL();
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
                        title: Text(
                          "menuPrivacy".tr(),
                          style: TextStyle(fontFamily: 'Hanuman'),
                        ),
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
              SizedBox(
                height: _bottomBannerAd.size.height.toDouble(),
                width: _bottomBannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bottomBannerAd),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: 
      TextButton(
        onPressed: _showInterstitialAd,
        child: Text(
          loading,
          style: TextStyle(
              fontFamily: 'Hanuman',
              fontWeight: FontWeight.normal,
              fontSize: 12,
              color: AppColors.myColorBlack),
        ),
      ),
    );
  }
}
