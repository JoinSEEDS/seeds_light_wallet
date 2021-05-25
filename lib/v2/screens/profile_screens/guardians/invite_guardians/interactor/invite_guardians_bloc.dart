import 'package:bloc/bloc.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/invite_guardians/interactor/viewmodel/invite_guardians_events.dart';
import 'package:seeds/v2/screens/profile_screens/guardians/invite_guardians/interactor/viewmodel/invite_guardians_state.dart';

class InviteGuardiansBloc extends Bloc<InviteGuardiansEvent, InviteGuardiansState> {
  InviteGuardiansBloc(Set<MemberModel> myGuardians) : super(InviteGuardiansState.initial(myGuardians));

  @override
  Stream<InviteGuardiansState> mapEventToState(InviteGuardiansEvent event) async* {}
}
