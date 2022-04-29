import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/datasource/remote/model/region_member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_region_use_case.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/interactor/usecases/join_region_event_use_case.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/interactor/usecases/leave_region_event_use_case.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/interactor/viewmodels/page_commands.dart';

part 'region_event_details_event.dart';

part 'region_event_details_state.dart';

class RegionEventDetailsBloc extends Bloc<RegionEventDetailsEvent, RegionEventDetailsState> {
  RegionEventDetailsBloc(RegionEventModel event) : super(RegionEventDetailsState.initial(event)) {
    on<OnRegionEventDetailsMounted>(_onRegionEventDetailsMounted);
    on<OnRegionMapsLinkTapped>((_, emit) => emit(state.copyWith(pageCommand: LaunchRegionMapsLocation())));
    on<OnJoinRegionEventButtonPressed>(_onJoinRegionEventButtonPressed);
    on<OnLeaveRegionEventButtonPressed>(_onLeaveRegionEventButtonPressed);
    on<OnEditRegionEventButtonTapped>((_, emit) => emit(state.copyWith(pageCommand: ShowEditRegionEventButtons())));
    on<OnEditEventImageTapped>((_, emit) => emit(state.copyWith()));
    on<OnEditEventNameAndDescriptionTapped>(_onEditEventNameAndDescriptionTapped);
    on<OnEditEventDateAndTimeTapped>(_onEditEventDateAndTimeTapped);
    on<OnEditEventLocationTapped>(_onEditEventLocationTapped);
    on<OnDeleteEventTapped>((_, emit) => emit(state.copyWith()));
    on<ClearRegionEventPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _onRegionEventDetailsMounted(
      OnRegionEventDetailsMounted event, Emitter<RegionEventDetailsState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    // Check if user has joined this Region
    final result = await GetRegionUseCase().run(settingsStorage.accountName);
    if (result.isError) {
      emit(state.copyWith(pageState: PageState.failure));
    } else {
      final RegionMemberModel? member = result.asValue?.value;
      // If the member is null or if the id does not correspond to this region (very rare case)
      // then it could not join the event (The join button is disabled.
      final bool isBrowseView = member == null || member.region != state.event.regionAccount;
      emit(state.copyWith(pageState: PageState.success, isBrowseView: isBrowseView));
    }
  }

  void _onEditEventNameAndDescriptionTapped(
      OnEditEventNameAndDescriptionTapped event, Emitter<RegionEventDetailsState> emit) {
    emit(state.copyWith(
        pageCommand:
            NavigateToRouteWithArguments(route: Routes.editRegionEventNameAndDescription, arguments: state.event)));
  }

  void _onEditEventDateAndTimeTapped(OnEditEventDateAndTimeTapped event, Emitter<RegionEventDetailsState> emit) {
    emit(state.copyWith(
        pageCommand: NavigateToRouteWithArguments(route: Routes.editRegionEventTimeAndDate, arguments: state.event)));
  }

  void _onEditEventLocationTapped(OnEditEventLocationTapped event, Emitter<RegionEventDetailsState> emit) {
    emit(state.copyWith(
        pageCommand: NavigateToRouteWithArguments(route: Routes.editRegionEventLocation, arguments: state.event)));
  }

  Future<void> _onJoinRegionEventButtonPressed(
      OnJoinRegionEventButtonPressed event, Emitter<RegionEventDetailsState> emit) async {
    emit(state.copyWith(isJoinLeaveButtonLoading: true));
    final result = await JoinRegionEventUseCase().run(JoinRegionEventUseCase.input(
      eventId: state.event.id,
      joiningUser: settingsStorage.accountName,
    ));
    if (result.isError) {
      emit(state.copyWith(isJoinLeaveButtonLoading: false, pageCommand: ShowErrorMessage('')));
    } else {
      emit(state.copyWith(isJoinLeaveButtonLoading: false, isUserJoined: true));
    }
  }

  Future<void> _onLeaveRegionEventButtonPressed(
      OnLeaveRegionEventButtonPressed event, Emitter<RegionEventDetailsState> emit) async {
    emit(state.copyWith(isJoinLeaveButtonLoading: true));
    final result = await LeaveRegionEventUseCase().run(LeaveRegionEventUseCase.input(
      eventId: state.event.id,
      joiningUser: settingsStorage.accountName,
    ));
    if (result.isError) {
      emit(state.copyWith(isJoinLeaveButtonLoading: false, pageCommand: ShowErrorMessage('')));
    } else {
      emit(state.copyWith(isJoinLeaveButtonLoading: false, isUserJoined: false));
    }
  }
}
