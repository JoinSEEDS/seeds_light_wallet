const String _accountAccounts = 'accts.seeds';
const String _accountCycle = 'cycle.seeds';
const String _accountEosio = 'eosio';
const String _accountFunds = 'funds.seeds';
const String _accountGuards = 'guard.seeds';
const String _accountHarvest = 'harvst.seeds';
const String _accountJoin = 'join.seeds';
const String _accountToken = 'token.seeds';
const String _accountRules = 'rules.seeds';
const String _accountSettgs = 'settgs.seeds';
const String _historySeeds = 'histry.seeds';
const String _accountOrgs = 'orgs.seeds';
const String _accountdelphioracle = 'delphioracle';

enum SeedsScope {
  accountAccounts,
  accountCycle,
  accountEosio,
  accountFunds,
  accountGuards,
  accountHarvest,
  accountJoin,
  accountToken,
  accountRules,
  accountSettgs,
  historySeeds,
  accountOrgs,
  accountdelphioracle,
}

extension SeedsTableExtension on SeedsScope {
  String get value {
    switch (this) {
      case SeedsScope.accountAccounts:
        return _accountAccounts;
      case SeedsScope.accountCycle:
        return _accountCycle;
      case SeedsScope.accountEosio:
        return _accountEosio;
      case SeedsScope.accountFunds:
        return _accountFunds;
      case SeedsScope.accountGuards:
        return _accountGuards;
      case SeedsScope.accountHarvest:
        return _accountHarvest;
      case SeedsScope.accountJoin:
        return _accountJoin;
      case SeedsScope.accountToken:
        return _accountToken;
      case SeedsScope.accountRules:
        return _accountRules;
      case SeedsScope.accountSettgs:
        return _accountSettgs;
      case SeedsScope.historySeeds:
        return _historySeeds;
      case SeedsScope.accountOrgs:
        return _accountOrgs;
      case SeedsScope.accountdelphioracle:
        return _accountdelphioracle;
      default:
        return '';
    }
  }
}
