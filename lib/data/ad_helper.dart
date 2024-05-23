import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6443442205769107/6683338474";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6443442205769107/6683338474";
    } else {
      throw  UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6443442205769107/8762329602";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6443442205769107/8762329602";
    } else {
      throw  UnsupportedError("Unsupported platform");
    }
  }
}