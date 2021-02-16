import 'package:bloc/bloc.dart';
import 'package:seeds/v2/screens/settings/edit_name/viewmodels/edit_name_event.dart';
import 'package:seeds/v2/screens/settings/edit_name/viewmodels/edit_name_state.dart';

/// --- BLOC
class EditNameBloc extends Bloc<EditNameEvent, EditNameState> {
  EditNameBloc() : super(EditNameState.initial());

  @override
  Stream<EditNameState> mapEventToState(EditNameEvent event) async* {
    if (event is OnNameChanged) {
      yield state.copyWith(name: event.name);
    }
  }
}
