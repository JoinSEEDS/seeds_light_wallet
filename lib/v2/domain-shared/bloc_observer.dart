import 'package:bloc/bloc.dart';

/// Custom [BlocObserver] which observes all bloc and cubit instances.
/// Their life cycles events.
///
/// Every event of BlocObserver has a reference to a cubit/bloc instance that sends the event.
/// So you can compare it with the reference with your specific cubit/bloc instance.
/// And if references are equal you can handle it somehow
///
/// ```dart
///   class MyObserver extends BlocObserver {
///
///   final Cubit<Object> _cubit;
///
///   MyObserver(this._cubit) : assert(_cubit != null);
///
///   @override
///   void onClose(Cubit cubit) {
///     if (cubit == _cubit) {
///       // do whatever you need
///     }
///
///     super.onClose(cubit);
///   }
/// }
/// ```
class SimpleBlocObserver extends BlocObserver {
  // TODO(raul): uncomment when upgrade Dart sdk to 2.12.0, https://github.com/JoinSEEDS/seeds_light_wallet/issues/645
  // @override
  // void onEvent(Bloc bloc, Object? event) {
  //   super.onEvent(bloc, event);
  //   print(event);
  // }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}
