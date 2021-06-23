import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/invite_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class StartScan extends PageCommand {}

class StopScan extends PageCommand {}

class ClaimInviteState extends Equatable {
  const ClaimInviteState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    this.inviteModel,
    this.inviteMnemonic,
  });

  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final InviteModel? inviteModel;
  final String? inviteMnemonic;

  factory ClaimInviteState.initial() {
    return const ClaimInviteState(pageState: PageState.initial);
  }

  factory ClaimInviteState.loading(ClaimInviteState currentState) {
    return currentState.copyWith(pageState: PageState.loading);
  }

  factory ClaimInviteState.error(ClaimInviteState currentState, String errorMessage) {
    return currentState.copyWith(
      pageState: PageState.failure,
      pageCommand: StartScan(),
      errorMessage: errorMessage,
      inviteMnemonic: null,
      inviteModel: null,
    );
  }

  bool get isLoading => pageState == PageState.loading && inviteMnemonic != null;
  bool get isValid => pageState == PageState.success && inviteModel != null;

  ClaimInviteState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    InviteModel? inviteModel,
    String? inviteMnemonic,
  }) =>
      ClaimInviteState(
        pageState: pageState ?? this.pageState,
        pageCommand: pageCommand ?? this.pageCommand,
        errorMessage: errorMessage,
        inviteModel: inviteModel ?? this.inviteModel,
        inviteMnemonic: inviteMnemonic ?? this.inviteMnemonic,
      );

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        inviteModel,
        inviteMnemonic,
      ];
}
