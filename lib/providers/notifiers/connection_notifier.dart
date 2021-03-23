import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:seeds/constants/config.dart';

class Endpoint {
  final String url;
  final int ping;
  const Endpoint(this.url, this.ping);

  @override
  String toString() {
    return "Endpoint: $url ping: $ping ";
  }
}

const infinitePing = 1000000;
const doubleInfinitePing = 2000000;

class ConnectionNotifier extends ChangeNotifier {
  bool status = true;

  String currentEndpoint = Config.defaultEndpoint;
  int currentEndpointPing = 0;
  List<Endpoint> ellEndpoints = [];

  var availableEndpoints = [
    Config.defaultEndpoint,
    "https://api.telos.kitchen",
    "https://node.hypha.earth",
    'https://mainnet.telosusa.io',
    'https://telos.eosphere.io',
    'https://telos.caleos.io',
    'https://api.eos.miami',
  ];

  void init() {
    discoverEndpoints();
  }

  void discoverEndpoints() async {
    List<Future> checks = List<Future>();

    for (var endpoint in availableEndpoints) {
      checks.add(checkEndpoint(endpoint));
    }

    var responses = await Future.wait(checks);

    responses.sort((a, b) => a.ping - b.ping);


    ellEndpoints = List<Endpoint>.from(responses);

    currentEndpoint = responses[0].url;

    print("[ConnectionNotifier] using endpoint $currentEndpoint of ${ellEndpoints.toString()}");
    
    currentEndpointPing = responses[0].ping;
    
    notifyListeners();

  }
  
  void blacklistCurrentEndpoint() {

  }

  Future<Endpoint> checkEndpoint(String endpointURL) async {
    try {
      var ping = Stopwatch()..start();
      Response res = await get("$endpointURL/v1/chain/get_info");
      ping.stop();
      if (res.statusCode == 200) {
        int endpointPing = ping.elapsedMilliseconds;
        return Endpoint(endpointURL, endpointPing);
      } else {
        return Endpoint(endpointURL, infinitePing);
      }
    } catch (err) {
      print("error pinging: " + err);
      return Endpoint(endpointURL, doubleInfinitePing);
    }
  }
}
