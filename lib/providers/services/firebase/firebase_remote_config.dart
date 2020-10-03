import 'package:firebase_remote_config/firebase_remote_config.dart';

const String _FeatureFlagGuardianKey = "feature_guardians";

class FirebaseRemoteConfigService {
  final defaults = <String, dynamic>{_FeatureFlagGuardianKey: false};

  final RemoteConfig _remoteConfig;
  static FirebaseRemoteConfigService _instance;

  FirebaseRemoteConfigService({RemoteConfig remoteConfig}) : _remoteConfig = remoteConfig;

  static Future<FirebaseRemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance = FirebaseRemoteConfigService(remoteConfig: await RemoteConfig.instance);
    }

    return _instance;
  }

  Future initialise() async {
    try {
      await _remoteConfig.setDefaults(defaults);
      await _fetchAndActivate();
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print('Remote config fetch throttled: $exception');
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
  }

  Future _fetchAndActivate() async {
    await _remoteConfig.fetch();
    await _remoteConfig.activateFetched();
  }

  bool get featureFlagGuardiansEnabled => _remoteConfig.getBool(_FeatureFlagGuardianKey);
}
