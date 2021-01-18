import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/config.dart';
import 'package:seeds/constants/http_mock_response.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/app/ecosystem/peerswap/peerswap.dart';

class SeedsDevApp extends StatefulWidget {
  @override
  _SeedsDevAppState createState() => _SeedsDevAppState();
}

class _SeedsDevAppState extends State<SeedsDevApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => HttpService()..mockResponse = true,
        ),
        Provider(
          create: (_) => EosService()
            ..update(
              userPrivateKey: HttpMockResponse.privateKey,
              userAccountName: HttpMockResponse.accountName,
              nodeEndpoint: Config.hyphaEndpoint,
              enableMockTransactions: true,
            ),
        ),
        Provider(
          create: (_) => NavigationService(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        home: Scaffold(
          body: PeerSwap(),
        ),
      ),
    );
  }
}
