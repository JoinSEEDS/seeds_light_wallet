part of 'guardians_bloc.dart';

class GuardiansState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final PageCommand? pageCommand;
  final int indexDialog;
  final bool isAddGuardianButtonLoading;

  const GuardiansState({
    required this.pageState,
    this.errorMessage,
    this.pageCommand,
    required this.indexDialog,
    required this.isAddGuardianButtonLoading,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        indexDialog,
        errorMessage,
        isAddGuardianButtonLoading,
      ];

  GuardiansState copyWith({
    PageState? pageState,
    String? errorMessage,
    PageCommand? pageCommand,
    int? indexDialog,
    bool? isAddGuardianButtonLoading,
  }) {
    return GuardiansState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      pageCommand: pageCommand,
      indexDialog: indexDialog ?? this.indexDialog,
      isAddGuardianButtonLoading: isAddGuardianButtonLoading ?? this.isAddGuardianButtonLoading,
    );
  }

  factory GuardiansState.initial() {
    return const GuardiansState(pageState: PageState.initial, indexDialog: 1, isAddGuardianButtonLoading: false);
  }
}
