import 'package:bloc/bloc.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/interactor/usecases/get_guardians_usecase.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/interactor/viewmodels/guardians_events.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/interactor/viewmodels/guardians_state.dart';

/// --- BLOC
class GuardiansBloc extends Bloc<GuardiansEvent, GuardiansState> {
  GuardiansBloc() : super(GuardiansState.initial());

  final GetGuardiansUseCase _userCase = GetGuardiansUseCase();
  final FirebaseDatabaseGuardiansRepository _repository = FirebaseDatabaseGuardiansRepository();

  Stream<List<GuardianModel>> get guardians {
    return _userCase.getGuardians();
  }

  Stream<bool> get isGuardianContractInitialized {
    return _repository.isGuardiansInitialized(settingsStorage.accountName);
  }

  @override
  Stream<GuardiansState> mapEventToState(GuardiansEvent event) async* {
    if (event is LoadGuardians) {
      // TODO(gguij002): make calls to load guardians from service
    }
  }
}
