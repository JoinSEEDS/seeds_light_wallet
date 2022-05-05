import 'package:collection/collection.dart' show IterableExtension;
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/datasource/remote/model/proposal_model.dart';
import 'package:seeds/datasource/remote/model/referendum_model.dart';
import 'package:seeds/datasource/remote/model/support_level_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/proposals_errors.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_list_bloc.dart';

const String _alliance = 'alliance';
const String _cmpFunding = 'cmp.funding';
const String _cmpInvite = 'cmp.invite';
const String _milestone = 'milestone';
const String _referendum = 'referendum';
const int oneReferendumList = 1;

class ProposalsStateMapper extends StateMapper {
  ProposalsListState mapResultToState({
    required ProposalsListState currentState,
    required List<Result> results,
    bool isScroll = false,
  }) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, error: ProposalsError.unableToLoad);
    } else {
      results.retainWhere((Result i) => i.isValue);
      final values = results.map((Result i) => i.asValue!.value).toList();
      final ProfileModel? profile = values.firstWhereOrNull((i) => i is ProfileModel);
      final List<ProposalModel> proposalsModel = values.firstWhereOrNull((i) => i is List<ProposalModel>);
      final List<List<ReferendumModel>> referendumsLists = values.whereType<List<ReferendumModel>>().toList();
      List<ReferendumModel> referendumsModel = [];
      // For History section referendums need 2 request for passed and failed (2 lists)
      if (referendumsLists.length > oneReferendumList) {
        referendumsModel = referendumsLists.first + referendumsLists.last;
      } else {
        referendumsModel = referendumsLists.first;
      }
      final List<ProposalViewModel> proposals = proposalsModel.map((i) => ProposalViewModel.fromProposal(i)).toList() +
          referendumsModel.map((i) => ProposalViewModel.fromReferendum(i)).toList();
      List<ProposalViewModel> newProposals;

      if (isScroll) {
        // Add the new proposals to current proposals
        newProposals = currentState.proposals + proposals;
      } else {
        newProposals = proposals;
      }

      // Add pass values to proposals by campaing type
      final List<List<SupportLevelModel>> supportLevels = values.whereType<List<SupportLevelModel>>().toList();
      final SupportLevelModel allianceLevel = supportLevels[0].first;
      final SupportLevelModel campaingLevel = supportLevels[1].first;
      final SupportLevelModel milestoneLevel = supportLevels[2].first;

      final updatedProposals = newProposals.map((i) {
        if (i.campaignType == _alliance) {
          i = i.copyWith(allianceLevel.voiceNeeded);
        } else if (i.campaignType == _cmpFunding || i.campaignType == _cmpInvite) {
          i = i.copyWith(campaingLevel.voiceNeeded);
        } else if (i.campaignType == _milestone) {
          i = i.copyWith(milestoneLevel.voiceNeeded);
        } else if (i.campaignType == _referendum) {
          i = i.copyWith(campaingLevel.voiceNeeded);
        }
        return i;
      }).toList();
      // If proposals is a empty list then there are no more items to fetch
      return currentState.copyWith(
        pageState: PageState.success,
        profile: profile,
        proposals: updatedProposals,
        hasReachedMax: proposals.isEmpty || proposals.length < 100,
      );
    }
  }
}
