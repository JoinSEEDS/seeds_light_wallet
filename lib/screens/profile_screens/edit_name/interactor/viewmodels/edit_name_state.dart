part of 'edit_name_bloc.dart';

class EditNameState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final ProfileModel profileModel;
  final String name;
  final PageCommand? pageCommand;

  bool get isSubmitEnabled => profileModel.nickname != name && name.length <= nameMaxChars;

  const EditNameState({
    required this.pageState,
    this.errorMessage,
    required this.name,
    required this.profileModel,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        name,
        profileModel,
        pageCommand,
      ];

  EditNameState copyWith({
    PageState? pageState,
    String? errorMessage,
    String? name,
    ProfileModel? profileModel,
    PageCommand? pageCommand,
  }) {
    return EditNameState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      name: name ?? this.name,
      profileModel: profileModel ?? this.profileModel,
      pageCommand: pageCommand,
    );
  }

  factory EditNameState.initial(ProfileModel profileModel) {
    return EditNameState(
      pageState: PageState.initial,
      profileModel: profileModel,
      name: profileModel.nickname,
    );
  }
}
