import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_eos_servers.dart';

const String _featureFlagGuardianKey = 'feature_guardians';
const String _activeEOSEndpointKey = 'eos_enpoints';

const String eosEndpoints = '[ { "url": "https://mainnet.telosusa.io", "isDefault": true } ]';

class FirebaseRemoteConfigService {
  final defaults = <String, dynamic>{_featureFlagGuardianKey: false, _activeEOSEndpointKey: eosEndpoints};

  RemoteConfig _remoteConfig;

  FirebaseRemoteConfigService._();

  factory FirebaseRemoteConfigService() => _instance;

  static final FirebaseRemoteConfigService _instance = FirebaseRemoteConfigService._();

  Future initialise() async {
    _remoteConfig = await RemoteConfig.instance;

    try {
      await _remoteConfig.setDefaults(defaults);
      await _fetchAndActivate();
    } on Exception catch (exception) {
      // Fetch throttled.
      print('Remote config fetch throttled: $exception');
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
  }

  Future _fetchAndActivate() async {
    await _remoteConfig.fetchAndActivate();
  }

  bool get featureFlagGuardiansEnabled => _remoteConfig.getBool(_featureFlagGuardianKey);

  FirebaseEosServer get activeEOSServerUrl => parseEosServers(_remoteConfig.getString(_activeEOSEndpointKey))
      .firstWhere((FirebaseEosServer element) => element.isDefault);
}

// A function that converts a response body into a List<FirebaseEosServer>.
List<FirebaseEosServer> parseEosServers(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<FirebaseEosServer>((json) => FirebaseEosServer.fromJson(json)).toList();
}
