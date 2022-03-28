import 'package:flutter/services.dart';

/// Navite implementation to clear webview cache
class WebViewCacheService {
  final _channel = const MethodChannel('lw.web_view.clear');

  const WebViewCacheService();

  /// Android: Clears all storage currently being used by the JavaScript storage APIs.
  /// This includes Web SQL Database and the HTML5 Web Storage APIs.
  ///
  /// iOS: Removes the specified types of website data from one or more data records.
  /// Removes cookies that were stored after a given date.
  Future<void> clearCache() async => _channel.invokeMethod('clear');
}
