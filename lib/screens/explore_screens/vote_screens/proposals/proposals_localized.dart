import 'package:flutter/widgets.dart';
import 'package:seeds/screens/explore_screens/vote_screens/proposals/viewmodels/proposal_view_model.dart';
import 'package:seeds/utils/build_context_extension.dart';

extension LocalizedProposalCategory on ProposalCategory {
  String localizedDescription(BuildContext context) {
    switch (this) {
      case ProposalCategory.alliance:
        return context.loc.proposalCategoryAlliance;
      case ProposalCategory.campaign:
        return context.loc.proposalCategoryCampaign;
      case ProposalCategory.milestone:
        return context.loc.proposalCategoryMilestone;
      case ProposalCategory.referendum:
        return context.loc.proposalCategoryReferendum;
    }
  }
}

extension LocalizedProposalViewModel on ProposalViewModel {
  String localizedStatus(BuildContext context) {
    if (status == "passed") {
      return context.loc.proposalStatusPassed;
    } else if (status == "rejected") {
      return context.loc.proposalStatusRejected;
    } else {
      return status;
    }
  }
}
