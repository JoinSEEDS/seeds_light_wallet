import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/model/firebase_eos_servers.dart';

const String _activeEOSEndpointKey = 'eos_enpoints';
const String _hyphaEndPointKey = 'hypha_end_point';
const String _defaultEndPointUrlKey = 'default_end_point';
const String _defaultV2EndPointUrlKey = 'default_v2_end_point';

// MAINNET CONFIG
const String _eosEndpoints = '[ { "url": "https://api.telosfoundation.io", "isDefault": true } ]';
const String _hyphaEndPointUrl = 'https://node.hypha.earth';
const String _defaultEndPointUrl = "https://api.telosfoundation.io";
// we need a separate endpoint for v2/history as most nodes don't support v2
const String _defaultV2EndpointUrl = "https://api.telosfoundation.io";

// DO NOT PUSH TO PROD WITH THIS SET TO TRUE. This is used for testing purposes only
const bool testnetMode = false;

// TESTNET CONFIG: Used for testing purposes.
const String _testnet_eosEndpoints = '[ { "url": "https://test.hypha.earth", "isDefault": true } ]';
const String _testnet_hyphaEndPointUrl = 'https://test.hypha.earth';
const String _testnet_defaultEndPointUrl = "https://test.hypha.earth";
const String _testnet_defaultV2EndpointUrl = "https://api-test.telosfoundation.io";
// END - TESTNET CONFIG

class _FirebaseRemoteConfigService {
  late RemoteConfig _remoteConfig;

  factory _FirebaseRemoteConfigService() => _instance;

  _FirebaseRemoteConfigService._();

  static final _FirebaseRemoteConfigService _instance = _FirebaseRemoteConfigService._();

  final defaults = <String, dynamic>{
    _activeEOSEndpointKey: _eosEndpoints,
    _hyphaEndPointKey: _hyphaEndPointUrl,
    _defaultEndPointUrlKey: _defaultEndPointUrl,
    _defaultV2EndPointUrlKey: _defaultV2EndpointUrl
  };

  void refresh() {
    _remoteConfig.fetch().then((value) {
      print(" _remoteConfig fetch worked");
      _remoteConfig.activate().then((bool value) {
        print(" _remoteConfig activate worked params were activated $value");
      }).onError((error, stackTrace) {
        print(" _remoteConfig activate failed");
      });
    }).onError((error, stackTrace) {
      print(" _remoteConfig fetch failed");
    });
  }

  Future initialise() async {
    _remoteConfig = RemoteConfig.instance;
    await _remoteConfig.setDefaults(defaults);

    /// Maximum age of a cached config before it is considered stale. we set to 60 secs since we store important data.
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      minimumFetchInterval: const Duration(seconds: 60),
      fetchTimeout: const Duration(seconds: 60),
    ));

    refresh();
  }

  String get hyphaEndPoint => testnetMode ? _testnet_hyphaEndPointUrl : _remoteConfig.getString(_hyphaEndPointUrl);

  String get defaultEndPointUrl =>
      testnetMode ? _testnet_defaultEndPointUrl : _remoteConfig.getString(_defaultEndPointUrlKey);

  String get defaultV2EndPointUrl =>
      testnetMode ? _testnet_defaultV2EndpointUrl : _remoteConfig.getString(_defaultV2EndPointUrlKey);

  FirebaseEosServer get activeEOSServerUrl =>
      parseEosServers(testnetMode ? _testnet_eosEndpoints : _remoteConfig.getString(_activeEOSEndpointKey)).firstWhere(
          (FirebaseEosServer element) => element.isDefault!,
          orElse: () => parseEosServers(_remoteConfig.getString(_eosEndpoints)).first);
}

// A function that converts a response body into a List<FirebaseEosServer>.
List<FirebaseEosServer> parseEosServers(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<FirebaseEosServer>((json) => FirebaseEosServer.fromJson(json)).toList();
}

/// Singleton
_FirebaseRemoteConfigService remoteConfigurations = _FirebaseRemoteConfigService();
