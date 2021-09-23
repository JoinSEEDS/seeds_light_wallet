import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';

class ProposalsArgsData {
  final ProfileModel profile;
  final List<ProposalViewModel> proposals;
  final int index;

  const ProposalsArgsData({
    required this.profile,
    required this.proposals,
    required this.index,
  });
}
