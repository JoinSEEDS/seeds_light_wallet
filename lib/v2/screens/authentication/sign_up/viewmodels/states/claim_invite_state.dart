import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/invite_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';

class StartScan extends PageCommand {}

class StopScan extends PageCommand {}

enum ClaimInviteView { initial, scanner, processing, success, fail }

class ClaimInviteState extends Equatable {
  final PageCommand? pageCommand;
  final String? errorMessage;
  final ClaimInviteView claimInviteView;
  final InviteModel? inviteModel;
  final String? inviteMnemonic;
  final bool fromDeepLink;

  const ClaimInviteState({
    this.pageCommand,
    this.errorMessage,
    required this.claimInviteView,
    this.inviteModel,
    this.inviteMnemonic,
    required this.fromDeepLink
  });

  @override
  List<Object?> get props => [
        pageCommand,
        errorMessage,
        claimInviteView,
        inviteModel,
        inviteMnemonic,
        fromDeepLink,
      ];

  ClaimInviteState copyWith({
    PageCommand? pageCommand,
    String? errorMessage,
    ClaimInviteView? claimInviteView,
    InviteModel? inviteModel,
    String? inviteMnemonic,
    bool? fromDeepLink,
  }) =>
      ClaimInviteState(
        pageCommand: pageCommand,
        errorMessage: errorMessage,
        claimInviteView: claimInviteView ?? this.claimInviteView,
        inviteModel: inviteModel ?? this.inviteModel,
        inviteMnemonic: inviteMnemonic ?? this.inviteMnemonic,
        fromDeepLink: fromDeepLink ?? this.fromDeepLink
      );

  factory ClaimInviteState.initial() {
    return const ClaimInviteState(claimInviteView: ClaimInviteView.initial, fromDeepLink: false);
  }
}
