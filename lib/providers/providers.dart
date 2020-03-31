import 'package:provider/provider.dart';
import 'package:teloswallet/providers/notifiers/auth_notifier.dart';
import 'package:teloswallet/providers/notifiers/connection_notifier.dart';
import 'package:teloswallet/providers/notifiers/resources_notifier.dart';
import 'package:teloswallet/providers/notifiers/settings_notifier.dart';
import 'package:teloswallet/providers/notifiers/telos_balance_notifier.dart';
import 'package:teloswallet/providers/notifiers/transactions_notifier.dart';
import 'package:teloswallet/providers/services/eos_service.dart';
import 'package:teloswallet/providers/services/http_service.dart';
import 'package:teloswallet/providers/services/navigation_service.dart';

// Connection => Settings => Auth => Http => Members
final providers = [
  Provider(
    create: (_) => NavigationService(),
  ),
  ChangeNotifierProvider(
    create: (_) => ConnectionNotifier()..init(),
  ),
  ChangeNotifierProxyProvider<ConnectionNotifier, SettingsNotifier>(
    create: (_) => SettingsNotifier()..init(),
    update: (_, connection, settings) => settings
      ..update(
        nodeEndpoint: connection.currentEndpoint,
      ),
  ),
  ChangeNotifierProxyProvider<SettingsNotifier, AuthNotifier>(
      create: (_) => AuthNotifier(),
      update: (_, settings, auth) {
        if (settings.isInitialized) {
          return auth
            ..update(
              accountName: settings.accountName,
              privateKey: settings.privateKey,
              passcode: settings.passcode,
            );
        } else {
          return auth;
        }
      }),
  ProxyProvider<SettingsNotifier, HttpService>(
    create: (_) => HttpService(),
    update: (_, settings, http) => http
      ..update(
        accountName: settings.accountName,
        nodeEndpoint: settings.nodeEndpoint,
        enableMockResponse: false,
      ),
  ),
  ProxyProvider<SettingsNotifier, EosService>(
    create: (context) => EosService(),
    update: (context, settings, eos) => eos
      ..update(
        userPrivateKey: settings.privateKey,
        userAccountName: settings.accountName,
        nodeEndpoint: settings.nodeEndpoint,
        enableMockTransactions: false,
      ),
  ),
  ChangeNotifierProxyProvider<HttpService, TransactionsNotifier>(
    create: (context) => TransactionsNotifier(),
    update: (context, http, transactions) => transactions..update(http: http),
  ),
  ChangeNotifierProxyProvider<HttpService, TelosBalanceNotifier>(
    create: (context) => TelosBalanceNotifier(),
    update: (context, http, balance) => balance..update(http: http),
  ),
  ChangeNotifierProxyProvider<HttpService, ResourcesNotifier>(
    create: (context) => ResourcesNotifier(),
    update: (context, http, balance) => balance..update(http: http),
  ),
];
