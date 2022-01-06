part of 'sponsor_bloc.dart';

abstract class SponsorEvent extends Equatable {
  const SponsorEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserSponsorList extends SponsorEvent {
  const LoadUserSponsorList();

  @override
  String toString() => 'LoadUserSponsorList';
}
