import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/transfer/receive/receive_selection/components/receive_selection_card.dart';
import 'package:seeds/v2/i18n/transfer/transfer.i18n.dart';

/// Receive selection screen
class ReceiveScreen extends StatelessWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose an option".i18n)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Row(
              children: [
                Expanded(
                  child: ReceiveSelectionCard(
                    icon: SvgPicture.asset('assets/images/receive/receive_input_seeds.svg'),
                    title: "Input Seeds or Other Currency".i18n,
                    onTap: () => NavigationService.of(context).navigateTo(Routes.receiveEnterDataScreen),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ReceiveSelectionCard(
                    icon: SvgPicture.asset('assets/images/receive/merchant.svg'),
                    title: "Select a Product or Service".i18n,
                    onTap: () {
                      // TODO(gguij002): Not yet implemented
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
