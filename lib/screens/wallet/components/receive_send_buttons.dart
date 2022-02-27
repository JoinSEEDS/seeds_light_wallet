import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/remote/api/region_repository.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ReceiveSendButtons extends StatelessWidget {
  const ReceiveSendButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TokenBalancesBloc, TokenBalancesState>(
      buildWhen: (previous, current) => previous.selectedIndex != current.selectedIndex,
      builder: (context, state) {
        final tokenColor = state.selectedToken.dominantColor;
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: MaterialButton(
                  padding: const EdgeInsets.only(top: 14, bottom: 14),
                  onPressed: () => NavigationService.of(context).navigateTo(Routes.transfer),
                  color: tokenColor ?? AppColors.green1,
                  disabledColor: tokenColor ?? AppColors.green1,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: Center(
                    child: Wrap(
                      children: [
                        const Icon(Icons.arrow_upward, color: AppColors.white),
                        Container(
                          padding: const EdgeInsets.only(left: 4, top: 4),
                          child: Text(context.loc.walletSendButtonTitle, style: Theme.of(context).textTheme.button),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: MaterialButton(
                  padding: const EdgeInsets.only(top: 14, bottom: 14),
                  // onPressed: () => NavigationService.of(context).navigateTo(Routes.receiveEnterData),
                  onPressed: () async {
                    print("Reveive pressed - Testing Regions Calls");

                    // 1 - Get Region Fee

                    // final fee = await RegionRepository().getRegionFee();
                    // print("fee: ${fee.asValue?.value}");
                    // flutter: fee: 1000.0

                    // 2 - Get regions
                    final regionResult = await RegionRepository().getRegions();
                    final regions = regionResult.asValue!.value;
                    for (final item in regions) {
                      print("reg: ${item.id} founder: ${item.founder} count: ${item.membersCount}");
                    }

                    // 3 - Get members in region 0
                    // final membersResult = await RegionRepository().getRegionMembers(regions[0].id);
                    // final members = membersResult.asValue!.value;
                    // for (final item in members) {
                    //   print("member: ${item.account} joined: ${item.joinedDate} reg: ${item.region}");
                    // }

                    // 4 - JOIN REGION

                    // final theRegion = regions[0].id;
                    // final txResult = await RegionRepository().join(region: theRegion, account: "testingseeds");
                    // final membersResult2 = await RegionRepository().getRegionMembers(theRegion);
                    // // NOTE: joining/leaving a region doe snot immediately update
                    // // so the call right after gets the old result.
                    // // join/leave works though
                    // final members2 = membersResult.asValue!.value;
                    // for (final item in members2) {
                    //   print("member: ${item.account} joined: ${item.joinedDate} reg: ${item.region}");
                    // }
                    // final theRegion = regions[0].id;

                    // 5 - LEAVE REGION
                    // final txResult = await RegionRepository().leave(region: theRegion, account: "testingseeds");
                    // final membersResult2 = await RegionRepository().getRegionMembers(theRegion);
                    // final members2 = membersResult.asValue!.value;
                    // for (final item in members2) {
                    //   print("member: ${item.account} joined: ${item.joinedDate} reg: ${item.region}");
                    // }

                    // 6 - CREATE REGION
                    // print("create region");
                    // final txResult = await RegionRepository().create(
                    //   userAccount: "testingseeds",
                    //   regionAccount: "wallet1.rgn",
                    //   title: "Wallet Region Ubud",
                    //   description: 'test region create from wallet - Ubud location',
                    //   latitude: -8.506854,
                    //   longitude: 115.262482,
                    // );
                    // print(txResult);

                    // 6 - UPDATE REGION
                    // print("update region");
                    // final txResult = await RegionRepository().update(
                    //   userAccount: "testingseeds",
                    //   regionAccount: "wallet1.rgn",
                    //   title: "Region Ubud",
                    //   description: 'Updated description',
                    //   latitude: -8.506855,
                    //   longitude: 115.262483,
                    // );
                    // print(txResult);
                  },
                  color: tokenColor ?? AppColors.green1,
                  disabledColor: tokenColor ?? AppColors.green1,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: Wrap(
                      children: [
                        const Icon(Icons.arrow_downward, color: AppColors.white),
                        Container(
                          padding: const EdgeInsets.only(left: 4, top: 4),
                          child: Text(context.loc.walletReceiveButtonTitle, style: Theme.of(context).textTheme.button),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
