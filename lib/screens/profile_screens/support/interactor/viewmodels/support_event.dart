part of 'support_bloc.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

class LoadSupportData extends SupportEvent {
  const LoadSupportData();

  @override
  String toString() => 'LoadSupportData';
}
