import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class DelegateAUserState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final Set<MemberModel> selectedDelegate;

  const DelegateAUserState({
    this.pageCommand,
    required this.pageState,
    required this.selectedDelegate,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        selectedDelegate,
      ];

  DelegateAUserState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    Set<MemberModel>? selectedDelegate,
  }) {
    return DelegateAUserState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      selectedDelegate: selectedDelegate ?? this.selectedDelegate,
    );
  }

  factory DelegateAUserState.initial() {
    return const DelegateAUserState(
      pageState: PageState.initial,
      selectedDelegate: {},
    );
  }
}
