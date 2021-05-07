import 'package:bloc/bloc.dart';
import 'package:seeds/v2/screens/receive/interactor/viewmodels/receive_events.dart';
import 'package:seeds/v2/screens/receive/interactor/viewmodels/receive_state.dart';

/// --- BLOC
class ReceiveBloc extends Bloc<ReceiveEvent, ReceiveState> {
  ReceiveBloc() : super(ReceiveState.initial());

  @override
  Stream<ReceiveState> mapEventToState(ReceiveEvent event) async* {
    if (event is TabInputSeedsCard) {
      yield state.copyWith(receiveStates: ReceiveStates.navigateToInputSeeds);
    } else if (event is TabMerchantCard) {
      yield state.copyWith(receiveStates: ReceiveStates.navigateToMerchant);
    } else if(event is ClearState){
      yield state.copyWith(receiveStates: null);
    }
  }
}
