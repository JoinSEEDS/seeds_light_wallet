import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/screens/app/profile/get_profile_use_case.dart';
import 'package:seeds/screens/app/profile/profile_repository.dart';

/// --- EVENTS
@immutable
abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {
  @override
  String toString() => 'LoadProfile';
}

/// --- STATES
enum PageState { initial, loading, failure, success }

class ProfileState extends Equatable {
  final PageState pageState;
  final ProfileModel profile;
  final String errorMessage;

  ProfileState({
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

  ProfileState copyWith({
    PageState pageState,
    ProfileModel profile,
    String errorMessage,
  }) {
    return ProfileState(
      pageState: pageState ?? this.pageState,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ProfileState.initial() {
    return ProfileState(
      pageState: PageState.initial,
      profile: null,
      errorMessage: null,
    );
  }
}

/// --- BLOC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({@required ProfileRepository profileRepository})
      : assert(profileRepository != null),
        _profileRepository = profileRepository,
        super(ProfileState.initial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfile) {
      yield state.copyWith(pageState: PageState.initial);

      Result result = await GetProfileUseCase(profileRepository: _profileRepository).run("raul11111111");
      yield ProfileStateMapper().mapToState(state, result);
    }
  }
}

abstract class StateMapper<T, State> {
  State mapToState(State state, Result<T> result);
}

class ProfileStateMapper extends StateMapper<ProfileModel, ProfileState> {
  @override
  ProfileState mapToState(ProfileState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError.error.toString());
    } else {
      return currentState.copyWith(pageState: PageState.success, profile: result.asValue.value);
    }
  }
}
