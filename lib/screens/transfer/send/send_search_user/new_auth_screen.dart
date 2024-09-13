import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/components/transfer_expert/components/select_user_text_field.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/utils/build_context_extension.dart';




class NewAuthScreen extends StatelessWidget {
  const NewAuthScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    String textVal = "";
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Authorization"),//Text(context.loc.transferSendSearchTitle),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/images/wallet/app_bar/scan_qr_code_icon.svg', height: 30),
            onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: Column( children: [
        Padding(
          padding: EdgeInsets.only(right: horizontalEdgePadding, left: horizontalEdgePadding, top: 10),
          child: SelectUserTextField(updater: ((s) => textVal=s )),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: FlatButtonLong(
              title: context.loc.transferSendNextButtonTitle,
              enabled: true, //state.isNextButtonEnabled,
              onPressed: () {
                Navigator.pop(context, textVal);
              },
            ),
          )
        ]
      )
    );
  }
}
