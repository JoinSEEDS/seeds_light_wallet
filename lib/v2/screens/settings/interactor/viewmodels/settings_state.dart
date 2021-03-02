import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';

/// STATE
class SettingsState extends Equatable {
  final PageState pageState;
  final ProfileModel profile;
  final String errorMessage;

  const SettingsState({
    @required this.pageState,
    this.profile,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
        pageState,
        profile,
        errorMessage,
      ];

  SettingsState copyWith({
    PageState pageState,
    ProfileModel profile,
    String errorMessage,
  }) {
    return SettingsState(
      pageState: pageState ?? this.pageState,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory SettingsState.initial() {
    return const SettingsState(
      pageState: PageState.initial,
      profile: null,
      errorMessage: null,
    );
  }
}
