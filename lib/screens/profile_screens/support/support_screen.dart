import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/i18n/profile_screens/support/support.i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Support'.i18n)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(defaultCardBorderRadius),
              onTap: () async => launch('https://discord.gg/pSWdqxTjvB'),
              child: Ink(
                decoration: const BoxDecoration(
                  color: AppColors.lightGreen2,
                  borderRadius: BorderRadius.all(Radius.circular(defaultCardBorderRadius)),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(defaultCardBorderRadius),
                          ),
                          child: SvgPicture.asset(
                            "assets/images/lotus_support_small.svg",
                            color: AppColors.canopy,
                            alignment: Alignment.topLeft,
                          ),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            const SizedBox(height: 50),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(defaultCardBorderRadius),
                              ),
                              child: SvgPicture.asset(
                                "assets/images/lotus_support_big.svg",
                                color: AppColors.canopy,
                                alignment: Alignment.bottomRight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 80.0),
                            child: Text(
                              'If you have any questions or concerns, Please find our'.i18n,
                              style: Theme.of(context).textTheme.buttonLowEmphasis,
                            ),
                          ),
                          Text(
                            'Seeds Light Wallet',
                            style: Theme.of(context).textTheme.headline8.copyWith(color: AppColors.canopy),
                          ),
                          const SizedBox(height: 8.0),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.buttonLowEmphasis,
                              children: <TextSpan>[
                                TextSpan(text: 'Channel in'.i18n),
                                TextSpan(
                                    text: ' Discord ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .buttonLowEmphasis
                                        .copyWith(color: AppColors.canopy)),
                                TextSpan(text: 'here.'.i18n),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
