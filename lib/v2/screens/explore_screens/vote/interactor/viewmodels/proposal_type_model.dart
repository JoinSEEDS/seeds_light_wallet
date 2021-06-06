class ProposalType {
  final String type;
  final String stage;
  final List<String> status;
  final bool isReverse;

  const ProposalType({
    required this.type,
    required this.stage,
    required this.status,
    required this.isReverse,
  });
}

const List<ProposalType> proposalTypes = [
  ProposalType(
    type: 'Stage',
    stage: 'staged',
    status: ['open'],
    isReverse: false,
  ),
  ProposalType(
    type: 'Open',
    stage: 'active',
    status: ['open'],
    isReverse: false,
  ),
  ProposalType(
    type: 'Evaluate',
    stage: 'active',
    status: ['evaluate'],
    isReverse: true,
  ),
  ProposalType(
    type: 'History',
    stage: 'done',
    status: ['passed', 'rejected'],
    isReverse: true,
  ),
];
