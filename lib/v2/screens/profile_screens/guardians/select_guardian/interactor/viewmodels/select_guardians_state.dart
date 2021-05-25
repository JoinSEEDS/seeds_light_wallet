import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

const MAX_GUARDIANS_ALLOWED = 5;

class SelectGuardiansState extends Equatable {
  final PageState pageState;
  final Set<MemberModel> selectedGuardians;
  final String pageTitle;
  final List<GuardianModel> myGuardians;
  final PageCommand? pageCommand;

  const SelectGuardiansState(
      {required this.pageState,
      required this.selectedGuardians,
      required this.pageTitle,
      required this.myGuardians,
      this.pageCommand});

  @override
  List<Object?> get props => [
        pageState,
        selectedGuardians,
        pageTitle,
        pageCommand,
      ];

  SelectGuardiansState copyWith({
    PageState? pageState,
    Set<MemberModel>? selectedGuardians,
    String? pageTitle,
    PageCommand? pageCommand,
  }) {
    return SelectGuardiansState(
        pageState: pageState ?? this.pageState,
        selectedGuardians: selectedGuardians ?? this.selectedGuardians,
        pageTitle: pageTitle ?? this.pageTitle,
        myGuardians: myGuardians,
        pageCommand: pageCommand);
  }

  factory SelectGuardiansState.initial(List<GuardianModel> myGuardians) {
    var guardian = '';
    if (MAX_GUARDIANS_ALLOWED - myGuardians.length == 1) {
      guardian = 'Guardian';
    } else {
      guardian = 'Guardians';
    }
    return SelectGuardiansState(
      pageState: PageState.initial,
      selectedGuardians: {},
      pageTitle: "Select up to ${MAX_GUARDIANS_ALLOWED - myGuardians.length} ${guardian} to invite",
      myGuardians: myGuardians,
    );
  }
}
