import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
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
import 'package:seeds/domain-shared/bloc_observer.dart';
import 'package:seeds/seeds_app.dart';

Future<void> main() async {
  // Zone to handle asynchronous errors (Dart).
  // for details: https://docs.flutter.dev/testing/errors
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await settingsStorage.initialise();
    await PushNotificationService().initialise();
    await remoteConfigurations.initialise();
    await Hive.initFlutter();
    Hive.registerAdapter(MemberModelCacheItemAdapter());
    Hive.registerAdapter(VoteModelAdapter());
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // Called whenever the Flutter framework catches an error.
    FlutterError.onError = (details) async {
      FlutterError.presentError(details);
      // TODO(Raul): use FirebaseCrashlytics or whatever
      //await FirebaseCrashlytics.instance.recordFlutterError(details);
    };

    if (kDebugMode) {
      /// Bloc logs only in debug (for better performance in release)
      BlocOverrides.runZoned(() => runApp(const SeedsApp()), blocObserver: DebugBlocObserver());
    } else {
      runApp(const SeedsApp());
    }
  }, (error, stackTrace) async {
    //await FirebaseCrashlytics.instance.recordError(error, stack);
  });
}
