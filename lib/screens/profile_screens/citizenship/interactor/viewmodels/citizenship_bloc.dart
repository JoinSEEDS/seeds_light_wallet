import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/score_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/citizenship/interactor/mappers/set_values_mapper.dart';
import 'package:seeds/screens/profile_screens/citizenship/interactor/usecases/get_citizenship_data_use_case.dart';
import 'package:seeds/screens/profile_screens/citizenship/interactor/usecases/get_referred_accounts_use_case.dart';

part 'citizenship_event.dart';
part 'citizenship_state.dart';

class CitizenshipBloc extends Bloc<CitizenshipEvent, CitizenshipState> {
  CitizenshipBloc() : super(CitizenshipState.initial()) {
    on<SetValues>(_setValues);
  }

  Future<void> _setValues(SetValues event, Emitter<CitizenshipState> emit) async {
    if (event.profile == null) {
      emit(state.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page'));
    } else {
      emit(state.copyWith(pageState: PageState.loading, profile: event.profile));
      final referredAccountResults = await GetReferredAccountsUseCase().run();
      final citizenshipDataResults = await GetCitizenshipDataUseCase().run();
      emit(SetValuesStateMapper().mapResultToState(state, referredAccountResults, citizenshipDataResults));
    }
  }
}
