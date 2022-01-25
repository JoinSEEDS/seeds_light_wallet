part of 'sponsor_bloc.dart';

class SponsorState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final List<ProfileModel> sponsors;

  const SponsorState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.sponsors,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        sponsors,
      ];

  SponsorState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    List<ProfileModel>? sponsors,
  }) {
    return SponsorState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      sponsors: sponsors ?? this.sponsors,
    );
  }

  factory SponsorState.initial() {
    return const SponsorState(pageState: PageState.initial, sponsors: []);
  }
}
