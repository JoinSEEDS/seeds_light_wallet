import 'package:provider/provider.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/connection_notifier.dart';
import 'package:seeds/providers/notifiers/members_notifier.dart';
import 'package:seeds/providers/notifiers/planted_notifier.dart';
import 'package:seeds/providers/notifiers/profile_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/notifiers/transactions_notifier.dart';
import 'package:seeds/providers/notifiers/voice_notifier.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/providers/services/links_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';

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
  ProxyProvider<SettingsNotifier, LinksService>(
    create: (_) => LinksService(),
    update: (_, settings, links) => links
      ..update(
        accountName: settings.accountName,
        enableMockLink: false,
      ),
  ),
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
  ChangeNotifierProxyProvider<HttpService, MembersNotifier>(
    create: (context) => MembersNotifier(),
    update: (context, http, members) => members..update(http: http),
  ),
  ChangeNotifierProxyProvider<HttpService, TransactionsNotifier>(
    create: (context) => TransactionsNotifier(),
    update: (context, http, transactions) => transactions..update(http: http),
  ),
  ChangeNotifierProxyProvider<HttpService, BalanceNotifier>(
    create: (context) => BalanceNotifier(),
    update: (context, http, balance) => balance..update(http: http),
  ),
  ChangeNotifierProxyProvider<HttpService, VoiceNotifier>(
    create: (context) => VoiceNotifier(),
    update: (context, http, balance) => balance..update(http: http),
  ),
  ChangeNotifierProxyProvider<HttpService, PlantedNotifier>(
    create: (context) => PlantedNotifier(),
    update: (context, http, balance) => balance..update(http: http),
  ),
  ChangeNotifierProxyProvider<HttpService, ProfileNotifier>(
    create: (context) => ProfileNotifier(),
    update: (context, http, members) => members..update(http: http),
  ),
];
