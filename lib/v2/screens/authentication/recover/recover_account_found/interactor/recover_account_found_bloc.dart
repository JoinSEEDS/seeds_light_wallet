import 'package:bloc/bloc.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_events.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_state.dart';

/// --- BLOC
class RecoverAccountFoundBloc extends Bloc<RecoverAccountFoundEvent, RecoverAccountFoundState> {
  RecoverAccountFoundBloc() : super(RecoverAccountFoundState.initial());

  @override
  Stream<RecoverAccountFoundState> mapEventToState(RecoverAccountFoundEvent event) async* {}
}
