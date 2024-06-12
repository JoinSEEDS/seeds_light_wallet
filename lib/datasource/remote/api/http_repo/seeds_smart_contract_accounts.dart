const String _accountAccounts = 'accts.seeds';
const String _accountCycle = 'cycle.seeds';
const String _accountEosio = 'eosio';
const String _accountFunds = 'funds.seeds';
const String _accountGuards = 'guard.seeds';
const String _accountHarvest = 'harvst.seeds';
const String _accountJoin = 'join.seeds';
const String _accountToken = 'token.seeds';
const String _accountTokenModels = 'tmastr.seeds';
const String _accountRules = 'rules.seeds';
const String _accountSettgs = 'settgs.seeds';
const String _historySeeds = 'histry.seeds';
const String _accountOrgs = 'orgs.seeds';
const String _accountRegion = 'region.seeds';
const String _accountdelphioracle = 'delphioracle';
const String _voiceScopeAlliance = "alliance";
const String _voiceScopeCampaign = "funds.seeds"; // Note: campaign voice scope is contract scope
const String _voiceScopeMilestone = "milestone"; // Note: campaign voice scope is contract scope

enum SeedsCode {
  accountAccounts,
  accountCycle,
  accountEosio,
  accountFunds,
  accountGuards,
  accountHarvest,
  accountJoin,
  accountToken,
  accountTokenModels,
  accountRules,
  accountSettgs,
  accountRegion,
  historySeeds,
  accountOrgs,
  accountdelphioracle,
  voiceScopeAlliance,
  voiceScopeCampaign,
  voiceScopeMilestone,
}

extension SeedsCodeExtension on SeedsCode {
  String get value {
    switch (this) {
      case SeedsCode.accountAccounts:
        return _accountAccounts;
      case SeedsCode.accountCycle:
        return _accountCycle;
      case SeedsCode.accountEosio:
        return _accountEosio;
      case SeedsCode.accountFunds:
        return _accountFunds;
      case SeedsCode.accountGuards:
        return _accountGuards;
      case SeedsCode.accountHarvest:
        return _accountHarvest;
      case SeedsCode.accountJoin:
        return _accountJoin;
      case SeedsCode.accountToken:
        return _accountToken;
      case SeedsCode.accountTokenModels:
        return _accountTokenModels;
      case SeedsCode.accountRules:
        return _accountRules;
      case SeedsCode.accountSettgs:
        return _accountSettgs;
      case SeedsCode.accountRegion:
        return _accountRegion;
      case SeedsCode.historySeeds:
        return _historySeeds;
      case SeedsCode.accountOrgs:
        return _accountOrgs;
      case SeedsCode.accountdelphioracle:
        return _accountdelphioracle;
      case SeedsCode.voiceScopeAlliance:
        return _voiceScopeAlliance;
      case SeedsCode.voiceScopeCampaign:
        return _voiceScopeCampaign;
      case SeedsCode.voiceScopeMilestone:
        return _voiceScopeMilestone;
    }
  }
}
