import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ExploreState extends Equatable {
  final PageState pageState;
  final String availableSeeds;
  final String allianceVoice;
  final String campaignVoice;
  final String errorMessage;

  ExploreState({
    @required this.pageState,
    this.availableSeeds,
    this.errorMessage,
    this.allianceVoice,
    this.campaignVoice,
  });

  @override
  List<Object> get props => [pageState, availableSeeds, errorMessage, allianceVoice, campaignVoice];

  ExploreState copyWith({
    PageState pageState,
    String availableSeeds,
    String allianceVoice,
    String campaignVoice,
    String errorMessage,
  }) {
    return ExploreState(
      pageState: pageState ?? this.pageState,
      availableSeeds: availableSeeds ?? this.availableSeeds,
      allianceVoice: allianceVoice ?? this.allianceVoice,
      campaignVoice: campaignVoice ?? this.campaignVoice,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ExploreState.initial() {
    return ExploreState(
      pageState: PageState.initial,
      availableSeeds: null,
      campaignVoice: null,
      allianceVoice: null,
      errorMessage: null,
    );
  }
}
