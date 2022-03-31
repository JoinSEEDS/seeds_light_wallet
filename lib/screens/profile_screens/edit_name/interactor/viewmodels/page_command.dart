part of 'edit_name_bloc.dart';

@freezed
class PageCommand with _$PageCommand {
  const factory PageCommand.navigateToAccountPage() = _PageCommand;

  const factory PageCommand.showErrorMessage(String errorMessage) = _ShowErrorMessage;
}
