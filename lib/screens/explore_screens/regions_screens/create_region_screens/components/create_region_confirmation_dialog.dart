import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/images/explore/red_exclamation_circle.dart';
import 'package:seeds/screens/explore_screens/regions_screens/create_region_screens/interactor/viewmodels/create_region_bloc.dart';

class CreateRegionConfirmationDialog extends StatelessWidget {
  const CreateRegionConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: CustomDialog(
        icon: const CustomPaint(size: Size(60, 60), painter: RedExclamationCircle()),
        leftButtonTitle: "Cancel",
        rightButtonTitle: "Yes I'm sure",
        onRightButtonPressed: () {
          BlocProvider.of<CreateRegionBloc>(context).add(const OnConfirmCreateRegionTapped());
          Navigator.of(context).pop();
        },
        children: [
          const SizedBox(height: 10.0),
          Text("Create Region Confirmation", style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 30.0),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                TextSpan(text: "By selecting “Yes I’m sure”,", style: Theme.of(context).textTheme.subtitle2),
                TextSpan(text: " 1,000 Seeds", style: Theme.of(context).textTheme.subtitle2Green3LowEmphasis),
                TextSpan(
                    text: " will be staked and your region will be created for others to see and join.",
                    style: Theme.of(context).textTheme.subtitle2)
              ])),
          const SizedBox(height: 16.0),
          Text("Please make sure that everything is in order and that you are ready to create your region!",
              style: Theme.of(context).textTheme.subtitle2, textAlign: TextAlign.center),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
