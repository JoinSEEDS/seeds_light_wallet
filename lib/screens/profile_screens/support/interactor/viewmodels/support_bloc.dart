import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/screens/profile_screens/support/interactor/mappers/support_data_state_mapper.dart';
import 'package:seeds/screens/profile_screens/support/interactor/usecases/get_support_data_usecase.dart';

part 'support_event.dart';

part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  SupportBloc() : super(SupportState.initial()) {
    on<LoadSupportData>(_loadSupportData);
  }

  Future<void> _loadSupportData(LoadSupportData event, Emitter<SupportState> emit) async {
    final SupportDto results = await GetSupportDataUseCase().run();
    emit(SupportDataStateMapper().mapResultToState(state, results));
  }
}
