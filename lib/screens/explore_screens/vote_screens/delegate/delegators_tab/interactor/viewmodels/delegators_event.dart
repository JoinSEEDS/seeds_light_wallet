part of 'delegators_bloc.dart';

abstract class DelegatorsEvent extends Equatable {
  const DelegatorsEvent();

  @override
  List<Object?> get props => [];
}

class OnLoadDelegatorsData extends DelegatorsEvent {
  const OnLoadDelegatorsData();

  @override
  String toString() => 'OnLoadDelegatorsData';
}
