import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seeds/app_development.dart';
import 'package:seeds/app_production.dart';
import 'package:seeds/models/VoteResultAdapter.dart';
import 'package:seeds/models/member_adapter.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/models/transaction_adapter.dart';
import 'package:seeds/providers/notifiers/voted_notifier.dart';
import 'package:seeds/providers/services/firebase/firebase_remote_config.dart';

import 'package:sentry/sentry.dart' as Sentry;

final Sentry.SentryClient _sentry = Sentry.SentryClient(
    dsn: "https://ee2dd9f706974248b5b4a10850586d94@sentry.io/2239437");

bool get inDevelopmentMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// Reports [error] along with its [stackTrace] to Sentry.io.
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');
  print('Reporting to Sentry.io...');

  final Sentry.SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}

main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  Hive.registerAdapter<MemberModel>(MemberAdapter());
  Hive.registerAdapter<VoteResult>(VoteResultAdapter());
  Hive.registerAdapter<TransactionModel>(TransactionAdapter());
  await Firebase.initializeApp();
  FirebaseRemoteConfigService().initialise();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    if (inDevelopmentMode) {
      runApp(SeedsDevApp());
    } else {
      FlutterError.onError = (FlutterErrorDetails details) async {
        print('FlutterError.onError caught an error');
        await _reportError(details.exception, details.stack);
      };

      Isolate.current.addErrorListener(
        RawReceivePort((dynamic pair) async {
          print('Isolate.current.addErrorListener caught an error');
          await _reportError(
            (pair as List<String>).first,
            (pair as List<String>).last,
          );
        }).sendPort,
      );

      runZonedGuarded<Future<Null>>(() async {
        runApp(SeedsApp());
      }, (error, stackTrace) async {
        print('Zone caught an error');
        await _reportError(error, stackTrace);
      });
    }
  });
}
