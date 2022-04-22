import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/interactor/viewmodels/page_commands.dart';

part 'region_event_details_event.dart';

part 'region_event_details_state.dart';

class RegionEventDetailsBloc extends Bloc<RegionEventDetailsEvent, RegionEventDetailsState> {
  RegionEventDetailsBloc() : super(RegionEventDetailsState.initial()) {
    on<OnRegionMapsLinkTapped>((_, emit) => emit(state.copyWith(pageCommand: LaunchRegionMapsLocation())));
    on<OnEditRegionEventButtonTapped>((_, emit) => emit(state.copyWith(pageCommand: ShowEditRegionEventButtons())));
    on<OnEditEventImageTapped>((_, emit) => emit(state.copyWith()));
    on<OnEditEventNameAndDescriptionTapped>((_, emit) => emit(state.copyWith()));
    on<OnEditEventDateAndTimeTapped>((_, emit) => emit(state.copyWith()));
    on<OnEditEventLocationTapped>((_, emit) => emit(state.copyWith()));
    on<OnDeleteEventTapped>((_, emit) => emit(state.copyWith()));
    on<ClearRegionEventPageCommand>((_, emit) => emit(state.copyWith()));
  }
}
