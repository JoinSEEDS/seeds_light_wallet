import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/v2/components/search_user/search_user_widget.dart';
import 'package:seeds/v2/datasource/remote/model/member_model.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/design/app_theme.dart';

/// SendSearchUserScreen SCREEN
class SendSearchUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> onResult(MemberModel selectedUser) async {
      print("onResult:" + selectedUser.account);
      await NavigationService.of(context).navigateTo(Routes.sendEnterData, selectedUser);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Send", style: Theme.of(context).textTheme.headline7),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/wallet/app_bar/scan_qr_code_icon.svg',
              height: 30,
            ),
            onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: SearchUserWidget(resultCallBack: onResult),
    );
  }
}
