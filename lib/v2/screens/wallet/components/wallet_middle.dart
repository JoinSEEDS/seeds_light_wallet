import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/screens/profile/interactor/profile_bloc.dart';
import 'package:seeds/v2/screens/profile/interactor/viewmodels/profile_state.dart';
import 'package:seeds/v2/screens/wallet/interactor/viewmodels/wallet_state.dart';
import 'package:seeds/v2/screens/wallet/interactor/wallet_bloc.dart';
import 'package:seeds/widgets/dashboard_widgets/receive_button.dart';
import 'package:seeds/widgets/dashboard_widgets/send_button.dart';

/// Wallet Middle
class WalletMiddle extends StatelessWidget {
  const WalletMiddle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onTransfer() {
      NavigationService.of(context).navigateTo(Routes.transfer);
    }

    void onReceive() async {
      NavigationService.of(context).navigateTo(Routes.receive);
    }

    return BlocBuilder<WalletBloc, WalletState>(builder: (context, state) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: (Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(child: SendButton(onPress: onTransfer)),
          SizedBox(width: 20),
          Expanded(child: ReceiveButton(onPress: onReceive)),
        ])),
      );
    });
  }
}
