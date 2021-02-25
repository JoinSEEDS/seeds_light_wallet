import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.jungle,
                borderRadius: BorderRadius.all(Radius.circular(defaultCardBorderRadius)),
              ),
              child: Stack(
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
                  Column(
                    children: [
                      Text(
                        'If you have any questions or concerns, Please find our',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
