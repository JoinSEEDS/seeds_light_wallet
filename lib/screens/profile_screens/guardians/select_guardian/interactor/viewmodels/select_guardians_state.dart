part of 'select_guardians_bloc.dart';

const maxGuardiansAllowed = 5;

class SelectGuardiansState extends Equatable {
  final PageState pageState;
  final Set<ProfileModel> selectedGuardians;
  final String pageTitle;
  final List<GuardianModel> myGuardians;
  final PageCommand? pageCommand;
  final List<String>? noShowGuardians;

  const SelectGuardiansState({
    required this.pageState,
    required this.selectedGuardians,
    required this.pageTitle,
    required this.myGuardians,
    this.pageCommand,
    this.noShowGuardians,
  });

  @override
  List<Object?> get props => [
        pageState,
        selectedGuardians,
        pageTitle,
        pageCommand,
        myGuardians,
        noShowGuardians,
      ];

  SelectGuardiansState copyWith({
    PageState? pageState,
    Set<ProfileModel>? selectedGuardians,
    String? pageTitle,
    PageCommand? pageCommand,
    List<String>? noShowGuardians,
  }) {
    return SelectGuardiansState(
      pageState: pageState ?? this.pageState,
      selectedGuardians: selectedGuardians ?? this.selectedGuardians,
      pageTitle: pageTitle ?? this.pageTitle,
      myGuardians: myGuardians,
      pageCommand: pageCommand,
      noShowGuardians: noShowGuardians ?? this.noShowGuardians,
    );
  }

  factory SelectGuardiansState.initial(List<GuardianModel> myGuardians) {
    var guardian = '';
    if (maxGuardiansAllowed - myGuardians.length == 1) {
      guardian = 'Guardian';
    } else {
      guardian = 'Guardians';
    }

    final List<String> noShowGuardians = myGuardians.map((GuardianModel e) => e.uid).toList();
    noShowGuardians.add(settingsStorage.accountName);

    return SelectGuardiansState(
      pageState: PageState.initial,
      selectedGuardians: {},
      pageTitle: "Select up to ${maxGuardiansAllowed - myGuardians.length} $guardian to invite",
      myGuardians: myGuardians,
      noShowGuardians: noShowGuardians,
    );
  }
}
