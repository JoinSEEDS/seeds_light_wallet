import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/internet_connection_checker.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  late StreamSubscription _snackSubscription;
  late StreamSubscription _connectivityResult;
  Timer? timer;

  RootBloc() : super(RootState.initial()) {
    _snackSubscription = eventBus.on<ShowSnackBar>().listen((event) async => add(OnRootBusEventRecived(event)));
    _connectivityResult = Connectivity().onConnectivityChanged.listen((_) => add(const OnConnectivityChanged()));
    on<OnRootBusEventRecived>((event, emit) => emit(state.copyWith(busEvent: event.busEvent)));
    on<OnConnectivityChanged>(_onConnectivityChanged);
    on<ClearRootBusEvent>((event, emit) => emit(state.copyWith()));
  }

  @override
  Future<void> close() async {
    await _snackSubscription.cancel();
    await _connectivityResult.cancel();
    return super.close();
  }

  Future<void> _onConnectivityChanged(OnConnectivityChanged event, Emitter<RootState> emit) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    //Check if device is just connect with mobile network or wifi
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      //Check there is actual internet connection with a mobile network or wifi
      if (await InternetConnectionChecker().hasConnection) {
        // Network data detected & internet connection confirmed.
        // And past state was dsiconnected.
        if (state.internetConnectionStatus == InternetConnectionStatus.disconnected) {
          emit(state.copyWith(internetConnectionStatus: InternetConnectionStatus.connected));
          timer?.cancel();
          eventBus.fire(const ShowSnackBar('Your internet connection was restored'));
        }
      } else {
        // Network data detected but no internet connection found.
        emit(state.copyWith(internetConnectionStatus: InternetConnectionStatus.disconnected));
        timer = Timer(const Duration(seconds: 5), () => eventBus.fire(const ShowSnackBar('You are currently offline')));
      }
    }
    // device has no mobile network and wifi connection at all
    else {
      emit(state.copyWith(internetConnectionStatus: InternetConnectionStatus.disconnected));
      timer = Timer(const Duration(seconds: 5), () => eventBus.fire(const ShowSnackBar('You are currently offline')));
    }
  }
}
