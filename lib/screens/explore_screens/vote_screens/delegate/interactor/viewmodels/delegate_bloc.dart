import 'package:bloc/bloc.dart';
import 'package:seeds/datasource/remote/model/delegate_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/mapper/delegate_load_data_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/mapper/remove_delegate_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/usecase/delegate_load_data_usecase.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/usecase/load_delegate_as_member_use_case.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/usecase/remove_delegate_use_case.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_event.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_page_commands.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_state.dart';

class DelegateBloc extends Bloc<DelegateEvent, DelegateState> {
  DelegateBloc() : super(DelegateState.initial());

  @override
  Stream<DelegateState> mapEventToState(DelegateEvent event) async* {
    if (event is LoadDelegateData) {
      yield state.copyWith(pageState: PageState.loading);
      final Result result = await DelegateLoadDataUseCase().run();

      if (!result.isError && result.asValue != null && result.asValue!.value is DelegateModel) {
        final DelegateModel delegate = result.asValue!.value;

        if (delegate.delegatee.isNotEmpty) {
          final Result memberResult = await LoadDelegateAsMemberUseCase().run(delegateAccount: delegate.delegatee);
          yield DelegateLoadDataStateMapper().mapResultToState(state, memberResult);
        } else {
          yield DelegateLoadDataStateMapper().mapResultToState(state, result);
        }
      }
    } else if (event is RemoveDelegateTap) {
      yield state.copyWith(pageCommand: ShowDelegateRemovalConfirmation());
    } else if (event is RemoveDelegate) {
      yield state.copyWith(pageState: PageState.loading);
      final Result result = await RemoveDelegateUseCase().run();
      yield RemoveDelegateResultMapper().mapResultToState(state, result);
    } else if (event is ShowOnboardingDelegate) {
      yield state.copyWith(pageCommand: ShowOnboardingDelegate());
    }
  }
}
