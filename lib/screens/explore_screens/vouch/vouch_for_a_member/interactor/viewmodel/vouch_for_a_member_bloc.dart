import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vouch/vouch_for_a_member/interactor/mappers/vouch_for_a_member_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vouch/vouch_for_a_member/interactor/usecases/vouch_for_a_member_usecase.dart';
import 'package:seeds/screens/explore_screens/vouch/vouch_for_a_member/interactor/viewmodel/vouch_for_a_member_page_commands.dart';

part 'vouch_for_a_member_event.dart';

part 'vouch_for_a_member_state.dart';

class VouchForAMemberBloc extends Bloc<VouchForAMemberEvent, VouchForAMemberState> {
  VouchForAMemberBloc(List<ProfileModel> alreadyVouched) : super(VouchForAMemberState.initial(alreadyVouched)) {
    on<OnUserSelected>((event, emit) =>
        emit(state.copyWith(pageCommand: ShowVouchForMemberConfirmation(), selectedMember: event.user)));
    on<OnConfirmVouchForMemberTap>(_onConfirmVouchForMemberTap);
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _onConfirmVouchForMemberTap(OnConfirmVouchForMemberTap event, Emitter<VouchForAMemberState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result<TransactionResponse> result = await VouchForAMemberUseCase().run(state.selectedMember!.account);
    emit(VouchForAMemberStateMapper().mapResultToState(state, result));
  }
}
