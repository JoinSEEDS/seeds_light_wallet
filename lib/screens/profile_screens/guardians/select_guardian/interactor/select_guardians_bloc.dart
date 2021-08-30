import 'package:bloc/bloc.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/select_guardians_events.dart';
import 'package:seeds/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/select_guardians_state.dart';

class SelectGuardiansBloc extends Bloc<SelectGuardiansEvent, SelectGuardiansState> {
  SelectGuardiansBloc(List<GuardianModel> myGuardians) : super(SelectGuardiansState.initial(myGuardians));

  @override
  Stream<SelectGuardiansState> mapEventToState(SelectGuardiansEvent event) async* {
    if (event is OnUserSelected) {
      if (state.myGuardians.length + state.selectedGuardians.length >= MAX_GUARDIANS_ALLOWED) {
        yield state.copyWith(pageCommand: ShowMaxUserCountSelected("Max Guardians number selected"));
      } else {
        final mutableSet = <MemberModel>{};

        mutableSet.addAll(state.selectedGuardians);
        mutableSet.add(event.user);

        yield state.copyWith(selectedGuardians: mutableSet);
      }
    } else if (event is OnUserRemoved) {
      final mutableSet = <MemberModel>{};
      mutableSet.addAll(state.selectedGuardians);
      mutableSet.remove(event.user);

      yield state.copyWith(selectedGuardians: mutableSet);
    } else if (event is ClearPageCommand) {
      yield state.copyWith();
    }
  }
}
