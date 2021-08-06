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

  const ClaimInviteState({
    this.pageCommand,
    this.errorMessage,
    required this.claimInviteView,
    this.inviteModel,
    this.inviteMnemonic,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        errorMessage,
        claimInviteView,
        inviteModel,
        inviteMnemonic,
      ];

  ClaimInviteState copyWith({
    PageCommand? pageCommand,
    String? errorMessage,
    ClaimInviteView? claimInviteView,
    InviteModel? inviteModel,
    String? inviteMnemonic,
  }) =>
      ClaimInviteState(
        pageCommand: pageCommand,
        errorMessage: errorMessage,
        claimInviteView: claimInviteView ?? this.claimInviteView,
        inviteModel: inviteModel ?? this.inviteModel,
        inviteMnemonic: inviteMnemonic ?? this.inviteMnemonic,
      );

  factory ClaimInviteState.initial() {
    return const ClaimInviteState(claimInviteView: ClaimInviteView.initial);
  }
}
