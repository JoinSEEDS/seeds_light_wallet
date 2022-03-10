import UIKit
import Flutter
import GoogleMaps
import WebKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey("AIzaSyB3Ghs8i_Lw55vmSyh5mxLA9cGcWuc1A54")
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "lw.web_view.clear",
                                           binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            guard call.method == "clear" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.clearWebViewCache(result: result)
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func clearWebViewCache(result: FlutterResult) {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("Swift - Appdelegate: All cookies deleted")
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("Swift - Appdelegate: Record \(record) deleted")
            }
        }
        result(true)
    }
}
