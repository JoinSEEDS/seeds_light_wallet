part of 'edit_name_bloc.dart';

class EditNameState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final String? name;

  const EditNameState({required this.pageState, this.errorMessage, this.name});

  @override
  List<Object?> get props => [pageState, errorMessage, name];

  EditNameState copyWith({PageState? pageState, String? errorMessage, String? name}) {
    return EditNameState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      name: name ?? this.name,
    );
  }

  factory EditNameState.initial() {
    return const EditNameState(pageState: PageState.initial);
  }
}
