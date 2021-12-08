import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/mappers/update_profile_state_mapper.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/usecases/update_profile_use_case.dart';

part 'edit_name_event.dart';
part 'edit_name_state.dart';

class EditNameBloc extends Bloc<EditNameEvent, EditNameState> {
  EditNameBloc() : super(EditNameState.initial()) {
    on<OnNameChanged>((event, emit) => emit(state.copyWith(name: event.name)));
    on<SubmitName>(_submitName);
  }

  Future<void> _submitName(SubmitName event, Emitter<EditNameState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final result = await UpdateProfileUseCase().run(newName: state.name, profile: event.profile!);
    emit(UpdateProfileStateMapper().mapResultToState(state, result));
  }
}
