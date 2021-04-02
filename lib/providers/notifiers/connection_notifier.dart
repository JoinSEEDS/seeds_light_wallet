import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:seeds/constants/config.dart';

class Endpoint {
  final String url;
  final int ping;
  const Endpoint(this.url, this.ping);
}

const infinitePing = 1000000;
const doubleInfinitePing = 2000000;

class ConnectionNotifier extends ChangeNotifier {
  bool status = true;

  String currentEndpoint = Config.defaultEndpoint;
  int currentEndpointPing = 0;

  final availableEndpoints = [
    Config.defaultEndpoint,
    'https://mainnet.telosusa.io',
    'https://telos.eosphere.io',
    'https://telos.caleos.io',
    'https://api.eos.miami',
    'https://hyperion.telosgermany.io',
  ];

  void init() {
    discoverEndpoints();
  }

  void discoverEndpoints() async {
    var checks = <Future>[];

    for (var endpoint in availableEndpoints) {
      checks.add(checkEndpoint(endpoint));
    }

    var responses = await Future.wait(checks);

    responses.sort((a, b) => a.ping - b.ping);

    currentEndpoint = responses[0].url;
    print('setting endpoint to ${responses[0].url}');
    currentEndpointPing = responses[0].ping;
    notifyListeners();

  }

  Future<Endpoint> checkEndpoint(String endpoint) async {
    try {
      var ping = Stopwatch()..start();
      var res = await get(Uri.parse('$endpoint/v2/health'));
      ping.stop();
      if (res.statusCode == 200) {
        var endpointPing = ping.elapsedMilliseconds;
        return Endpoint(endpoint, endpointPing);
      } else {
        return Endpoint(endpoint, infinitePing);
      }
    } catch (err) {
      print('error pinging: ${err.toString()}');
      return Endpoint(endpoint, doubleInfinitePing);
    }
  }
}
