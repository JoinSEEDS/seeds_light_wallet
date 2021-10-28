import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_state.dart';

class ManageInvitesState extends Equatable {
  final PageState pageState;

  const ManageInvitesState({required this.pageState});

  @override
  List<Object?> get props => [
        pageState,
      ];

  ManageInvitesState copyWith({
    PageState? pageState,
  }) {
    return ManageInvitesState(pageState: pageState ?? this.pageState);
  }

  factory ManageInvitesState.initial() {
    return const ManageInvitesState(pageState: PageState.initial);
  }
}
