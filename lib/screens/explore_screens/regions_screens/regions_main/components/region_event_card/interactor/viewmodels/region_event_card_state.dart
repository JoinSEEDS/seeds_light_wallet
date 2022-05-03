part of 'region_event_card_bloc.dart';

class RegionEventCardState extends Equatable {
  final List<ProfileModel> profiles;
  final bool isEventPassEndDate;

  const RegionEventCardState({required this.profiles, required this.isEventPassEndDate});

  @override
  List<Object> get props => [profiles, isEventPassEndDate];

  RegionEventCardState copyWith({List<ProfileModel>? profiles, bool? isEventPassEndDate}) {
    return RegionEventCardState(
        profiles: profiles ?? this.profiles, isEventPassEndDate: isEventPassEndDate ?? this.isEventPassEndDate);
  }

  factory RegionEventCardState.initial() {
    return const RegionEventCardState(profiles: [], isEventPassEndDate: false);
  }
}
