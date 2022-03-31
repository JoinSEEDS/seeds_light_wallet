part of 'edit_name_bloc.dart';

@freezed
class EditNameEvent with _$EditNameEvent {
  const factory EditNameEvent.onNameChanged(String name) = _OnNameChanged;

  const factory EditNameEvent.submitName() = _SubmitName;

  const factory EditNameEvent.clearPageCommand() = _ClearPageCommand;
}
