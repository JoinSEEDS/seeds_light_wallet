import 'package:provider/provider.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/members_notifier.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';

final providers = [
  ChangeNotifierProvider(create: (_) => AuthNotifier()..init()),
  ProxyProvider<AuthNotifier, HttpService>(
    create: (_) => HttpService(),
    update: (_, auth, http) => http
      ..init(
        accountName: auth.accountName,
        enableMockResponse: false,
      ),
  ),
  ProxyProvider<AuthNotifier, EosService>(
    create: (context) => EosService(),
    update: (context, auth, eos) =>
        eos..init(userPrivateKey: auth.privateKey, userAccountName: auth.accountName),
  ),
  ChangeNotifierProxyProvider<HttpService, MembersNotifier>(
    create: (context) => MembersNotifier(),
    update: (context, http, members) => members..init(http: http),
  ),
  ChangeNotifierProxyProvider<HttpService, TransactionsNotifier>(
      create: (context) => TransactionsNotifier(),
      update: (context, http, transactions) => transactions..init(http: http)),
  ChangeNotifierProxyProvider<HttpService, BalanceNotifier>(
      create: (context) => BalanceNotifier(),
      update: (context, http, balance) => balance..init(http: http)),
];
