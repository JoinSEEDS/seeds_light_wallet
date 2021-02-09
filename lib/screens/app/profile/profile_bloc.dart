import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:seeds/models/models.dart';
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
enum PageState { initial, loading, failure }

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
      pageState: PageState.loading,
      profile: ProfileModel(),
      errorMessage: '',
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
      try {
        final profile = await _profileRepository.getProfile();
        if (profile != null) {
          yield state.copyWith(
            pageState: PageState.initial,
            profile: profile,
          );
        }
      } catch (error) {
        yield state.copyWith(
          pageState: PageState.failure,
          errorMessage: error.message,
        );
      }
    }
  }
}
