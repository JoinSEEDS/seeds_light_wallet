import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/images/explore/regions.dart';
import 'package:seeds/screens/explore_screens/regions_screens/join_region/interactor/viewmodels/join_region_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class CreateNewRegionDialog extends StatelessWidget {
  const CreateNewRegionDialog({super.key});

  Future<void> show(BuildContext context, JoinRegionBloc joinRegionBloc) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(value: joinRegionBloc, child: this),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double iconSize = MediaQuery.of(context).size.width * 0.3;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: CustomDialog(
        leftButtonTitle: context.loc.createRegionDialogLeftButtonTitle,
        rightButtonTitle: context.loc.createRegionSelectRegionButtonTitle,
        onRightButtonPressed: () {
          BlocProvider.of<JoinRegionBloc>(context).add(const OnCreateRegionNextTapped());
        },
        children: [
          Text(context.loc.createRegionDialogTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 30.0),
          Container(width: iconSize, height: iconSize, child: const CustomPaint(painter: Regions())),
          const SizedBox(height: 30.0),
          Text(
            context.loc.createRegionDialogSubtitle,
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
