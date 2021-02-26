import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore/interactor/usecases/get_explore_page_data_use_case.dart';
import 'package:seeds/v2/screens/explore/interactor/viewmodels/explore_events.dart';
import 'package:seeds/v2/screens/import_key/interactor/mappers/import_key_state_mapper.dart';
import 'package:seeds/v2/screens/import_key/interactor/viewmodels/import_key_events.dart';
import 'package:seeds/v2/screens/import_key/interactor/viewmodels/import_key_state.dart';

/// --- BLOC
class ImportKeyBloc extends Bloc<ImportKeyEvent, ImportKeyState> {
  ImportKeyBloc() : super(ImportKeyState.initial());

  @override
  Stream<ImportKeyState> mapEventToState(ImportKeyEvent event) async* {
    if (event is LoadExplore) {
      yield state.copyWith(pageState: PageState.loading);

      var results = await GetExploreUseCase().run(event.toString());

      yield ImportKeyStateMapper().mapResultsToState(state, results);
    }
  }
}
