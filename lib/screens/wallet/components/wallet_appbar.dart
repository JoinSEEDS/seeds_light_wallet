import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/profile_avatar.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/wallet/interactor/viewmodels/wallet_bloc.dart';

class WalletAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WalletAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, state) {
        return AppBar(
          //ignore: avoid_redundant_argument_values
          backgroundColor: testnetMode ? Colors.yellow.withOpacity(0.1) : null,
          actions: [
            const SizedBox(width: horizontalEdgePadding),
            IconButton(
              iconSize: 36,
              splashRadius: 26,
              onPressed: () => NavigationService.of(context).navigateTo(Routes.profile),
              icon: ProfileAvatar(
                size: 36,
                account: state.profile.account,
                nickname: state.profile.nickname,
                image: state.profile.image,
              ),
            ),
            if (testnetMode)
              const Expanded(
                  child: Center(
                child: Text(
                  "Testnet Mode",
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ))
            else
              Expanded(child: Image.asset('assets/images/seeds_symbol_forest.png', fit: BoxFit.fitHeight)),
            IconButton(
              splashRadius: 26,
              icon: SvgPicture.asset('assets/images/wallet/app_bar/scan_qr_code_icon.svg', height: 36),
              onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
            ),
            const SizedBox(width: horizontalEdgePadding),
          ],
        );
      },
    );
  }
}
