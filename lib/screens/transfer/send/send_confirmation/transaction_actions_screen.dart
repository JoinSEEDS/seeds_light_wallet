import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/datasource/local/models/eos_action.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/components/transaction_action_card.dart';
import 'package:seeds/utils/build_context_extension.dart';

class TransactionActionsScreen extends StatelessWidget {
  const TransactionActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = ModalRoute.of(context)?.settings.arguments as List<EOSAction>?;
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.transferTransactionActionsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 24),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(color: AppColors.darkGreen2, shape: BoxShape.circle),
                child: SvgPicture.asset("assets/images/seeds_logo.svg"),
              ),
            ),
            if (actions != null)
              for (final i in actions) TransactionActionCard(i)
          ],
        ),
      ),
    );
  }
}
