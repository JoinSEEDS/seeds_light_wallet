import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/interactor/viewmodels/region_event_details_bloc.dart';

class RegionEventDetailBottomSheet extends StatelessWidget {
  const RegionEventDetailBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 40.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 8.0, bottom: 22.0),
            width: 54,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: const DividerJungle(thickness: 4, height: 4),
            ),
          ),
          ListTile(
            onTap: () => BlocProvider.of<RegionEventDetailsBloc>(context).add(const OnEditEventImageTapped()),
            leading: const Icon(Icons.add_photo_alternate_outlined),
            title: const Text("Edit Event Image"),
          ),
          ListTile(
            onTap: () =>
                BlocProvider.of<RegionEventDetailsBloc>(context).add(const OnEditEventNameAndDescriptionTapped()),
            leading: const Icon(Icons.edit),
            title: const Text("Edit Name & Description"),
          ),
          ListTile(
            onTap: () => BlocProvider.of<RegionEventDetailsBloc>(context).add(const OnEditEventDateAndTimeTapped()),
            leading: const Icon(Icons.watch_later_outlined),
            title: const Text("Edit Time & Date"),
          ),
          ListTile(
            onTap: () => BlocProvider.of<RegionEventDetailsBloc>(context).add(const OnEditEventLocationTapped()),
            leading: const Icon(Icons.location_on),
            title: const Text("Edit Location"),
          ),
          ListTile(
            onTap: () => BlocProvider.of<RegionEventDetailsBloc>(context).add(const OnDeleteEventTapped()),
            leading: const Icon(Icons.delete),
            title: const Text("Delete Event"),
          ),
        ],
      ),
    );
  }
}
