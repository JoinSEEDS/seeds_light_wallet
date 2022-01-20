import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/base_use_case.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/flag/flag_user/flag_user/interactor/mappers/flag_user_state_mapper.dart';
import 'package:seeds/screens/explore_screens/flag/flag_user/flag_user/interactor/usecases/flag_user_usecase.dart';
import 'package:seeds/screens/explore_screens/vouch_for_a_member/interactor/mappers/vouch_for_a_member_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vouch_for_a_member/interactor/usecases/vouch_for_a_member_usecase.dart';
import 'package:seeds/screens/explore_screens/vouch_for_a_member/interactor/viewmodel/vouch_for_a_member_page_commands.dart';

part 'flag_user_event.dart';

part 'flag_user_state.dart';

class FlagUserBloc extends Bloc<FlagUserEvent, FlagUserState> {
  FlagUserBloc(List<MemberModel> alreadyVouched) : super(FlagUserState.initial(alreadyVouched)) {
    on<OnUserSelected>((event, emit) =>
        emit(state.copyWith(pageCommand: ShowVouchForMemberConfirmation(), selectedMember: event.user)));
    on<OnConfirmFlagUserTap>(_onConfirmFlagUserTap);
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _onConfirmFlagUserTap(OnConfirmFlagUserTap event, Emitter<FlagUserState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result<TransactionResponse> result = await FlagUserUseCase().run(state.selectedMember!.account);
    emit(FlagUserStateMapper().mapResultToState(state, result));
  }
}
