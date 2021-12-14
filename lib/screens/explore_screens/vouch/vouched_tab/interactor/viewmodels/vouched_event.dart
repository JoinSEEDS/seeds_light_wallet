part of 'vouched_bloc.dart';

abstract class VouchedEvent extends Equatable {
  const VouchedEvent();

  @override
  List<Object> get props => [];
}

class LoadUserVouchedList extends VouchedEvent {
  const LoadUserVouchedList();

  @override
  String toString() => 'LoadUserVouchedList';
}
