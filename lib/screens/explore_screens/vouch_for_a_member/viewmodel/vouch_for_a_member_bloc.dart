import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

part 'vouch_for_a_member_event.dart';

part 'vouch_for_a_member_state.dart';

class VouchForAMemberBloc extends Bloc<VouchForAMemberEvent, VouchForAMemberState> {
  VouchForAMemberBloc() : super(VouchForAMemberState.initial()) {
    //To be finish on next pr
    on<OnUserSelected>((event, emit) => emit(state.copyWith()));
    on<OnConfirmVouchForMemberTab>(_onConfirmDelegateTab);
  }

  //To be finish on next pr
  Future<void> _onConfirmDelegateTab(OnConfirmVouchForMemberTab event, Emitter<VouchForAMemberState> emit) async {
    emit(state.copyWith(pageState: PageState.success));
  }
}
