part of 'edit_name_bloc.dart';

@freezed
class EditNameStateData with _$EditNameStateData {
  const factory EditNameStateData(
      {String? errorMessage,
      required ProfileModel profileModel,
      required String name,
      @Default(false) bool shouldShowButtonLoading,
      PageCommand? pageCommand}) = _EditNameStateData;

  const EditNameStateData._(); // Added constructor

  bool get isSubmitEnabled => profileModel.nickname != name && name.length <= nameMaxChars;
}
