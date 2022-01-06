part of 'recover_account_search_bloc.dart';

abstract class RecoverAccountSearchEvent extends Equatable {
  const RecoverAccountSearchEvent();

  @override
  List<Object?> get props => [];
}

class OnUsernameChanged extends RecoverAccountSearchEvent {
  final String userName;

  const OnUsernameChanged(this.userName);

  @override
  String toString() => 'OnUsernameChanged { userName: $userName}';
}

class OnNextButtonTapped extends RecoverAccountSearchEvent {
  const OnNextButtonTapped();

  @override
  String toString() => 'OnNextButtonTapped';
}
