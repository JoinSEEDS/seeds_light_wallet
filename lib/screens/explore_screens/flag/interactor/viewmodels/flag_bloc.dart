import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:seeds/screens/explore_screens/flag/interactor/viewmodels/flag_event.dart';
import 'package:seeds/screens/explore_screens/flag/interactor/viewmodels/flag_state.dart';

class FlagBloc extends Bloc<FlagEvent, FlagState> {
  FlagBloc() : super(FlagState.initial()) {
    on<LoadUsersFlags>(_loadUserBalance);
  }

  FutureOr<void> _loadUserBalance(event, Emitter<FlagState> emit) {}
}
