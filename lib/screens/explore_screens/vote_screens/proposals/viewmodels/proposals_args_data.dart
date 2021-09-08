import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/proposal_model.dart';

class ProposalsArgsData {
  final ProfileModel profile;
  final List<ProposalModel> proposals;
  final int index;

  const ProposalsArgsData({
    required this.profile,
    required this.proposals,
    required this.index,
  });
}
