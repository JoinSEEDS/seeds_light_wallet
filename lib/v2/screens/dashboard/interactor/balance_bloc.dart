import 'package:bloc/bloc.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/dashboard/interactor/mappers/balance_state_mapper.dart';
import 'package:seeds/v2/screens/dashboard/interactor/usecases/load_balance_use_case.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/balance_event.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/balance_state.dart';

/// --- BLOC
class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  final TokenModel token;

  BalanceBloc({required this.token}) : super(BalanceState.initial(token));

  @override
  Stream<BalanceState> mapEventToState(BalanceEvent event) async* {
    if (event is OnLoadBalance) {
      yield state.copyWith(pageState: PageState.loading); 
      var result = await LoadBalanceUseCase().run(token);
      yield BalanceStateMapper().mapResultToState(state, result);
    } 
  }
}
