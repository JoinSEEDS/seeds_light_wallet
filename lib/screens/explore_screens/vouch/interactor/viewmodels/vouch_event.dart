part of 'vouch_bloc.dart';

abstract class VouchEvent extends Equatable {
  const VouchEvent();

  @override
  List<Object> get props => [];
}

class LoadUserVouchList extends VouchEvent {
  const LoadUserVouchList();

  @override
  String toString() => 'LoadUserVouchList';
}

class OnRemoveVouchButtonTapped extends VouchEvent {
  const OnRemoveVouchButtonTapped();

  @override
  String toString() => 'OnRemoveVouchButtonTapped';
}
