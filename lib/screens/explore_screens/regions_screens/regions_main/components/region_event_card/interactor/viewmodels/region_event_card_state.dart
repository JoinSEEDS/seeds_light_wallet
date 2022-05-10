part of 'region_event_card_bloc.dart';

class RegionEventCardState extends Equatable {
  final List<ProfileModel> profiles;
  final RegionEventModel event;

  const RegionEventCardState({required this.profiles, required this.event});

  @override
  List<Object> get props => [profiles, event];

  bool get isEventPassEndDate => DateTime.now().millisecondsSinceEpoch > event.eventEndTime.millisecondsSinceEpoch;

  RegionEventCardState copyWith({List<ProfileModel>? profiles, RegionEventModel? event}) {
    return RegionEventCardState(profiles: profiles ?? this.profiles, event: event ?? this.event);
  }

  factory RegionEventCardState.initial(RegionEventModel event) {
    return RegionEventCardState(profiles: [], event: event);
  }
}
