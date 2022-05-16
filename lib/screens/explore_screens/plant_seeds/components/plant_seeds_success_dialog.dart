import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class PlantSeedsSuccessDialog extends StatelessWidget {
  const PlantSeedsSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true;
      },
      child: CustomDialog(
        icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
        singleLargeButtonTitle: context.loc.genericCloseButtonTitle,
        onSingleLargeButtonPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                BlocProvider.of<PlantSeedsBloc>(context).state.tokenAmount.amountString(),
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 4),
                child: Text(BlocProvider.of<PlantSeedsBloc>(context).state.tokenAmount.symbol,
                    style: Theme.of(context).textTheme.subtitle2),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            BlocProvider.of<PlantSeedsBloc>(context).state.fiatAmount.asFormattedString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(height: 30.0),
          Text(
            context.loc.plantSeedsPlantSuccessMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.button,
          ),
        ],
      ),
    );
  }
}
