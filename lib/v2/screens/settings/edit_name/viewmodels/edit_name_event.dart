import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class EditNameEvent extends Equatable {
  const EditNameEvent();
  @override
  List<Object> get props => [];
}

class OnNameChanged extends EditNameEvent {
  final String name;

  const OnNameChanged({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'OnNameChanged { name: $name }';
}

class SubmitName extends EditNameEvent {
  final String accountName;
  final String privateKey;
  final String nodeEndpoint;
  const SubmitName({this.accountName, this.privateKey, this.nodeEndpoint});

  @override
  String toString() => 'SubmitName';
}
