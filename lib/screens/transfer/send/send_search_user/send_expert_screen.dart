import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/transfer_expert/transfer_expert.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/utils/build_context_extension.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/swap_enter_data_screen.dart';


class SendExpertScreen extends StatelessWidget {
  const SendExpertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SwapTxArgs? args = ModalRoute.of(context)!.settings.arguments as SwapTxArgs?;
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
              selected: Set.from(['expert']),
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity(vertical: -3) ),
              onSelectionChanged: (s) => NavigationService.of(context).navigateTo(Routes.transfer, null, true)
          ),
          IconButton(
            icon: SvgPicture.asset('assets/images/wallet/app_bar/scan_qr_code_icon.svg', height: 30),
            onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: TransferExpert(
        walletTokenId: settingsStorage.selectedToken.id,
        outerContext: context,
        args: args,
      ),
    );
  }
}
