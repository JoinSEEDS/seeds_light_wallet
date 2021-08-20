import 'package:bloc/bloc.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/mappers/update_profile_state_mapper.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/usecases/update_profile_use_case.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/viewmodels/bloc.dart';

/// --- BLOC
class EditNameBloc extends Bloc<EditNameEvent, EditNameState> {
  EditNameBloc() : super(EditNameState.initial());

  @override
  Stream<EditNameState> mapEventToState(EditNameEvent event) async* {
    if (event is OnNameChanged) {
      yield state.copyWith(name: event.name);
    }
    if (event is SubmitName) {
      yield state.copyWith(pageState: PageState.loading);
      final result = await UpdateProfileUseCase().run(newName: state.name, profile: event.profile!);

      yield UpdateProfileStateMapper().mapResultToState(state, result);
    }
  }
}
