import 'package:bloc/bloc.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/viewmodels/send_enter_data_events.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/viewmodels/send_enter_data_state.dart';

/// --- BLOC
class SendEnterDataPageBloc extends Bloc<SendEnterDataPageEvent, SendEnterDataPageState> {
  SendEnterDataPageBloc() : super(SendEnterDataPageState.initial());

  @override
  Stream<SendEnterDataPageState> mapEventToState(SendEnterDataPageEvent event) async* {}
}
