import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class CreateUsernameEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OnUsernameChange extends CreateUsernameEvent {
  final String userName;

  OnUsernameChange({@required this.userName}) : assert(userName != null);

  @override
  String toString() => 'OnUsernameChange: { userName: $userName }';
}
