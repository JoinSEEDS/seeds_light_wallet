class ProposalType {
  /// UI param
  final int index;

  /// UI param
  final String type;

  /// Request param
  final String lowerUpperBound;

  /// Request param
  final int indexPosition;

  /// Request param
  final bool isReverse;

  // Filter by stage - stage can be one of: staged, active, done
  final String? filterByStage;

  const ProposalType({
    required this.index,
    required this.type,
    required this.lowerUpperBound,
    required this.indexPosition,
    required this.isReverse,
    this.filterByStage
  });
}

const List<ProposalType> proposalTypes = [
  ProposalType(
    index: 0,
    type: 'Open',
    lowerUpperBound: 'open',
    indexPosition: 2,
    isReverse: false,
    filterByStage: "active"
  ),
  ProposalType(
    index: 1,
    type: 'Upcoming',
    lowerUpperBound: 'staged',
    indexPosition: 3,
    isReverse: false,
  ),
  ProposalType(
    index: 2,
    type: 'History',
    lowerUpperBound: 'done',
    indexPosition: 3,
    isReverse: true,
  ),
];
