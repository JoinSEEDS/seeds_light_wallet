import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/guardians/select_guardian/interactor/viewmodels/page_commands.dart';

part 'select_guardians_event.dart';
part 'select_guardians_state.dart';

class SelectGuardiansBloc extends Bloc<SelectGuardiansEvent, SelectGuardiansState> {
  SelectGuardiansBloc(List<GuardianModel> myGuardians) : super(SelectGuardiansState.initial(myGuardians)) {
    on<OnUserSelected>(_onUserSelected);
    on<OnUserRemoved>(_onUserRemoved);
    on<ClearPageCommand>((_, emit) => emit(state.copyWith()));
  }

  void _onUserSelected(OnUserSelected event, Emitter<SelectGuardiansState> emit) {
    if (state.myGuardians.length + state.selectedGuardians.length >= maxGuardiansAllowed) {
      emit(state.copyWith(pageCommand: ShowMaxUserCountSelected("Max Guardians number selected")));
    } else {
      final mutableSet = <ProfileModel>{};
      mutableSet.addAll(state.selectedGuardians);
      mutableSet.add(event.user);
      emit(state.copyWith(selectedGuardians: mutableSet));
    }
  }

  void _onUserRemoved(OnUserRemoved event, Emitter<SelectGuardiansState> emit) {
    final mutableSet = <ProfileModel>{};
    mutableSet.addAll(state.selectedGuardians);
    mutableSet.remove(event.user);
    emit(state.copyWith(selectedGuardians: mutableSet));
  }
}
