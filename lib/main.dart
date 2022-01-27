import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:seeds/datasource/local/member_model_cache_item.dart';
import 'package:seeds/datasource/local/models/vote_model_adapter.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_push_notification_service.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/internet_connection_checker.dart';
import 'package:seeds/domain-shared/bloc_observer.dart';
import 'package:seeds/seeds_app.dart';

bool get isInDebugMode {
  var inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// Reports [error] along with its [stackTrace] to ?????
Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  // TODO(gguij002): find better error reporting
  print('Caught error: $error');
}

Future<void> main(List<String> args) async {
  late StreamSubscription listener;
  listener = InternetConnectionChecker().onStatusChange.listen(
    (status) async {
      switch (status) {
        case InternetConnectionStatus.connected:
          await listener.cancel();
          WidgetsFlutterBinding.ensureInitialized();
          await Firebase.initializeApp();
          await settingsStorage.initialise();
          await PushNotificationService().initialise();
          await remoteConfigurations.initialise();
          await Hive.initFlutter();
          Hive.registerAdapter(MemberModelCacheItemAdapter());
          Hive.registerAdapter(VoteModelAdapter());

          await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
              .then((_) {
            if (isInDebugMode) {
              BlocOverrides.runZoned(() => runApp(const SeedsApp()), blocObserver: DebugBlocObserver());
            } else {
              FlutterError.onError = (FlutterErrorDetails details) async {
                print('FlutterError.onError caught an error');
                await _reportError(details.exception, details.stack);
              };

              Isolate.current.addErrorListener(
                RawReceivePort((dynamic pair) async {
                  print('Isolate.current.addErrorListener caught an error');
                  await _reportError((pair as List<String>).first, pair.last);
                }).sendPort,
              );

              runZonedGuarded<void>(() => runApp(const SeedsApp()), (error, stackTrace) async {
                print('Zone caught an error');
                await _reportError(error, stackTrace);
              });
            }
          });
          break;
        case InternetConnectionStatus.disconnected:
          runApp(const MaterialApp(home: NoConnection()));
          break;
      }
    },
  );
}

class NoConnection extends StatefulWidget {
  const NoConnection({Key? key}) : super(key: key);

  @override
  State<NoConnection> createState() => _NoConnectionState();
}

class _NoConnectionState extends State<NoConnection> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(context: context, builder: (context) => const AlertDialog(title: Text('No internet')));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.transparent);
  }
}
