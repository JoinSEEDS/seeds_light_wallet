import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/invite_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class StartScan extends PageCommand {}

class StopScan extends PageCommand {}

class ClaimInviteState extends Equatable {
  const ClaimInviteState({
    required this.pageState,
    this.errorMessage,
    this.inviteModel,
    this.inviteMnemonic,
    this.pageCommand,
  });

  final PageState pageState;
  final String? errorMessage;
  final InviteModel? inviteModel;
  final String? inviteMnemonic;
  final PageCommand? pageCommand;

  factory ClaimInviteState.initial() {
    return const ClaimInviteState(pageState: PageState.initial);
  }

  factory ClaimInviteState.loading(ClaimInviteState currentState) {
    return currentState.copyWith(pageState: PageState.loading);
  }

  factory ClaimInviteState.error(ClaimInviteState currentState, String errorMessage) {
    return currentState.copyWith(
      pageState: PageState.failure,
      errorMessage: errorMessage,
      inviteMnemonic: null,
      inviteModel: null,
      pageCommand: StartScan(),
    );
  }

  bool get isChecked => pageState == PageState.success && inviteModel != null;
  bool get isLoading => pageState == PageState.loading && inviteMnemonic != null;

  ClaimInviteState copyWith({
    PageState? pageState,
    String? errorMessage,
    InviteModel? inviteModel,
    String? inviteMnemonic,
    PageCommand? pageCommand,
  }) =>
      ClaimInviteState(
        pageState: pageState ?? this.pageState,
        errorMessage: errorMessage ?? this.errorMessage,
        inviteModel: inviteModel ?? this.inviteModel,
        inviteMnemonic: inviteMnemonic ?? this.inviteMnemonic,
        pageCommand: pageCommand ?? this.pageCommand,
      );

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        inviteModel,
        inviteMnemonic,
        pageCommand,
      ];
}
