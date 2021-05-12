import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/invite_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ClaimInviteState extends Equatable {
  const ClaimInviteState({
    required this.pageState,
    this.errorMessage,
    this.inviteModel,
    this.inviteMnemonic,
  });

  final PageState pageState;
  final String? errorMessage;
  final InviteModel? inviteModel;
  final String? inviteMnemonic;

  factory ClaimInviteState.initial() {
    return const ClaimInviteState(pageState: PageState.initial);
  }

  factory ClaimInviteState.loading(ClaimInviteState currentState) {
    return currentState.copyWith(pageState: PageState.loading);
  }

  factory ClaimInviteState.error(
      ClaimInviteState currentState, String errorMessage) {
    return currentState.copyWith(
      pageState: PageState.failure,
      errorMessage: errorMessage,
      inviteMnemonic: null,
      inviteModel: null,
    );
  }

  ClaimInviteState copyWith({
    PageState? pageState,
    String? errorMessage,
    InviteModel? inviteModel,
    String? inviteMnemonic,
  }) =>
      ClaimInviteState(
        pageState: pageState ?? this.pageState,
        errorMessage: errorMessage ?? this.errorMessage,
        inviteModel: inviteModel ?? this.inviteModel,
        inviteMnemonic: inviteMnemonic ?? this.inviteMnemonic,
      );

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        inviteModel,
        inviteMnemonic,
      ];

  @override
  bool operator ==(Object other) {
    return other is ClaimInviteState &&
        pageState == other.pageState &&
        errorMessage == other.errorMessage &&
        inviteModel == other.inviteModel &&
        inviteMnemonic == other.inviteMnemonic;
  }
}
