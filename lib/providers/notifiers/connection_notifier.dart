import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:seeds/constants/config.dart';

class ConnectionNotifier extends ChangeNotifier {
  bool status = true;

  String currentEndpoint = Config.defaultEndpoint;
  int currentEndpointPing = 0;

  final availableEndpoints = [
    Config.defaultEndpoint,
    //'https://mainnet.telosusa.io',
    'https://telos.eosphere.io',
    'https://telos.caleos.io',
  ];

  void init() {
    discoverEndpoints();
  }

  void discoverEndpoints() async {
    for (var endpoint in availableEndpoints) {
      var ping = Stopwatch()..start();

      Response res = await get("$endpoint/v2/health");

      ping.stop();

      if (res.statusCode == 200) {
        int endpointPing = ping.elapsedMilliseconds;

        print("ping from $endpoint is $endpointPing");

        if (currentEndpointPing == 0 || endpointPing < currentEndpointPing) {
          currentEndpoint = endpoint;
          currentEndpointPing = endpointPing;
          notifyListeners();
        }
      }
    }
  }
}
