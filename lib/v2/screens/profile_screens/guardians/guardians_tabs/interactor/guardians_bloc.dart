import 'package:bloc/bloc.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_status.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_type.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/mappers/init_guardians_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/usecases/get_guardians_usecase.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/usecases/init_guardians_usecase.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_events.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/guardians_state.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/guardians_tabs/interactor/viewmodels/page_commands.dart';

/// --- BLOC
class GuardiansBloc extends Bloc<GuardiansEvent, GuardiansState> {
  GuardiansBloc() : super(GuardiansState.initial());

  final GetGuardiansUseCase _userCase = GetGuardiansUseCase();
  final InitGuardiansUseCase _initGuardiansUseCase = InitGuardiansUseCase();
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
    } else if (event is InitGuardians) {
      if(event.myGuardians.length < 3) {
        print('guardiansQuery.docs.length >= 3 is true');
        // TODO(gguij002): SHow toast saying more than 3
        yield state;
      } else {
        yield state.copyWith(pageState: PageState.loading);

        var result = await _initGuardiansUseCase.initGuardians(event.myGuardians);

        yield InitGuardiansStateMapper().mapResultToState(state, result);

      }
    } else if (event is OnAddGuardiansTapped) {
      List<GuardianModel> results = await guardians.first;
      results.retainWhere((element) => element.type == GuardianType.myGuardian);

      yield state.copyWith(pageCommand: NavigateToSelectGuardians(results));
    }
  }
}
