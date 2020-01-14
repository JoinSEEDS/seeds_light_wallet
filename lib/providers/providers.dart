import 'package:provider/provider.dart';

import 'package:seeds/services/eos_service.dart';
import 'package:seeds/services/http_service.dart';

import './notifiers/auth_notifier.dart';
import './notifiers/balance_notifier.dart';
import './notifiers/members_notifier.dart';
import './notifiers/transactions_notifier.dart';

final providers = [
  Provider(create: (_) => HttpService()),
  ChangeNotifierProvider(create: (_) => AuthNotifier()..init()),
  ProxyProvider<AuthNotifier, EosService>(
    create: (context) => EosService(),
    update: (context, auth, eos) => eos..init(auth: auth),
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