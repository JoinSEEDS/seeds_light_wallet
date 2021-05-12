import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/i18n/wallet.i18n.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/constants/app_colors.dart';

/// Login SCREEN
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: height * 0.4,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage(
                      "assets/images/login/background.png",
                    ))),
          ),
          SvgPicture.asset(
            "assets/images/login/seeds_light_wallet_logo.svg",
          ),
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("First time here?",
                    style: Theme.of(context).textTheme.subtitle2),
                const SizedBox(
                  height: 10,
                ),
                FlatButtonLong(
                  onPressed: () {
                    NavigationService.of(context).navigateTo(Routes.signUp);
                  },
                  title: "Claim invite code".i18n,
                ),
                const SizedBox(
                  height: 40,
                ),
                Text("Already have a Seeds Account?",
                    style: Theme.of(context).textTheme.subtitle2),
                const SizedBox(
                  height: 10,
                ),
                FlatButtonLong(
                  color: AppColors.primary,
                  onPressed: () {
                    NavigationService.of(context).navigateTo(Routes.importKey);
                  },
                  title: "Import private key".i18n,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Lost your key?".i18n,
                  style: Theme.of(context).textTheme.subtitle2),
              GestureDetector(
                  onTap: () {},
                  child: Text(" Recover ".i18n,
                      style: Theme.of(context).textTheme.subtitle2)),
              Text("your account here".i18n,
                  style: Theme.of(context).textTheme.subtitle2),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ));
  }
}
