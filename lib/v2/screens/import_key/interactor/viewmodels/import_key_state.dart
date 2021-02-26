import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ImportKeyState extends Equatable {
  final PageState pageState;

  const ImportKeyState({
    @required this.pageState,
  });

  @override
  List<Object> get props => [pageState];

  ImportKeyState copyWith({
    PageState pageState
  }) {
    return ImportKeyState(
      pageState: pageState ?? this.pageState,
    );
  }

  factory ImportKeyState.initial() {
    return const ImportKeyState(
      pageState: PageState.initial,
    );
  }
}
