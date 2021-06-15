import 'package:bloc/bloc.dart';
import 'package:seeds/v2/screens/transfer/send/send_search_user/interactor/viewmodels/send_search_user_events.dart';
import 'package:seeds/v2/screens/transfer/send/send_search_user/interactor/viewmodels/send_search_user_state.dart';

/// --- BLOC
class SendSearchUserPageBloc extends Bloc<SendSearchUserPageEvent, SendSearchUserPageState> {
  SendSearchUserPageBloc() : super(SendSearchUserPageState.initial());

  @override
  Stream<SendSearchUserPageState> mapEventToState(SendSearchUserPageEvent event) async* {}
}
