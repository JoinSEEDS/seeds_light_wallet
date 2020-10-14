import 'package:firebase_remote_config/firebase_remote_config.dart';

const String _FeatureFlagGuardianKey = "feature_guardians";

class FirebaseRemoteConfigService {
  final defaults = <String, dynamic>{_FeatureFlagGuardianKey: false};
  RemoteConfig _remoteConfig;

  FirebaseRemoteConfigService._();

  factory FirebaseRemoteConfigService() => _instance;

  static final FirebaseRemoteConfigService _instance = FirebaseRemoteConfigService._();

  Future initialise() async {
    _remoteConfig = await RemoteConfig.instance;

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