const String _tableBalances = 'balances';
const String _tableConfig = 'config';
const String _tableGuards = 'guards';
const String _tableHarvest = 'harvest';
const String _tableRefunds = 'refunds';
const String _tableInvites = 'invites';
const String _tableMoonphases = 'moonphases';
const String _tableProps = 'props';
const String _tableReferendums = 'referendums';
const String _tableRefs = 'refs';
const String _tableSupport = 'support';
const String _tableUsers = 'users';
const String _tableVoice = 'voice';
const String _tableOrganization = 'organization';
const String _tableProposalVotes = 'votes';
const String _tableReferendumVoters = 'voters';
const String _tableDelegates = 'deltrusts';
const String _tableRecover = 'recovers';
const String _tableTotals = 'totals';
const String _tableCycleStats = 'cyclestats';
const String _tabledatapoints = 'datapoints';
const String _tablecbs = 'cbs';
const String _tableCspoints = 'cspoints';
const String _tableRep = 'rep';
const String _tablePlanted = 'planted';
const String _tabletxpoints = 'txpoints';
const String _tableVouches = 'vouches';
const String _tableFlagPoints = 'flags';
const String _tableRegions = 'regions';
const String _tableRegionMembers = 'members';

enum SeedsTable {
  tableBalances,
  tableConfig,
  tableGuards,
  tableHarvest,
  tableRefunds,
  tableInvites,
  tableMoonphases,
  tableProps,
  tableReferendums,
  tableRefs,
  tableSupport,
  tableUsers,
  tableVoice,
  tableOrganization,
  tableProposalVotes,
  tableReferendumVoters,
  tableDelegates,
  tableRecover,
  tableTotals,
  tableCycleStats,
  tableDatapoints,
  tableCbs,
  tableCspoints,
  tableRep,
  tablePlanted,
  tableTxpoints,
  tableVouches,
  tableFlags,
  tableRegions,
  tableRegionMembers,
}

extension SeedsTableExtension on SeedsTable {
  String get value {
    switch (this) {
      case SeedsTable.tableBalances:
        return _tableBalances;
      case SeedsTable.tableConfig:
        return _tableConfig;
      case SeedsTable.tableGuards:
        return _tableGuards;
      case SeedsTable.tableHarvest:
        return _tableHarvest;
      case SeedsTable.tableRefunds:
        return _tableRefunds;
      case SeedsTable.tableInvites:
        return _tableInvites;
      case SeedsTable.tableMoonphases:
        return _tableMoonphases;
      case SeedsTable.tableProps:
        return _tableProps;
      case SeedsTable.tableReferendums:
        return _tableReferendums;
      case SeedsTable.tableRefs:
        return _tableRefs;
      case SeedsTable.tableSupport:
        return _tableSupport;
      case SeedsTable.tableUsers:
        return _tableUsers;
      case SeedsTable.tableVoice:
        return _tableVoice;
      case SeedsTable.tableOrganization:
        return _tableOrganization;
      case SeedsTable.tableProposalVotes:
        return _tableProposalVotes;
      case SeedsTable.tableReferendumVoters:
        return _tableReferendumVoters;
      case SeedsTable.tableDelegates:
        return _tableDelegates;
      case SeedsTable.tableRecover:
        return _tableRecover;
      case SeedsTable.tableTotals:
        return _tableTotals;
      case SeedsTable.tableCycleStats:
        return _tableCycleStats;
      case SeedsTable.tableDatapoints:
        return _tabledatapoints;
      case SeedsTable.tableCbs:
        return _tablecbs;
      case SeedsTable.tableCspoints:
        return _tableCspoints;
      case SeedsTable.tableRep:
        return _tableRep;
      case SeedsTable.tablePlanted:
        return _tablePlanted;
      case SeedsTable.tableTxpoints:
        return _tabletxpoints;
      case SeedsTable.tableVouches:
        return _tableVouches;
      case SeedsTable.tableFlags:
        return _tableFlagPoints;
      case SeedsTable.tableRegions:
        return _tableRegions;
      case SeedsTable.tableRegionMembers:
        return _tableRegionMembers;
    }
  }
}
