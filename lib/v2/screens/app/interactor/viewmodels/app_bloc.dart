import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/guardians_notification_use_case.dart';

/// --- BLOC
class AppBloc extends Bloc<AppEvent, AppState> {
  late StreamSubscription<bool> _hasGuardianNotificationPending;

  AppBloc() : super(AppState.initial()) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShouldShowNotificationBadge(value: value)));
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is ShouldShowNotificationBadge) {
      yield state.copyWith(hasNotification: event.value);
    }
    if (event is BottomBarTapped) {
      yield state.copyWith(index: event.index);
    }
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending.cancel();
    return super.close();
  }
}
