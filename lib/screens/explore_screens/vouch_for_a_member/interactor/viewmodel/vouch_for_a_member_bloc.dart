import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vouch_for_a_member/interactor/viewmodel/vouch_for_a_member_page_commands.dart';

part 'vouch_for_a_member_event.dart';

part 'vouch_for_a_member_state.dart';

class VouchForAMemberBloc extends Bloc<VouchForAMemberEvent, VouchForAMemberState> {
  VouchForAMemberBloc() : super(VouchForAMemberState.initial()) {
    on<OnUserSelected>((event, emit) => emit(state.copyWith(pageCommand: ShowVouchForMemberConfirmation(event.user))));
    on<OnConfirmVouchForMemberTap>(_onConfirmVouchForMemberTap);
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }

  //To be finish on next pr
  Future<void> _onConfirmVouchForMemberTap(OnConfirmVouchForMemberTap event, Emitter<VouchForAMemberState> emit) async {
    emit(state.copyWith(pageState: PageState.success, pageCommand: ShowVouchForMemberSuccess()));
  }
}
