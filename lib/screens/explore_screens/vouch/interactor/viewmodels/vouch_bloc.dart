import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

part 'vouch_event.dart';
part 'vouch_state.dart';

class VouchBloc extends Bloc<VouchEvent, VouchState> {
  VouchBloc() : super(VouchState.initial()) {
    on<LoadUserVouchList>(_loadUserVouchList);
    on<OnRemoveVouchButtonTapped>(_onRemoveVouchButtonTapped);
  }

  //To be finish on next pr
  Future<void> _loadUserVouchList(LoadUserVouchList event, Emitter<VouchState> emit) async {
    emit(state.copyWith(pageState: PageState.success));
  }

  //To be finish on next pr
  Future<void> _onRemoveVouchButtonTapped(OnRemoveVouchButtonTapped event, Emitter<VouchState> emit) async {
    emit(state.copyWith(pageState: PageState.success));
  }
}
