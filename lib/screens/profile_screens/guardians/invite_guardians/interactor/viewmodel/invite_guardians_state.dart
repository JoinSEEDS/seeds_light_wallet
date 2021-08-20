import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class InviteGuardiansState extends Equatable {
  final PageState pageState;
  final Set<MemberModel> selectedGuardians;
  final PageCommand? pageCommand;

  const InviteGuardiansState({required this.pageState, required this.selectedGuardians, this.pageCommand});

  @override
  List<Object?> get props => [pageState, selectedGuardians];

  InviteGuardiansState copyWith({
    PageState? pageState,
    Set<MemberModel>? selectedGuardians,
    PageCommand? pageCommand,
  }) {
    return InviteGuardiansState(
        pageState: pageState ?? this.pageState,
        selectedGuardians: selectedGuardians ?? this.selectedGuardians,
        pageCommand: pageCommand);
  }

  factory InviteGuardiansState.initial(Set<MemberModel> selectedGuardians) {
    return InviteGuardiansState(pageState: PageState.initial, selectedGuardians: selectedGuardians);
  }
}
