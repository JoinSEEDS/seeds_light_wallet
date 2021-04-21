import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/guardians_notification_use_case.dart';

/// --- BLOC
class AppBloc extends Bloc<AppEvent, AppState> {
  StreamSubscription<bool?>? _hasGuardianNotificationPending;

  AppBloc() : super(AppState.initial()) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShowNotificationBadge(value: value!)));
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is ShowNotificationBadge) {
      yield state.copyWith(hasNotification: event.value);
    }
    if (event is BottomTapped) {
      yield state.copyWith(index: event.index);
    }
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending?.cancel();
    return super.close();
  }
}
