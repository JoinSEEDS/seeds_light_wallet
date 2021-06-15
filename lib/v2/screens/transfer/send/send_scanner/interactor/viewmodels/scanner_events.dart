import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class SendPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ExecuteScanResult extends SendPageEvent {
  final String scanResult;

  ExecuteScanResult({required this.scanResult});

  @override
  String toString() => 'ExecuteScanResult: { scanResult: $scanResult }';
}
