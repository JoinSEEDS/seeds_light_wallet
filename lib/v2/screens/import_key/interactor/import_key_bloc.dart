import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/import_key/interactor/mappers/import_key_state_mapper.dart';
import 'package:seeds/v2/screens/import_key/interactor/usecases/check_private_key_use_case.dart';
import 'package:seeds/v2/screens/import_key/interactor/usecases/import_key_use_case.dart';
import 'package:seeds/v2/screens/import_key/interactor/viewmodels/import_key_events.dart';
import 'package:seeds/v2/screens/import_key/interactor/viewmodels/import_key_state.dart';

/// --- BLOC
class ImportKeyBloc extends Bloc<ImportKeyEvent, ImportKeyState> {
  ImportKeyBloc() : super(ImportKeyState.initial());

  @override
  Stream<ImportKeyState> mapEventToState(ImportKeyEvent event) async* {
    if (event is FindAccountByKey) {
      yield state.copyWith(pageState: PageState.loading);

      var publicKey = CheckPrivateKeyUseCase().isKeyValid(event.userKey);

      if (publicKey == null || publicKey.isEmpty) {
        yield state.copyWith(pageState: PageState.failure, errorMessage: "Private key is not valid");
      } else {
        var results = await ImportKeyUseCase().run(event.userKey);
        yield ImportKeyStateMapper().mapResultsToState(state, results);
      }
    }
  }
}
