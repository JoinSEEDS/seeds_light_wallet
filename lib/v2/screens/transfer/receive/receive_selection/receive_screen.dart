import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/transfer/receive/receive_selection/components/receive_selection_card.dart';

/// Receive selection screen
class ReceiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Choose an option")),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
              child: Row(mainAxisSize: MainAxisSize.max, children: [
                Expanded(
                    child: ReceiveSelectionCard(
                        icon: SvgPicture.asset('assets/images/receive/receive_input_seeds.svg'),
                        title: "Input Seeds or Other Currency",
                        onTap: () {
                          NavigationService.of(context).navigateTo(Routes.receiveEnterDataScreen);
                        })),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: ReceiveSelectionCard(
                        icon: SvgPicture.asset('assets/images/receive/merchant.svg'),
                        title: "Select a Product or Service",
                        onTap: () {
                          NavigationService.of(context).navigateTo(Routes.receive);
                        })),
              ]),
            ),
          ],
        ));
  }
}
