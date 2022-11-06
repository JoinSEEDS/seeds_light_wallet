import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_available_balance_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_region_use_case.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/mappers/create_region_balance_result_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/usecases/get_region_fee_use_case.dart';

part 'join_region_event.dart';
part 'join_region_state.dart';

class JoinRegionBloc extends Bloc<JoinRegionEvent, JoinRegionState> {
  JoinRegionBloc() : super(JoinRegionState.initial()) {
    on<OnJoinRegionMounted>(_onJoinRegionMounted);
    on<OnRegionsResultsChanged>((event, emit) => emit(state.copyWith(isRegionsResultsEmpty: event.isEmpty)));
    on<OnCreateRegionTapped>(_onCreateRegionTapped);
    on<OnCreateRegionNextTapped>(_onCreateRegionNextTapped);
    on<ClearJoinRegionPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _onJoinRegionMounted(OnJoinRegionMounted event, Emitter<JoinRegionState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    // Check if user has joined a Region
    final result = await GetRegionUseCase().run(settingsStorage.accountName);
    if (result.isError) {
      emit(state.copyWith(pageState: PageState.failure));
    } else {
      if (result.asValue!.value == null) {
        // User has not joined a Region
        emit(state.copyWith(pageState: PageState.success));
      } else {
        // User has joined a Region
        emit(state.copyWith(pageCommand: NavigateToRoute(Routes.region)));
      }
    }
  }

  Future<void> _onCreateRegionTapped(OnCreateRegionTapped event, Emitter<JoinRegionState> emit) async {
    emit(state.copyWith(isCreateRegionButtonLoading: true));
    final balanceResult = await GetAvailableBalanceUseCase().run(TokenModel.fromId(seedsToken.id));
    final regionFeeResult = await GetRegionFeeUseCase().run();
    emit(CreateRegionBalanceResultStateMapper().mapResultToState(state, balanceResult, regionFeeResult));
  }

  void _onCreateRegionNextTapped(OnCreateRegionNextTapped event, Emitter<JoinRegionState> emit) {
    emit(state.copyWith(pageCommand: NavigateToRoute(Routes.createRegion)));
  }
}
