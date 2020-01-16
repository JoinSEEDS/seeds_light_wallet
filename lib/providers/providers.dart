import 'package:provider/provider.dart';
import 'package:seeds/providers/services/config_service.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/members_notifier.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';

final providers = [
  Provider(
    create: (_) => ConfigService()
      ..init(
        [
          {"name": "public_config.json", "isRequired": true},
          {"name": "secret_config.json", "isRequired": false}
        ],
      ),
  ),
  Provider(create: (_) => HttpService()),
  ChangeNotifierProvider(create: (_) => AuthNotifier()..init()),
  ProxyProvider2<AuthNotifier, ConfigService, EosService>(
    create: (context) => EosService(),
    update: (context, auth, config, eos) =>
        eos..init(auth: auth, config: config),
  ),
  ChangeNotifierProxyProvider<HttpService, MembersNotifier>(
    create: (context) => MembersNotifier(),
    update: (context, http, members) => members..init(http: http),
  ),
  ChangeNotifierProxyProvider2<AuthNotifier, HttpService, TransactionsNotifier>(
      create: (context) => TransactionsNotifier(),
      update: (context, auth, http, transactions) =>
          transactions..init(auth: auth, http: http)),
  ChangeNotifierProxyProvider2<AuthNotifier, HttpService, BalanceNotifier>(
      create: (context) => BalanceNotifier(),
      update: (context, auth, http, balance) =>
          balance..init(auth: auth, http: http)),
];
