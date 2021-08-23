import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/i18n/explore_screens/plant_seeds/plant_seeds.i18n.dart';
import 'package:seeds/screens/explore_screens/plant_seeds/interactor/viewmodels/plant_seeds_bloc.dart';

class PlantSeedsSuccessDialog extends StatelessWidget {
  const PlantSeedsSuccessDialog({Key? key}) : super(key: key);

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
        singleLargeButtonTitle: 'Close'.i18n,
        onSingleLargeButtonPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${BlocProvider.of<PlantSeedsBloc>(context).state.quantity}',
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 4),
                child: Text(SeedsToken.symbol, style: Theme.of(context).textTheme.subtitle2),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            '${BlocProvider.of<PlantSeedsBloc>(context).state.fiatAmount} ${settingsStorage.selectedFiatCurrency}',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(height: 30.0),
          Text(
            'Congratulations\nYour seeds were planted successfully!'.i18n,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.button,
          ),
        ],
      ),
    );
  }
}
