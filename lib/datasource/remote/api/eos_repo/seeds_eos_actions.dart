const String _actionNameAgainst = 'against';
const String _actionNameCancel = 'cancel';
const String _actionNameFavour = 'favour';
const String _actionNameInit = 'init';
const String _actionNameClaim = 'claim';
const String _actionNameInvite = 'invite';
const String _actionNameCancelInvite = 'cancel';
const String _actionNameTransfer = 'transfer';
const String _actionNameUpdateauth = 'updateauth';
const String _actionNameUpdate = 'update';
const String _actionNameMakeresident = 'makeresident';
const String _actionNameCanresident = 'canresident';
const String _actionNameMakecitizen = 'makecitizen';
const String _actionNameCakecitizen = 'cancitizen';
const String _actionNameAcceptnew = 'acceptnew';
const String _actionNameAcceptExisting = 'acceptexist';
const String _actionNameRecover = 'recover';
const String _actionNameUnplant = 'unplant';
const String _actionNameClaimRefund = 'claimrefund';
const String _proposalActionNameDelegate = 'delegate';
const String _proposalActionNameUndelegate = 'undelegate';
const String _actionNameVouch = 'vouch';
const String _actionNameFlag = 'flag';
const String _actionNameRemoveFlag = 'removeflag';
const String _actionNameCreateRegion = 'create';
const String _actionNameUpdateRegion = 'update';
const String _actionNameJoinRegion = 'join';
const String _actionNameLeaveRegion = 'leave';

enum SeedsEosAction {
  actionNameAgainst,
  actionNameCancel,
  actionNameFavour,
  actionNameInit,
  actionNameClaim,
  actionNameInvite,
  actionNameCancelInvite,
  actionNameTransfer,
  actionNameUpdateauth,
  actionNameUpdate,
  actionNameMakeresident,
  actionNameCanresident,
  actionNameMakecitizen,
  actionNameCakecitizen,
  actionNameAcceptnew,
  actionNameAcceptExisting,
  actionNameRecover,
  actionNameUnplant,
  actionNameClaimRefund,
  proposalActionNameDelegate,
  proposalActionNameUndelegate,
  actionNameVouch,
  actionNameFlag,
  actionNameRemoveFlag,
  actionNameCreateRegion,
  actionNameUpdateRegion,
  actionNameJoinRegion,
  actionNameLeaveRegion,
}

extension SeedsEosActionExtension on SeedsEosAction {
  String get value {
    switch (this) {
      case SeedsEosAction.actionNameAgainst:
        return _actionNameAgainst;
      case SeedsEosAction.actionNameCancel:
        return _actionNameCancel;
      case SeedsEosAction.actionNameFavour:
        return _actionNameFavour;
      case SeedsEosAction.actionNameInit:
        return _actionNameInit;
      case SeedsEosAction.actionNameClaim:
        return _actionNameClaim;
      case SeedsEosAction.actionNameInvite:
        return _actionNameInvite;
      case SeedsEosAction.actionNameCancelInvite:
        return _actionNameCancelInvite;
      case SeedsEosAction.actionNameTransfer:
        return _actionNameTransfer;
      case SeedsEosAction.actionNameUpdateauth:
        return _actionNameUpdateauth;
      case SeedsEosAction.actionNameUpdate:
        return _actionNameUpdate;
      case SeedsEosAction.actionNameMakeresident:
        return _actionNameMakeresident;
      case SeedsEosAction.actionNameMakecitizen:
        return _actionNameMakecitizen;
      case SeedsEosAction.actionNameCakecitizen:
        return _actionNameCakecitizen;
      case SeedsEosAction.actionNameCanresident:
        return _actionNameCanresident;
      case SeedsEosAction.actionNameAcceptnew:
        return _actionNameAcceptnew;
      case SeedsEosAction.actionNameAcceptExisting:
        return _actionNameAcceptExisting;
      case SeedsEosAction.actionNameRecover:
        return _actionNameRecover;
      case SeedsEosAction.actionNameUnplant:
        return _actionNameUnplant;
      case SeedsEosAction.actionNameClaimRefund:
        return _actionNameClaimRefund;
      case SeedsEosAction.proposalActionNameDelegate:
        return _proposalActionNameDelegate;
      case SeedsEosAction.proposalActionNameUndelegate:
        return _proposalActionNameUndelegate;
      case SeedsEosAction.actionNameVouch:
        return _actionNameVouch;
      case SeedsEosAction.actionNameFlag:
        return _actionNameFlag;
      case SeedsEosAction.actionNameRemoveFlag:
        return _actionNameRemoveFlag;
      case SeedsEosAction.actionNameCreateRegion:
        return _actionNameCreateRegion;
      case SeedsEosAction.actionNameUpdateRegion:
        return _actionNameUpdateRegion;
      case SeedsEosAction.actionNameJoinRegion:
        return _actionNameJoinRegion;
      case SeedsEosAction.actionNameLeaveRegion:
        return _actionNameLeaveRegion;
    }
  }
}
