import 'package:bloc/bloc.dart';
import 'package:seeds/v2/screens/authentication/recover_account/interactor/viewmodels/recover_account_events.dart';
import 'package:seeds/v2/screens/authentication/recover_account/interactor/viewmodels/recover_account_state.dart';

/// --- BLOC
class RecoverAccountBloc extends Bloc<RecoverAccountEvent, RecoverAccountState> {
  RecoverAccountBloc() : super(RecoverAccountState.initial());

  @override
  Stream<RecoverAccountState> mapEventToState(RecoverAccountEvent event) async* {
    if (event is OnUsernameChanged) {
      print("OnUsernameChanged " + event.userName);
    }
  }
}
