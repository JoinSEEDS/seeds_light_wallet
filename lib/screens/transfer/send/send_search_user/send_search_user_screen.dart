import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/search_user/search_user.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/utils/build_context_extension.dart';

class SendSearchUserScreen extends StatelessWidget {
  const SendSearchUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.transferSendSearchTitle),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/images/wallet/app_bar/scan_qr_code_icon.svg', height: 30),
            onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: SearchUser(
        noShowUsers: [settingsStorage.accountName],
        onUserSelected: (selectedUser) {
          print('SendSearchUserScreen - onUserSelected: ${selectedUser.account}');
          NavigationService.of(context).navigateTo(Routes.sendEnterData, selectedUser);
        },
      ),
    );
  }
}
