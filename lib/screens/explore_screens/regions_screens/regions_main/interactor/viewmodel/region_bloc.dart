import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_message_model.dart';
import 'package:seeds/datasource/remote/model/region_member_model.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_region_use_case.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/usecases/leave_region_use_case.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/mappers/set_region_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/usecases/get_firebase_region_by_id_use_case.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/usecases/get_region_by_id_use_case.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/usecases/join_region_use_case.dart';

part 'region_event.dart';

part 'region_state.dart';

class RegionBloc extends Bloc<RegionEvent, RegionState> {
  final FirebaseDatabaseRegionsRepository _firebaseRepository = FirebaseDatabaseRegionsRepository();

  RegionBloc(RegionModel? region) : super(RegionState.initial(region)) {
    on<OnRegionMounted>(_onRegionMounted);
    on<OnJoinRegionButtonPressed>(_onJoinRegionButtonPressed);
    on<OnLeaveRegionButtonPressed>(_onLeaveRegionButtonPressed);
    on<OnEditRegionDescriptionButtonPressed>(_onEditRegionDescriptionButtonPressed);
    on<ClearRegionPageCommand>((_, emit) => emit(state.copyWith()));
  }

  void _onEditRegionDescriptionButtonPressed(OnEditRegionDescriptionButtonPressed event, Emitter<RegionState> emit) {
    emit(state.copyWith(
        pageCommand: NavigateToRouteWithArguments(
      route: Routes.editRegionDescription,
      arguments: state.region,
    )));
  }

  Stream<List<RegionMessageModel>> get regionMessages => _firebaseRepository.getMessagesForRegion(state.region!.id);

  Stream<List<RegionEventModel>> get regionEvents => _firebaseRepository.getEventsForRegion(state.region!.id);

  Future<void> _onRegionMounted(OnRegionMounted event, Emitter<RegionState> emit) async {
    if (state.region == null) {
      // Not initial region --> region full view
      emit(state.copyWith(pageState: PageState.loading));
      // Check if user has joined a Region
      final result = await GetRegionUseCase().run(settingsStorage.accountName);
      if (result.isError) {
        emit(state.copyWith(pageState: PageState.failure));
      } else {
        if (result.asValue!.value == null) {
          // User has not joined a Region (unexpected case) go back to join regions.
          emit(state.copyWith(pageCommand: NavigateToRoute(Routes.joinRegion)));
        } else {
          // User has joined a Region fetch chan region and firebase region.
          final RegionMemberModel member = result.asValue!.value!;
          final results = await Future.wait([
            GetRegionByIdUseCase().run(member.region),
            GetFirebaseRegionByIdUseCase().run(member.region),
          ]);
          emit(SetRegionStateMapper().mapResultToState(state, results));
        }
      }
    } else {
      emit(state.copyWith(pageState: PageState.success));
    }
  }

  Future<void> _onJoinRegionButtonPressed(OnJoinRegionButtonPressed event, Emitter<RegionState> emit) async {
    // lauch confirm dialog after confirm execute this code below
    emit(state.copyWith(pageState: PageState.loading));
    final result = await JoinRegionUseCase()
        .run(JoinRegionUseCase.input(regionId: state.region!.id, userAccount: settingsStorage.accountName));
    if (result.isError) {
      emit(state.copyWith(pageState: PageState.failure));
    } else {
      // Success replace all routes and push region screen
      emit(state.copyWith(pageCommand: NavigateToRoute(Routes.region)));
    }
  }

  Future<void> _onLeaveRegionButtonPressed(OnLeaveRegionButtonPressed event, Emitter<RegionState> emit) async {
    // lauch confirm dialog after confirm execute this code below
    emit(state.copyWith(pageState: PageState.loading));
    final result = await LeaveRegionUseCase()
        .run(LeaveRegionUseCase.input(regionId: state.region!.id, userAccount: settingsStorage.accountName));
    if (result.isError) {
      emit(state.copyWith(pageState: PageState.failure));
    } else {
      // Success return user to join region screen
      emit(state.copyWith(pageCommand: NavigateToRoute(Routes.joinRegion)));
    }
  }
}
