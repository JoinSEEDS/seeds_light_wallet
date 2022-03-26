import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/components/custom_dialog.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ClaimSeedsSuccessDialog extends StatelessWidget {
  final TokenDataModel claimSeedsAmount;
  final FiatDataModel claimSeedsAmountFiat;

  const ClaimSeedsSuccessDialog({Key? key, required this.claimSeedsAmountFiat, required this.claimSeedsAmount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, ModalRoute.withName('app'));
        await NavigationService.of(context).navigateTo(Routes.unPlantSeeds);
        return true;
      },
      child: CustomDialog(
        icon: SvgPicture.asset('assets/images/security/success_outlined_icon.svg'),
        singleLargeButtonTitle: context.loc.genericCloseButtonTitle,
        onSingleLargeButtonPressed: () {
          Navigator.popUntil(context, ModalRoute.withName('app'));
          NavigationService.of(context).navigateTo(Routes.unPlantSeeds);
        },
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                claimSeedsAmount.amountString(),
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 4),
                child: Text(claimSeedsAmount.symbol, style: Theme.of(context).textTheme.subtitle2),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            claimSeedsAmountFiat.asFormattedString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(height: 20.0),
          Text(context.loc.plantSeedsClaimSuccessMessage,
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
