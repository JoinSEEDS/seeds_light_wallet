import 'package:bloc/bloc.dart';
import 'package:seeds/v2/components/dashboard/interactor/mappers/balance_state_mapper.dart';
import 'package:seeds/v2/components/dashboard/interactor/usecases/balance_update_use_case.dart';
import 'package:seeds/v2/components/dashboard/interactor/viewmodels/balance_event.dart';
import 'package:seeds/v2/components/dashboard/interactor/viewmodels/balance_state.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/models/token_model.dart';

/// --- BLOC
class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  final TokenModel token;

  BalanceBloc({required this.token}) : super(BalanceState.initial(token));

  @override
  Stream<BalanceState> mapEventToState(BalanceEvent event) async* {
    if (event is OnBalanceUpdate) {
      // TODO: Why is this not working?
      // if the yield is in there, it seems that we start loading again as soon as loading is done, 
      // then get stuck, on cards 2 and 3 - works fine on card 1. Has to do with the init sequence, and the 
      // initial update. But anyway not canceling out the existing result while loading is a better UX. So will
      // leave this out. Just want to know why it's not working. 
      // yield state.copyWith(pageState: PageState.loading); 
      var result = await BalanceUpdateUseCase().run(token);
      yield BalanceStateMapper().mapResultToState(state, result);
    } 
  }
}
