import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/search_user/search_user.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/utils/build_context_extension.dart';

class SendSearchUserScreen extends StatelessWidget {
  const SendSearchUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.transferSendSearchTitle),
        actions: [
            SegmentedButton(segments:
             <ButtonSegment<String>>[
              ButtonSegment<String>(
                value: 'basic',
                label: Text('BASIC',
                  style: TextStyle(fontSize: 12)
                )),
              ButtonSegment<String>(
                value: 'expert',
                label: Text('EXPERT',
                  style: TextStyle(fontSize: 12)
                ))
             ],
              selected: Set.from(['basic']),
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity(vertical: -3) ),
              onSelectionChanged: (s) {
                print('select ${s}');
                NavigationService.of(context).navigateTo(Routes.transferExpert, null, true);
              }
          ),
          IconButton(
            icon: SvgPicture.asset('assets/images/wallet/app_bar/scan_qr_code_icon.svg', height: 30),
            onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: SearchUser(
        noShowUsers: [settingsStorage.accountName],
        onUserSelected: (selectedUser) async {
          print('SendSearchUserScreen - onUserSelected: ${selectedUser.account}');
          final walletProfile = (await ProfileRepository().getProfile(settingsStorage.accountName)).asValue?.value;
          NavigationService.of(context).navigateTo(Routes.sendEnterData, {"to": selectedUser!, "from": walletProfile!});
        },
      ),
    );
  } 
}
