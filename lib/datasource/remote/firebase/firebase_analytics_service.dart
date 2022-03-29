import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> sendEvent(String name, Map<String, dynamic> data) async {
    await _analytics.logEvent(name: name, parameters: data);
  }

  Future<void> setUserId(String id) async => _analytics.setUserId(id: id);
}
