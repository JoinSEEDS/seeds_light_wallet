part of 'vouched_bloc.dart';

abstract class VouchedEvent extends Equatable {
  const VouchedEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserVouchedList extends VouchedEvent {
  final bool showVouchForMemberSuccess;

  const LoadUserVouchedList(this.showVouchForMemberSuccess);

  @override
  String toString() => 'LoadUserVouchedList: {ShowVouchForMemberSuccess: $showVouchForMemberSuccess}';
}

class ClearPageCommand extends VouchedEvent {
  const ClearPageCommand();

  @override
  String toString() => 'ClearPageCommand';
}
