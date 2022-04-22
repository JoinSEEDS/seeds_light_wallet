part of 'region_event_card_bloc.dart';

class RegionEventCardState extends Equatable {
  final List<ProfileModel> profiles;

  const RegionEventCardState({required this.profiles});

  @override
  List<Object> get props => [profiles];

  RegionEventCardState copyWith({List<ProfileModel>? profiles}) {
    return RegionEventCardState(profiles: profiles ?? this.profiles);
  }

  factory RegionEventCardState.initial() {
    return const RegionEventCardState(profiles: []);
  }
}
