import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/components/generic_region_dialog.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/viewmodel/region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class RegionBottomSheet extends StatelessWidget {
  final TypeOfUsers userType;

  const RegionBottomSheet(this.userType, {Key? key}) : super(key: key);

  void show(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: context,
        builder: (_) => BlocProvider.value(value: BlocProvider.of<RegionBloc>(context), child: this));
  }

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
          buttonSheetButtons(userType, context)
        ],
      ),
    );
  }
}

Widget buttonSheetButtons(TypeOfUsers typeOfUsers, BuildContext context) {
  switch (typeOfUsers) {
    case TypeOfUsers.admin:
      return Column(children: [
        ListTile(
          onTap: () => BlocProvider.of<RegionBloc>(context).add(const OnEditRegionImageButtonPressed()),
          leading: const Icon(Icons.add_photo_alternate_outlined),
          title: const Text("Edit Region Image"),
        ),
        ListTile(
          onTap: () => BlocProvider.of<RegionBloc>(context).add(const OnEditRegionDescriptionButtonPressed()),
          leading: const Icon(Icons.edit),
          title: const Text("Edit Description"),
        ),
      ]);
    case TypeOfUsers.member:
      return ListTile(
        onTap: () {
          GenericRegionDialog(
                  title: context.loc.leaveRegionConfirmDialogTitle,
                  description: context.loc.leaveRegionConfirmDialogDescription)
              .show(context)
              .then((isConfirmed) {
            if (isConfirmed ?? false) {
              Navigator.of(context).pop();
              BlocProvider.of<RegionBloc>(context).add(const OnLeaveRegionButtonPressed());
            }
          });
        },
        leading: const Icon(Icons.logout),
        title: Text(context.loc.regionBottomSheetLeaveRegionTitle),
      );
  }
}
