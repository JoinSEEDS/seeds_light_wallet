import 'package:bloc/bloc.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/viewmodels/unplant_seeds_event.dart';
import 'package:seeds/screens/explore_screens/unplant_seeds/interactor/viewmodels/unplant_seeds_state.dart';

class UnplantSeedsBloc extends Bloc<UnplantSeedsEvent, UnplantSeedsState> {
  UnplantSeedsBloc(RatesState rates) : super(UnplantSeedsState.initial(rates));

  @override
  Stream<UnplantSeedsState> mapEventToState(UnplantSeedsEvent event) async* {}
}
