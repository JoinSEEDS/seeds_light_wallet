import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/i18n/wallet/wallet.i18n.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_bloc.dart';
import 'package:seeds/v2/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_state.dart';

class ReceiveSendButtons extends StatelessWidget {
  const ReceiveSendButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TokenBalancesBloc, TokenBalancesState>(
      buildWhen: (previous, current) => previous.selectedIndex != current.selectedIndex,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Opacity(
                  opacity: state.selectedIndex == 0 ? 1 : 0.3,
                  child: MaterialButton(
                    padding: const EdgeInsets.only(top: 14, bottom: 14),
                    onPressed: state.selectedIndex == 0
                        ? () => NavigationService.of(context).navigateTo(Routes.transfer)
                        : null,
                    color: AppColors.green1,
                    disabledColor: AppColors.green1,
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
                            child: Text('Send'.i18n, style: Theme.of(context).textTheme.button),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Opacity(
                  opacity: state.selectedIndex == 0 ? 1 : 0.3,
                  child: MaterialButton(
                    padding: const EdgeInsets.only(top: 14, bottom: 14),
                    onPressed: state.selectedIndex == 0
                        ? () => NavigationService.of(context).navigateTo(Routes.receiveEnterDataScreen)
                        : null,
                    color: AppColors.green1,
                    disabledColor: AppColors.green1,
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
                            child: Text('Receive'.i18n, style: Theme.of(context).textTheme.button),
                          ),
                        ],
                      ),
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
