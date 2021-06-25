import 'package:bloc/bloc.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/dashboard/interactor/mappers/available_tokens_state_mapper%20copy.dart';
import 'package:seeds/v2/screens/dashboard/interactor/usecases/load_available_tokens_use_case.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/available_tokens_event.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/available_tokens_state.dart';

/// --- BLOC
class AvailableTokensBloc extends Bloc<AvailableTokensEvent, AvailableTokensState> {

  AvailableTokensBloc() : super(AvailableTokensState.initial());

  @override
  Stream<AvailableTokensState> mapEventToState(AvailableTokensEvent event) async* {
    if (event is OnLoadAvailableTokens) {
      yield state.copyWith(pageState: PageState.loading); 
      
      const potentialTokens = [SeedsToken, HusdToken, HyphaToken, LocalScaleToken];

      var result = await LoadAvailableTokensUseCase().run(potentialTokens);
      
      yield AvailableTokensStateMapper().mapResultToState(state, potentialTokens, result);
    } 
  }
}
