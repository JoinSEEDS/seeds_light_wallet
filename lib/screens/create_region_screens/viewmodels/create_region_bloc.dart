import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/create_region_screens/viewmodels/create_region_page_commands.dart';

part 'create_region_events.dart';

part 'create_region_state.dart';

class CreateRegionBloc extends Bloc<CreateRegionEvent, CreateRegionState> {
  CreateRegionBloc() : super(CreateRegionState.initial()) {
    on<OnNextTapped>(_onNextTapped);
    on<OnCreateRegionTapped>(_onCreateAccountTapped);
    on<OnBackPressed>(_onBackPressed);
    on<ClearCreateRegionPageCommand>((_, emit) => emit(state.copyWith()));
  }

  void _onNextTapped(OnNextTapped event, Emitter<CreateRegionState> emit) {}

  Future<void> _onCreateAccountTapped(OnCreateRegionTapped event, Emitter<CreateRegionState> emit) async {}

  void _onBackPressed(OnBackPressed event, Emitter<CreateRegionState> emit) {
    switch (state.createRegionsScreens) {
      case CreateRegionScreens.selectRegion:
        emit(state.copyWith(pageCommand: ReturnToJoinRegion()));
        break;
      case CreateRegionScreens.displayName:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreens.selectRegion));
        break;
      case CreateRegionScreens.addDescription:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreens.displayName));
        break;
      case CreateRegionScreens.selectBackgroundImage:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreens.addDescription));
        break;
      case CreateRegionScreens.reviewRegion:
        emit(state.copyWith(createRegionsScreens: CreateRegionScreens.selectBackgroundImage));
        break;
    }
  }
}
