import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum PageState { scan, processing, success, error, stop }

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
      pageState: pageState ?? this.pageState,
    );
  }

  factory ScannerState.initial() {
    return const ScannerState(
      pageState: PageState.scan,
    );
  }
}
