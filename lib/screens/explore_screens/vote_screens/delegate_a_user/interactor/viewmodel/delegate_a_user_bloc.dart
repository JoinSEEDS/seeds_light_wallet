import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/mappers/delegate_a_user_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/usecases/delegate_a_user_use_case.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_page_commands.dart';

part 'delegate_a_user_event.dart';
part 'delegate_a_user_state.dart';

class DelegateAUserBloc extends Bloc<DelegateAUserEvent, DelegateAUserState> {
  DelegateAUserBloc() : super(DelegateAUserState.initial()) {
    on<OnUserSelected>((event, emit) => emit(state.copyWith(pageCommand: ShowDelegateConfirmation(event.user))));
    on<OnConfirmDelegateTab>(_onConfirmDelegateTab);
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _onConfirmDelegateTab(OnConfirmDelegateTab event, Emitter<DelegateAUserState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result result = await DelegateAUserUseCase().run(delegateTo: event.user.account);
    emit(DelegateAUserResultMapper().mapResultToState(state, result));
  }
}
