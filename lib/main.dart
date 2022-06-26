import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:seeds/datasource/local/member_model_cache_item.dart';
import 'package:seeds/datasource/local/models/vote_model_adapter.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_push_notification_service.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/bloc_observer.dart';
import 'package:seeds/seeds_app.dart';

Future<void> main() async {
  // To catch errors that happen outside of the Flutter context
  // add an error listener on the current Isolate:
  Isolate.current.setErrorsFatal(false);
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
      fatal: true,
    );
  }).sendPort);

  // If we're using zones, instrumenting the zone’s error handler will catch errors
  // that aren't caught by the Flutter framework (i.e. in a button’s onPressed handler)
  // for details: https://docs.flutter.dev/testing/errors
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await settingsStorage.initialise();
    await PushNotificationService().initialise();
    await remoteConfigurations.initialise();
    await TokenModel.installModels(['lightwallet','experimental'], [TokenModel.seedsEcosysUsecase]);
    await Hive.initFlutter();
    Hive.registerAdapter(MemberModelCacheItemAdapter());
    Hive.registerAdapter(VoteModelAdapter());
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // Called whenever the Flutter framework catches an error.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    if (kDebugMode) {
      /// Bloc logs only in debug (for better performance in release)
      BlocOverrides.runZoned(() => runApp(const SeedsApp()), blocObserver: DebugBlocObserver());
    } else {
      runApp(const SeedsApp());
    }
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}
