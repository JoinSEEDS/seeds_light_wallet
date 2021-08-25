import 'dart:convert';

// import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/model/firebase_eos_servers.dart';

const String _featureFlagGuardianKey = 'feature_guardians';
const String _activeEOSEndpointKey = 'eos_enpoints';
const String _termsAndConditionsUrlKey = 'terms_and_conditions_url';
const String _privacyPolicyKey = 'privacy_policy';
const String _hyphaEndPointKey = 'hypha_end_point';
const String _explorerUrlKey = 'explore_url';
const String _dhoExplorerUrlKey = 'dho_explore_url';
const String _defaultEndPointUrlKey = 'default_end_point';
const String _defaultV2EndPointUrlKey = 'default_v2_end_point';

const String _eosEndpoints = '[ { "url": "https://api.telosfoundation.io", "isDefault": true } ]';
const String _termsAndConditionsDefaultUrl = 'https://www.joinseeds.com/seeds-app-terms-and-conditions.html';
const String _privacyPolicyUrl = 'https://www.joinseeds.com/seeds-app-privacy-policy.html';
const String _hyphaEndPointUrl = 'https://node.hypha.earth';
const String _mongodbURL = 'https://mongo-api.hypha.earth/find';
const String _explorerUrl = 'https://telos.bloks.io';
const String _dhoExplorerUrl = 'https://dho.hypha.earth';
const String _defaultEndPointUrl = "https://api.telosfoundation.io";
// we need a separate endpoint for v2/history as most nodes don't support v2
const String _defaultV2EndpointUrl = "https://api.telosfoundation.io";

class _FirebaseRemoteConfigService {
  final defaults = <String, dynamic>{
    _featureFlagGuardianKey: false,
    _activeEOSEndpointKey: _eosEndpoints,
    _termsAndConditionsUrlKey: _termsAndConditionsDefaultUrl,
    _privacyPolicyKey: _privacyPolicyUrl,
    _hyphaEndPointKey: _hyphaEndPointUrl,
    _explorerUrlKey: _explorerUrl,
    _dhoExplorerUrlKey: _dhoExplorerUrl,
    _defaultEndPointUrlKey: _defaultEndPointUrl,
    _defaultV2EndPointUrlKey: _defaultV2EndpointUrl
  };

  // RemoteConfig _remoteConfig;
  factory _FirebaseRemoteConfigService() => _instance;

  _FirebaseRemoteConfigService._();

  static final _FirebaseRemoteConfigService _instance = _FirebaseRemoteConfigService._();

  void refresh() {
    // Config has not been init yet. Dont call this function.
    // if (_remoteConfig == null) {
    //   return;
    // }

    // _remoteConfig.fetch().then((value) {
    //   print(" _remoteConfig fetch worked");
    //   _remoteConfig.activate().then((bool value) {
    //     print(" _remoteConfig activate worked params were activated " + value.toString());
    //   }).onError((error, stackTrace) {
    //     print(" _remoteConfig activate failed");
    //   });
    // }).onError((error, stackTrace) {
    //   print(" _remoteConfig fetch failed");
    // });
  }

  Future initialise() async {
    // _remoteConfig = await RemoteConfig.instance;
    //
    // /// Maximum age of a cached config before it is considered stale. we set to 60 secs since we store important data.
    // await _remoteConfig.setConfigSettings(RemoteConfigSettings(
    //   minimumFetchInterval: const Duration(seconds: 60),
    //   fetchTimeout: const Duration(seconds: 60),
    // ));
    //
    // await _remoteConfig.setDefaults(defaults);
    // refresh();
  }

  bool get featureFlagGuardiansEnabled => false; //_remoteConfig.getBool(_featureFlagGuardianKey);

  String get termsAndConditions => _termsAndConditionsDefaultUrl; //_remoteConfig.getString(_termsAndConditionsUrlKey);

  String get privacyPolicy => _privacyPolicyUrl; //_remoteConfig.getString(_privacyPolicyKey);

  String get hyphaEndPoint => _hyphaEndPointUrl; //_remoteConfig.getString(_hyphaEndPointUrl);

  String get mongodbURL => _mongodbURL; //_remoteConfig.getString(_mongodbURL);

  String get explorerUrl => _explorerUrl; //_remoteConfig.getString(_explorerUrlKey);

  String get dhoExplorerUrl => _explorerUrl; //_dhoExplorerUrl;//_remoteConfig.getString(_dhoExplorerUrlKey);

  String get defaultEndPointUrl => _defaultEndPointUrl; //_remoteConfig.getString(_defaultEndPointUrlKey);

  String get defaultV2EndPointUrl => _defaultV2EndpointUrl; //_remoteConfig.getString(_defaultEndPointUrlKey);

  //_remoteConfig.getString(_activeEOSEndpointKey)
  FirebaseEosServer get activeEOSServerUrl =>
      parseEosServers(_eosEndpoints)!.firstWhere((FirebaseEosServer element) => element.isDefault!);
}

// A function that converts a response body into a List<FirebaseEosServer>.
List<FirebaseEosServer>? parseEosServers(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<FirebaseEosServer>((json) => FirebaseEosServer.fromJson(json)).toList();
}

/// Singleton
_FirebaseRemoteConfigService remoteConfigurations = _FirebaseRemoteConfigService();
