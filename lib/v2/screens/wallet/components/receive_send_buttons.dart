import 'package:flutter/material.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/wallet/components/receive_button.dart';
import 'package:seeds/v2/screens/wallet/components/send_button.dart';

class ReceiveSendButtons extends StatelessWidget {
  const ReceiveSendButtons();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Expanded(child: SendButton(onPress: () => NavigationService.of(context).navigateTo(Routes.transfer))),
        const SizedBox(width: 20),
        Expanded(
          child: ReceiveButton(
            onPress: () async => await NavigationService.of(context).navigateTo(Routes.receiveEnterDataScreen),
          ),
        )
      ]),
    );
  }
}
