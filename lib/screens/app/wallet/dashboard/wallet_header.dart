import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:seeds/constants/app_colors.dart';

import '../../../../widgets/dashboard_widgets/currency_info_card.dart';

class WalletHeader extends StatefulWidget {
  final PageController controller;

  const WalletHeader({this.controller});

  @override
  State<StatefulWidget> createState() {
    return WalletHeaderState();
  }
}

class WalletHeaderState extends State<WalletHeader> {
  final CarouselController _controller = CarouselController();
  int _selectedIndex = 0;

  ScrollController dd = ScrollController();

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              onPageChanged: onPageChanged,
              controller: widget.controller,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CurrencyInfoCard(
                    backgroundImage: 'assets/images/wallet/currency_info_cards/seeds/background.jpg',
                    title: "Seeds",
                    logo: 'assets/images/wallet/currency_info_cards/seeds/logo.jpg',
                    balanceSubTitle: 'Wallet Balance',
                    balance: '1244.32',
                    fiatBalance: " \$6,423 USD",
                  ),
                ),
                CurrencyInfoCard(
                  backgroundImage: 'assets/images/wallet/currency_info_cards/hypha/background.jpg',
                  title: "Hypha",
                  logo: 'assets/images/wallet/currency_info_cards/hypha/logo.jpg',
                  balanceSubTitle: 'Wallet Balance',
                  balance: '68436.32',
                  fiatBalance: " \$9,236.45 USD",
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: CurrencyInfoCard(
                    backgroundImage: 'assets/images/wallet/currency_info_cards/planted_seeds/background.jpg',
                    title: "Planted Seeds",
                    logo: 'assets/images/wallet/currency_info_cards/seeds/logo.jpg',
                    balanceSubTitle: 'Planted Seeds',
                    balance: '1244.32',
                    fiatBalance: " \$6,423 USD",
                    textColor: AppColors.lightGreen2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          DotsIndicator(
            dotsCount: 3,
            position: _selectedIndex.toDouble(),
            decorator: const DotsDecorator(
              spacing: EdgeInsets.all(2.0),
              size: Size(10.0, 2.0),
              shape: Border(),
              color: AppColors.darkGreen2,
              activeColor: AppColors.green1,
              activeSize: Size(18.0, 2.0),
              activeShape: Border(),
            ),
          ),
        ],
      ),
    );
  }
}
