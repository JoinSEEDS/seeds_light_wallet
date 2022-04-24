import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/interactor/usecases/join_region_event_use_case.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/interactor/usecases/leave_region_event_use_case.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/interactor/viewmodels/page_commands.dart';

part 'region_event_details_event.dart';

part 'region_event_details_state.dart';

class RegionEventDetailsBloc extends Bloc<RegionEventDetailsEvent, RegionEventDetailsState> {
  RegionEventDetailsBloc(RegionEventModel event) : super(RegionEventDetailsState.initial(event)) {
    on<OnRegionMapsLinkTapped>((_, emit) => emit(state.copyWith(pageCommand: LaunchRegionMapsLocation())));
    on<OnJoinRegionEventButtonPressed>(_onJoinRegionEventButtonPressed);
    on<OnLeaveRegionEventButtonPressed>(_onLeaveRegionEventButtonPressed);
    on<OnEditRegionEventButtonTapped>((_, emit) => emit(state.copyWith(pageCommand: ShowEditRegionEventButtons())));
    on<OnEditEventImageTapped>((_, emit) => emit(state.copyWith()));
    on<OnEditEventNameAndDescriptionTapped>(_onEditEventNameAndDescriptionTapped);
    on<OnEditEventDateAndTimeTapped>((_, emit) => emit(state.copyWith()));
    on<OnEditEventLocationTapped>((_, emit) => emit(state.copyWith()));
    on<OnDeleteEventTapped>((_, emit) => emit(state.copyWith()));
    on<ClearRegionEventPageCommand>((_, emit) => emit(state.copyWith()));
  }

  void _onEditEventNameAndDescriptionTapped(
      OnEditEventNameAndDescriptionTapped event, Emitter<RegionEventDetailsState> emit) {
    emit(state.copyWith(
        pageCommand:
            NavigateToRouteWithArguments(route: Routes.editRegionEventNameAndDescription, arguments: state.event)));
  }

  Future<void> _onJoinRegionEventButtonPressed(
      OnJoinRegionEventButtonPressed event, Emitter<RegionEventDetailsState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final result = await JoinRegionEventUseCase().run(JoinRegionEventUseCase.input(
      eventId: state.event.id,
      joiningUser: settingsStorage.accountName,
    ));
    if (result.isError) {
      emit(state.copyWith(pageCommand: ShowErrorMessage('')));
    } else {
      emit(state.copyWith(pageState: PageState.success, isUserJoined: true));
    }
  }

  Future<void> _onLeaveRegionEventButtonPressed(
      OnLeaveRegionEventButtonPressed event, Emitter<RegionEventDetailsState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final result = await LeaveRegionEventUseCase().run(LeaveRegionEventUseCase.input(
      eventId: state.event.id,
      joiningUser: settingsStorage.accountName,
    ));
    if (result.isError) {
      emit(state.copyWith(pageCommand: ShowErrorMessage('')));
    } else {
      emit(state.copyWith(pageState: PageState.success, isUserJoined: false));
    }
  }
}
