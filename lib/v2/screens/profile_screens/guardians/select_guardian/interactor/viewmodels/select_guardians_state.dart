import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class SelectGuardiansState extends Equatable {
  final PageState pageState;
  final Set<MemberModel> selectedGuardians;

  const SelectGuardiansState({required this.pageState, required this.selectedGuardians});

  @override
  List<Object?> get props => [
        pageState,
        selectedGuardians,
      ];

  SelectGuardiansState copyWith({
    PageState? pageState,
    Set<MemberModel>? selectedGuardians,
  }) {
    return SelectGuardiansState(
      pageState: pageState ?? this.pageState,
      selectedGuardians: selectedGuardians ?? this.selectedGuardians,
    );
  }

  factory SelectGuardiansState.initial() {
    return const SelectGuardiansState(pageState: PageState.initial, selectedGuardians: {});
  }
}
