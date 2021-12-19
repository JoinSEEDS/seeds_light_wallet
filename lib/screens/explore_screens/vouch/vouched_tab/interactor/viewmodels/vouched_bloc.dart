import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

part 'vouched_event.dart';

part 'vouched_state.dart';

class VouchedBloc extends Bloc<VouchedEvent, VouchedState> {
  VouchedBloc() : super(VouchedState.initial()) {
    on<LoadUserVouchedList>(_loadUserVouchedList);
  }

  //To be finish on next pr
  Future<void> _loadUserVouchedList(LoadUserVouchedList event, Emitter<VouchedState> emit) async {
    emit(state.copyWith(pageState: PageState.success));
  }
}
