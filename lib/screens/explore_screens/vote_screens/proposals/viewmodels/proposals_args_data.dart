import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/campaign_delegate.dart';

class ProposalsArgsData {
  final ProfileModel profile;
  final List<ProposalViewModel> proposals;
  final List<CategoryDelegate> currentDelegates;
  final int index;

  const ProposalsArgsData({
    required this.profile,
    required this.proposals,
    required this.currentDelegates,
    required this.index,
  });

  ProposalsArgsData copyWith({List<CategoryDelegate>? currentDelegates}) {
    return ProposalsArgsData(
      profile: profile,
      proposals: proposals,
      currentDelegates: currentDelegates ?? this.currentDelegates,
      index: index,
    );
  }
}
