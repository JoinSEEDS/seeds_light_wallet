import './index.dart';

List<TableModel> contractTables = <TableModel>[
  TableModel(
    name: "Token Balance",
    code: "token.seeds",
    table: "accounts",
    scope: "sevenflash42", // todo: allow to find by any user account
  ),
  TableModel(
    name: "Token Circulating",
    code: "token.seeds",
    table: "circulating",
    scope: "token.seeds",
  ),
  TableModel(
    name: "Token Stats",
    code: "token.seeds",
    table: "stat",
    scope: "SEEDS",
  ),
  TableModel(
    name: "Transaction Stats",
    code: "token.seeds",
    table: "trxstat",
    scope: "SEEDS",
  ),
  TableModel(
      name: "History Totals",
      code: "histry.seeds",
      table: "totals",
      scope: "histry.seeds"),
  TableModel(
      name: "History Transactions",
      code: "histry.seeds",
      table: "transactions",
      scope: "sevenflash42"),
  TableModel(
      name: "History Points",
      code: "histry.seeds",
      table: "trxpoints",
      scope: "sevenflash42"),
  TableModel(
      name: "History Volumes",
      code: "histry.seeds",
      table: "qevs",
      scope: "sevenflash42"),
  TableModel(
      name: "Accounts - Users",
      code: "accts.seeds",
      table: "users",
      scope: "acct.seeds"),
  TableModel(
      name: "Accounts - Referrals",
      code: "accts.seeds",
      table: "refs",
      scope: "acct.seeds"),
  TableModel(
      name: "Accounts - Reputation",
      code: "accts.seeds",
      table: "rep",
      scope: "acct.seeds"),
  TableModel(
      name: "Accounts - Scores",
      code: "accts.seeds",
      table: "cbs",
      scope: "acct.seeds"),
  TableModel(
      name: "Harvest - Balances",
      code: "harvst.seeds",
      table: "balances",
      scope: "harvst.seeds"),
  TableModel(
      name: "Harvest - Contribution",
      code: "harvst.seeds",
      table: "cspoints",
      scope: "harvst.seeds"),
  TableModel(
      name: "Harvest - Harvest",
      code: "harvst.seeds",
      table: "harvest",
      scope: "harvst.seeds"),
  TableModel(
      name: "Harvest - Volumes",
      code: "harvst.seeds",
      table: "monthlyqevs",
      scope: "harvst.seeds"),
  TableModel(
      name: "Harvest - Planted",
      code: "harvst.seeds",
      table: "planted",
      scope: "harvst.seeds"),
  TableModel(
      name: "Harvest - Points",
      code: "harvst.seeds",
      table: "txpoints",
      scope: "harvst.seeds"),
  TableModel(
      name: "Settings - Config",
      code: "settgs.seeds",
      table: "config",
      scope: "settgs.seeds"),
  TableModel(
      name: "Settings - Float",
      code: "settgs.seeds",
      table: "configfloat",
      scope: "settgs.seeds"),
  TableModel(
      name: "Settings - Contracts",
      code: "settgs.seeds",
      table: "contracts",
      scope: "settgs.seeds"),
  TableModel(
    name: "Proposals - Proposals",
    code: "funds.seeds",
    table: "props",
    scope: "funds.seeds",
  ),
  TableModel(
    name: "Proposals - Voice",
    code: "funds.seeds",
    table: "voice",
    scope: "funds.seeds",
  ),
  TableModel(
    name: "Proposals - Actives",
    code: "funds.seeds",
    table: "actives",
    scope: "funds.seeds",
  ),
  TableModel(
    name: "Proposals - Cycle",
    code: "funds.seeds",
    table: "cycle",
    scope: "funds.seeds",
  ),
  TableModel(
    name: "Proposals - Stakes",
    code: "funds.seeds",
    table: "minstake",
    scope: "funds.seeds",
  ),
  TableModel(
    name: "Proposals - Participants",
    code: "funds.seeds",
    table: "participants",
    scope: "funds.seeds",
  ),
  TableModel(
      name: "Referendums",
      code: "rules.seeds",
      table: "referendums",
      scope: "rules.seeds"),
  TableModel(
      name: "Policy",
      code: "policy.seeds",
      table: "devicepolicy",
      scope: "policy.seeds"),
  TableModel(
      name: "Onboarding - Invites",
      code: "join.seeds",
      table: "invites",
      scope: "join.seeds"),
  TableModel(
      name: "Onboarding - Balances",
      code: "join.seeds",
      table: "sponsors",
      scope: "join.seeds"),
  TableModel(
    name: "Exchange - Config",
    code: "tlosto.seeds",
    table: "config",
    scope: "tlosto.seeds",
  ),
  TableModel(
    name: "Exchange - Daily Stats",
    code: "tlosto.seeds",
    table: "dailystats",
    scope: "tlosto.seeds",
  ),
  TableModel(
    name: "Exchange - History",
    code: "tlosto.seeds",
    table: "payhistory",
    scope: "tlosto.seeds",
  ),
  TableModel(
    name: "Exchange - Price",
    code: "tlosto.seeds",
    table: "price",
    scope: "tlosto.seeds",
  ),
  TableModel(
    name: "Exchange - Price History",
    code: "tlosto.seeds",
    table: "pricehistory",
    scope: "tlosto.seeds",
  ),
  TableModel(
    name: "Exchange - Rounds",
    code: "tlosto.seeds",
    table: "rounds",
    scope: "tlosto.seeds",
  ),
  TableModel(
    name: "Escrow - Locks",
    code: "escrow.seeds",
    table: "locks",
    scope: "escrow.seeds",
  ),
  TableModel(
    name: "Escrow - Sponsors",
    code: "escrow.seeds",
    table: "sponsors",
    scope: "escrow.seeds",
  ),
  TableModel(
    name: "Scheduler",
    code: "cycle.seeds",
    table: "operations",
    scope: "cycle.seeds",
  ),
  TableModel(
    name: "Organizations",
    code: "orgs.seeds",
    table: "organization",
    scope: "orgs.seeds",
  ),
  TableModel(
      name: "Guardians", code: "guard.seeds", table: "guards", scope: "guards"),
  TableModel(
      name: "Recovers",
      code: "guard.seeds",
      table: "recovers",
      scope: "guard.seeds"),
];
