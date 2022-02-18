import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ReceiveSendButtons extends StatelessWidget {
  const ReceiveSendButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TokenBalancesBloc, TokenBalancesState>(
      buildWhen: (previous, current) => previous.selectedIndex != current.selectedIndex,
      builder: (context, state) {
        final tokenColor = state.selectedToken.dominantColor;
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: MaterialButton(
                  padding: const EdgeInsets.only(top: 14, bottom: 14),
                  onPressed: () => NavigationService.of(context).navigateTo(Routes.transfer),
                  color: tokenColor ?? AppColors.green1,
                  disabledColor: tokenColor ?? AppColors.green1,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: Center(
                    child: Wrap(
                      children: [
                        const Icon(Icons.arrow_upward, color: AppColors.white),
                        Container(
                          padding: const EdgeInsets.only(left: 4, top: 4),
                          child: Text(context.loc.walletSendButtonTitle, style: Theme.of(context).textTheme.button),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: MaterialButton(
                  padding: const EdgeInsets.only(top: 14, bottom: 14),
                  onPressed: () => NavigationService.of(context).navigateTo(Routes.receiveEnterData),
                  color: tokenColor ?? AppColors.green1,
                  disabledColor: tokenColor ?? AppColors.green1,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: Wrap(
                      children: [
                        const Icon(Icons.arrow_downward, color: AppColors.white),
                        Container(
                          padding: const EdgeInsets.only(left: 4, top: 4),
                          child: Text(context.loc.walletReceiveButtonTitle, style: Theme.of(context).textTheme.button),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
