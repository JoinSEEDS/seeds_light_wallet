import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ScannerState extends Equatable {
  final PageState pageState;

  const ScannerState({
    @required this.pageState,
  });

  @override
  List<Object> get props => [pageState];

  ScannerState copyWith({
    PageState pageState,
  }) {
    return ScannerState(
      pageState: pageState ?? this.pageState
    );
  }

  factory ScannerState.initial() {
    return const ScannerState(pageState: PageState.initial);
  }
}
