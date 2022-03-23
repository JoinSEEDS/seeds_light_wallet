import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/transfer/receive/receive_selection/components/receive_selection_card.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ReceiveScreen extends StatelessWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.transferReceiveChooseAnOption)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Row(
              children: [
                Expanded(
                  child: ReceiveSelectionCard(
                    icon: SvgPicture.asset('assets/images/receive/receive_input_seeds.svg'),
                    title: context.loc.transferReceiveInputToken,
                    onTap: () => NavigationService.of(context).navigateTo(Routes.receiveEnterData),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ReceiveSelectionCard(
                    icon: SvgPicture.asset('assets/images/receive/merchant.svg'),
                    title: context.loc.transferReceiveSelectProductOrService,
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
