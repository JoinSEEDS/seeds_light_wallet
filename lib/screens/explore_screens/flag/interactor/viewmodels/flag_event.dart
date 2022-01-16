part of 'flag_bloc.dart';

abstract class FlagEvent extends Equatable {
  const FlagEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsersFlags extends FlagEvent {
  const LoadUsersFlags();

  @override
  String toString() => 'LoadUsersFlags';
}
