import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/mappers/vouched_initial_data_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/usecases/get_vouched_initial_data_use_case.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/viewmodels/vouched_page_commands.dart';

part 'vouched_event.dart';

part 'vouched_state.dart';

class VouchedBloc extends Bloc<VouchedEvent, VouchedState> {
  VouchedBloc() : super(VouchedState.initial()) {
    on<LoadUserVouchedList>(_loadUserVouchedList);
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _loadUserVouchedList(LoadUserVouchedList event, Emitter<VouchedState> emit) async {
    if (event.showVouchForMemberSuccess) {
      emit(state.copyWith(pageState: PageState.loading, pageCommand: ShowVouchForMemberSuccess()));
    }

    emit(state.copyWith(pageState: PageState.loading));
    final Result<VouchedDto> result = await GetVouchedInitialDataUseCase().run();
    emit(VouchedInitialDataStateMapper().mapResultToState(state, result));
  }
}
