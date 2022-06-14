import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seeds/datasource/remote/model/proposal_model.dart';
import 'package:seeds/datasource/remote/model/referendum_model.dart';
import 'package:seeds/utils/build_context_extension.dart';
import 'package:timeago/timeago.dart' as timeago;

const double unityThreshold = 0.9;

enum ProposalCategory {
  campaign,
  alliance,
  milestone,
  referendum;

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

class ProposalViewModel {
  final int id;
  final int settingValue;
  final String settingName;
  final String creator;
  final String recipient;
  final String quantity;
  final int total;
  final int favour;
  final int against;
  final String title;
  final String summary;
  final String description;
  final String image;
  final String url;
  final String status;
  final String stage;
  final int creationDate;
  final String campaignType;
  final int voiceNeeded;

  ProposalViewModel({
    required this.id,
    required this.settingValue,
    required this.settingName,
    required this.creator,
    required this.recipient,
    required this.quantity,
    required this.total,
    required this.favour,
    required this.against,
    required this.title,
    required this.summary,
    required this.description,
    required this.image,
    required this.url,
    required this.status,
    required this.stage,
    required this.creationDate,
    required this.campaignType,
    this.voiceNeeded = 0,
  });

  /// Percentage in favour 0-1 scale
  double get favourAgainstBarPercent => total == 0 ? 0 : (favour.toDouble() / total.toDouble());

  String get favourPercent => total > 0 ? '${((favour * 100) / total).toStringAsFixed(0)} %' : '0 %';

  String get againstPercent => total > 0 ? '${((against * 100) / total).toStringAsFixed(0)} %' : '0 %';

  String get createdAt {
    final created = DateTime.fromMillisecondsSinceEpoch(creationDate * 1000);
    if (DateTime.now().difference(created) > const Duration(days: 7)) {
      return DateFormat.yMd(Platform.localeName.split('_').first).format(created);
    } else {
      return timeago.format(created);
    }
  }

  String localizedStatus(BuildContext context) {
    if (status == "passed") {
      return context.loc.proposalStatusPassed;
    } else if (status == "rejected") {
      return context.loc.proposalStatusRejected;
    } else {
      return status;
    }
  }

  ProposalCategory get proposalCategory {
    if (campaignType == 'cmp.funding' || campaignType == 'cmp.invite') {
      return ProposalCategory.campaign;
    } else if (campaignType == ProposalCategory.alliance.name) {
      return ProposalCategory.alliance;
    } else if (campaignType == ProposalCategory.milestone.name) {
      return ProposalCategory.milestone;
    } else if (campaignType == ProposalCategory.referendum.name) {
      return ProposalCategory.referendum;
    } else {
      return ProposalCategory.campaign;
    }
  }

  ProposalViewModel copyWith(int voiceNeeded) {
    return ProposalViewModel(
      id: id,
      settingValue: settingValue,
      settingName: settingName,
      creator: creator,
      recipient: recipient,
      quantity: quantity,
      total: total,
      favour: favour,
      against: against,
      title: title,
      summary: summary,
      description: description,
      image: image,
      url: url,
      status: status,
      stage: stage,
      creationDate: creationDate,
      campaignType: campaignType,
      voiceNeeded: voiceNeeded,
    );
  }

  factory ProposalViewModel.fromProposal(ProposalModel proposal) {
    return ProposalViewModel(
      id: proposal.id,
      settingValue: 0,
      settingName: '',
      creator: proposal.creator,
      recipient: proposal.recipient,
      quantity: proposal.quantity,
      total: proposal.total,
      favour: proposal.favour,
      against: proposal.against,
      title: proposal.title,
      summary: proposal.summary,
      description: proposal.description,
      image: proposal.image,
      url: proposal.url,
      status: proposal.status,
      stage: proposal.stage,
      creationDate: proposal.creationDate,
      campaignType: proposal.campaignType,
    );
  }

  factory ProposalViewModel.fromReferendum(ReferendumModel referendum) {
    return ProposalViewModel(
      id: referendum.id,
      settingValue: referendum.settingValue,
      settingName: referendum.settingName,
      creator: referendum.creator,
      recipient: '',
      quantity: '',
      total: referendum.total,
      favour: referendum.favour,
      against: referendum.against,
      title: referendum.title,
      summary: referendum.summary,
      description: referendum.description,
      image: referendum.image,
      url: referendum.url,
      status: referendum.scope,
      stage: '',
      creationDate: referendum.createdAt,
      campaignType: ProposalCategory.referendum.name,
    );
  }
}
