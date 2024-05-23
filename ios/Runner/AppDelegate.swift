import UIKit
import Flutter
import Firebase
import GoogleSignIn
import GoogleMobileAds

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    print("Your code here")
    FirebaseApp.configure()
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)

  }
}
