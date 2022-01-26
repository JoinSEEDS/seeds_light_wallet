import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/mappers/load_vouched_list_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/usecases/load_vouched_list_use_case.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/interactor/viewmodels/vouched_page_commands.dart';

part 'vouched_event.dart';

part 'vouched_state.dart';

class VouchedBloc extends Bloc<VouchedEvent, VouchedState> {
  VouchedBloc() : super(VouchedState.initial(settingsStorage.isVisitor)) {
    on<LoadUserVouchedList>(_loadUserVouchedList);
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _loadUserVouchedList(LoadUserVouchedList event, Emitter<VouchedState> emit) async {
    if (!state.canVouch) {
      emit(state.copyWith(pageState: PageState.success, pageCommand: ShowNotQualifiedToVouch()));
    } else {
      event.showVouchForMemberSuccess
          ? emit(state.copyWith(pageState: PageState.loading, pageCommand: ShowVouchForMemberSuccess()))
          : emit(state.copyWith(pageState: PageState.loading));

      final Result<List<ProfileModel>> results = await LoadVouchedListUseCase().run();
      emit(LoadVouchedListStateMapper().mapResultToState(state, results));
    }
  }
}
