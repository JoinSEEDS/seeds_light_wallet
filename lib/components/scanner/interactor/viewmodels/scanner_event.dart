part of 'scanner_bloc.dart';

abstract class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object?> get props => [];
}

class ShowLoading extends ScannerEvent {
  const ShowLoading();

  @override
  String toString() => 'ShowLoading';
}

class Scan extends ScannerEvent {
  const Scan();

  @override
  String toString() => 'Scan';
}
