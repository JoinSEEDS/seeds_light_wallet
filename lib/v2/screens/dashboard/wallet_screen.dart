import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/i18n/explore_screens/explore/explore.i18n.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';
import 'package:seeds/v2/screens/dashboard/components/tokens_cards/tokens_cards.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/bloc.dart';

// Widgets to be moved to v2
import 'package:seeds/widgets/v2_widgets/dashboard_widgets/receive_button.dart';
import 'package:seeds/widgets/v2_widgets/dashboard_widgets/send_button.dart';

/// Wallet SCREEN
class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => WalletBloc()..add(LoadUserValues()),
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.loading:
              return const FullPageLoadingIndicator();
            case PageState.failure:
              return const FullPageErrorIndicator();
            case PageState.success:
              return RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<RatesBloc>(context).add(const FetchRates());
                  BlocProvider.of<WalletBloc>(context).add(const RefreshDataEvent());
                },
                child: Scaffold(
                  appBar: buildAppBar(
                    context,
                    state.profile!.account,
                    state.profile!.nickname,
                    state.profile!.image,
                  ) as PreferredSizeWidget,
                  body: ListView(
                    // TODO(n13): Use exact measurements from figma
                    children: <Widget>[
                      const SizedBox(height: 15),
                      const TokenCards(),
                      const SizedBox(height: 20),
                      buildSendReceiveButton(context),
                      const SizedBox(height: 20),
                      walletBottom(context),
                    ],
                  ),
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildSendReceiveButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Expanded(child: SendButton(onPress: () => NavigationService.of(context).navigateTo(Routes.transfer))),
        const SizedBox(width: 20),
        Expanded(
            child: ReceiveButton(
                onPress: () async => await NavigationService.of(context).navigateTo(Routes.receiveEnterDataScreen))),
      ]),
    );
  }

  Widget buildAppBar(BuildContext context, String account, String? nickname, String? image) {
    return AppBar(
      actions: [
        const SizedBox(width: horizontalEdgePadding),
        IconButton(
          iconSize: 36,
          splashRadius: 26,
          onPressed: () => NavigationService.of(context).navigateTo(Routes.profile),
          icon: ProfileAvatar(
            size: 36,
            account: account,
            nickname: nickname,
            image: image,
          ),
        ),
        Expanded(child: Image.asset('assets/images/seeds_symbol_forest.png', height: 56, fit: BoxFit.fitHeight)),
        IconButton(
          splashRadius: 26,
          icon: SvgPicture.asset(
            'assets/images/wallet/app_bar/scan_qr_code_icon.svg',
            height: 36,
          ),
          onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
        ),
        const SizedBox(width: horizontalEdgePadding),
      ],
    );
  }

  Widget walletBottom(BuildContext context) {
    return Column(
      children: <Widget>[transactionHeader(context), buildTransactions()],
    );
  }

  Widget transactionHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
        Expanded(child: Text('Transactions History'.i18n, style: Theme.of(context).textTheme.headline7LowEmphasis)),
        Text(
          'View All'.i18n,
          style: const TextStyle(color: AppColors.canopy),
        )
      ]),
    );
  }

  Widget buildTransactions() {
    return const SizedBox.shrink();
  }
}
