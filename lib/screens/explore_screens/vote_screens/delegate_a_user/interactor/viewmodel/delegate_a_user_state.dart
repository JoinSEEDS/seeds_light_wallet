import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class DelegateAUserState extends Equatable {
  final PageCommand? pageCommand;
  final PageState pageState;
  final Set<MemberModel> selectedDelegate;
  final List<String> noShowUsers;

  const DelegateAUserState({
    this.pageCommand,
    required this.pageState,
    required this.selectedDelegate,
    required this.noShowUsers,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        pageState,
        selectedDelegate,
        noShowUsers,
      ];

  DelegateAUserState copyWith({
    PageCommand? pageCommand,
    PageState? pageState,
    Set<MemberModel>? selectedDelegate,
    List<String>? noShowUsers,
  }) {
    return DelegateAUserState(
      pageCommand: pageCommand,
      pageState: pageState ?? this.pageState,
      selectedDelegate: selectedDelegate ?? this.selectedDelegate,
      noShowUsers: noShowUsers ?? this.noShowUsers,
    );
  }

  factory DelegateAUserState.initial() {
    final List<String> noShowUsers = [settingsStorage.accountName];

    return DelegateAUserState(
      pageState: PageState.success,
      selectedDelegate: {},
      noShowUsers: noShowUsers,
    );
  }
}
