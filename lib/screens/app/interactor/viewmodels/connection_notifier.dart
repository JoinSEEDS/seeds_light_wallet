import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';

class Endpoint {
  final String url;
  final int ping;

  const Endpoint(this.url, this.ping);
}

const infinitePing = 1000000;
const doubleInfinitePing = 2000000;

class ConnectionNotifier extends ChangeNotifier {
  bool status = true;

  String? currentEndpoint = remoteConfigurations.defaultEndPointUrl;
  int? currentEndpointPing = 0;

  final availableEndpoints = [
    remoteConfigurations.defaultEndPointUrl,
    'https://mainnet.telos.net',
    'https://mainnet.telosusa.io',
    'https://telos.eosphere.io',
    'https://telos.caleos.io',
    'https://telos.greymass.com',
  ];

  Future<void> discoverEndpoints() async {
    final checks = <Future<Endpoint>>[];

    for (final endpoint in availableEndpoints) {
      checks.add(checkEndpoint(endpoint));
    }

    final responses = await Future.wait(checks);

    responses.sort((a, b) => a.ping - b.ping);

    currentEndpoint = responses[0].url;
    print('setting endpoint to ${responses[0].url}');
    currentEndpointPing = responses[0].ping;
    notifyListeners();
  }

  Future<Endpoint> checkEndpoint(String endpoint) async {
    try {
      final ping = Stopwatch()..start();
      final res = await get(Uri.parse('$endpoint/v2/health'));
      ping.stop();
      if (res.statusCode == 200) {
        final endpointPing = ping.elapsedMilliseconds;
        return Endpoint(endpoint, endpointPing);
      } else {
        return Endpoint(endpoint, infinitePing);
      }
    } catch (err) {
      print('error pinging: ${err}');
      return Endpoint(endpoint, doubleInfinitePing);
    }
  }
}
