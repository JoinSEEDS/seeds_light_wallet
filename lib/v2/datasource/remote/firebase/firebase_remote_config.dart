import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_eos_servers.dart';

const String _featureFlagGuardianKey = 'feature_guardians';
const String _activeEOSEndpointKey = 'eos_enpoints';
const String _termsAndConditionsUrlKey = 'terms_and_conditions_url';

const String _eosEndpoints = '[ { "url": "https://mainnet.telosusa.io", "isDefault": true } ]';
const String _termsAndConditionsDefaultUrl = 'https://www.joinseeds.com/seeds-app-terms-and-conditions.html';

class _FirebaseRemoteConfigService {
  final defaults = <String, dynamic>{
    _featureFlagGuardianKey: false,
    _activeEOSEndpointKey: _eosEndpoints,
    _termsAndConditionsUrlKey: _termsAndConditionsDefaultUrl
  };

  RemoteConfig _remoteConfig;

  _FirebaseRemoteConfigService._();

  factory _FirebaseRemoteConfigService() => _instance;

  static final _FirebaseRemoteConfigService _instance = _FirebaseRemoteConfigService._();

  Future initialise() async {
    _remoteConfig = await RemoteConfig.instance;

    try {
      await _remoteConfig.setDefaults(defaults);
      await _remoteConfig.fetchAndActivate();
    } on Exception catch (exception) {
      // Fetch throttled.
      print('Remote config fetch throttled: $exception');
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
  }

  bool get featureFlagGuardiansEnabled => _remoteConfig.getBool(_featureFlagGuardianKey);

  String get termsAndConditions => _remoteConfig.getString(_termsAndConditionsUrlKey);

  FirebaseEosServer get activeEOSServerUrl => parseEosServers(_remoteConfig.getString(_activeEOSEndpointKey))
      .firstWhere((FirebaseEosServer element) => element.isDefault);
}

// A function that converts a response body into a List<FirebaseEosServer>.
List<FirebaseEosServer> parseEosServers(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<FirebaseEosServer>((json) => FirebaseEosServer.fromJson(json)).toList();
}

/// Singleton
_FirebaseRemoteConfigService remoteConfigurations = _FirebaseRemoteConfigService();
