import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/search_user/search_user.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/i18n/transfer/transfer.i18n.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_arguments.dart';

/// SendSearchUserScreen SCREEN
class SendSearchUserScreen extends StatelessWidget {
  const SendSearchUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = ModalRoute.of(context)!.settings.arguments! as TokenModel;
    return Scaffold(
      appBar: AppBar(
        title: Text("Send".i18n),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/images/wallet/app_bar/scan_qr_code_icon.svg', height: 30),
            onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: SearchUser(
        resultCallBack: (selectedUser) {
          NavigationService.of(context).navigateTo(Routes.sendEnterData, SendEnterDataArguments(selectedUser, token));
        },
      ),
    );
  }
}
