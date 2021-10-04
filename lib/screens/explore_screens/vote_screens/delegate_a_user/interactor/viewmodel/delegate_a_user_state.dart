import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class DelegateAUserState extends Equatable {
  final PageState pageState;
  final Set<MemberModel> selectedDelegate;
  final PageCommand? pageCommand;

  const DelegateAUserState({
    required this.pageState,
    required this.selectedDelegate,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        selectedDelegate,
        pageCommand,
      ];

  DelegateAUserState copyWith({
    PageState? pageState,
    Set<MemberModel>? selectedDelegate,
    PageCommand? pageCommand,
  }) {
    return DelegateAUserState(
      pageState: pageState ?? this.pageState,
      selectedDelegate: selectedDelegate ?? this.selectedDelegate,
      pageCommand: pageCommand,
    );
  }

  factory DelegateAUserState.initial() {
    return const DelegateAUserState(
      pageState: PageState.initial,
      selectedDelegate: {},
    );
  }
}
