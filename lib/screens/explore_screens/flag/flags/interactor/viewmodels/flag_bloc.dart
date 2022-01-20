import 'dart:async';

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/transaction_response.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/flag/flags/interactor/mappers/flagged_users_state_mapper.dart';
import 'package:seeds/screens/explore_screens/flag/flags/interactor/mappers/remove_flag_state_mapper.dart';
import 'package:seeds/screens/explore_screens/flag/flags/interactor/usecases/get_flagged_users_use_case.dart';
import 'package:seeds/screens/explore_screens/flag/flags/interactor/usecases/remove_user_flag_use_case.dart';

part 'flag_event.dart';

part 'flag_state.dart';

class FlagBloc extends Bloc<FlagEvent, FlagState> {
  FlagBloc() : super(FlagState.initial()) {
    on<LoadUsersFlags>(_loadUsersFlags);
    on<OnRemoveUserFlagTapped>(_removeUserFlag);
  }

  FutureOr<void> _loadUsersFlags(event, Emitter<FlagState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result<List<ProfileModel>> result = await GetFlaggedUsersUseCase().run();
    emit(FlaggedUsersStateMapper().mapResultToState(state, result));
  }

  FutureOr<void> _removeUserFlag(OnRemoveUserFlagTapped event, Emitter<FlagState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result<TransactionResponse> result = await RemoveUserFlagUseCase().run(event.userAccount);
    emit(RemoveFlagStateMapper().mapResultToState(state, result, event.userAccount));
  }
}
