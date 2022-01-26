import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/mapper/delegates_load_data_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/mapper/remove_delegate_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/usecase/delegates_load_data_usecase.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/usecase/remove_delegate_use_case.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/interactor/viewmodels/delegates_page_commands.dart';

part 'delegates_event.dart';

part 'delegates_state.dart';

class DelegatesBloc extends Bloc<DelegatesEvent, DelegatesState> {
  DelegatesBloc() : super(DelegatesState.initial()) {
    on<LoadDelegatesData>(_loadDelegatesData);
    on<InitOnboardingDelegate>(_initOnboardingDelegate);
    on<OnRemoveDelegateTapped>(_onRemoveDelegateTapped);
    on<RemoveDelegate>(_removeDelegate);
    on<ClearDelegatesPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _loadDelegatesData(LoadDelegatesData event, Emitter<DelegatesState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result? result = await DelegatesLoadDataUseCase().run();
    emit(DelegatesLoadDataStateMapper().mapResultToState(state, result));
  }

  void _initOnboardingDelegate(InitOnboardingDelegate event, Emitter<DelegatesState> emit) {
    emit(state.copyWith(pageCommand: ShowIntroducingDelegate()));
  }

  void _onRemoveDelegateTapped(OnRemoveDelegateTapped event, Emitter<DelegatesState> emit) {
    emit(state.copyWith(pageCommand: ShowDelegateRemovalConfirmation()));
  }

  Future<void> _removeDelegate(RemoveDelegate event, Emitter<DelegatesState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result result = await RemoveDelegateUseCase().run();
    emit(RemoveDelegateResultMapper().mapResultToState(state, result));
  }
}
