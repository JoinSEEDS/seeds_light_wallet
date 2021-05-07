import 'package:bloc/bloc.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/interactor/viewmodels/guardians_events.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/interactor/viewmodels/guardians_state.dart';

/// --- BLOC
class GuardiansBloc extends Bloc<GuardiansEvent, GuardiansState> {
  GuardiansBloc() : super(GuardiansState.initial());

  @override
  Stream<GuardiansState> mapEventToState(GuardiansEvent event) async* {
    if (event is LoadGuardians) {
      // TODO(gguij002): make calls to load guardians from service
    }
  }
}
