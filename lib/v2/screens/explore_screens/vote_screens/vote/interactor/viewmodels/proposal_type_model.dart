class ProposalType {
  final int index;
  final String type;
  final String stage;
  final List<String> status;
  final bool isReverse;

  const ProposalType({
    required this.index,
    required this.type,
    required this.stage,
    required this.status,
    required this.isReverse,
  });
}

const List<ProposalType> proposalTypes = [
  ProposalType(
    index: 0,
    type: 'Open',
    stage: 'active',
    status: ['open'],
    isReverse: false,
  ),
  ProposalType(
    index: 1,
    type: 'Upcoming',
    stage: 'staged',
    status: ['open'],
    isReverse: false,
  ),
  ProposalType(
    index: 2,
    type: 'History',
    stage: 'done',
    status: ['passed', 'rejected'],
    isReverse: true,
  ),
];
