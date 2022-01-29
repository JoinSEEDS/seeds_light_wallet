part of 'invite_guardians_bloc.dart';

class InviteGuardiansState extends Equatable {
  final PageState pageState;
  final Set<ProfileModel> selectedGuardians;
  final PageCommand? pageCommand;

  const InviteGuardiansState({required this.pageState, required this.selectedGuardians, this.pageCommand});

  @override
  List<Object?> get props => [pageState, selectedGuardians];

  InviteGuardiansState copyWith({
    PageState? pageState,
    Set<ProfileModel>? selectedGuardians,
    PageCommand? pageCommand,
  }) {
    return InviteGuardiansState(
        pageState: pageState ?? this.pageState,
        selectedGuardians: selectedGuardians ?? this.selectedGuardians,
        pageCommand: pageCommand);
  }

  factory InviteGuardiansState.initial(Set<ProfileModel> selectedGuardians) {
    return InviteGuardiansState(pageState: PageState.initial, selectedGuardians: selectedGuardians);
  }
}
