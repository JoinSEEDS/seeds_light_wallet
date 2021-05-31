import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/datasource/local/models/token_model.dart';

import 'components/currency_info_card_widget.dart';

class WalletHeader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WalletHeaderState();
  }
}

class WalletHeaderState extends State<WalletHeader> {
  final CarouselController _controller = CarouselController();
  int _selectedIndex = 0;

  ScrollController dd = ScrollController();

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SingleChildScrollView(
          child: CarouselSlider(
            carouselController: _controller,
            items: [
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: CurrencyInfoCardWidget(
                  token: SeedsToken,
                  backgroundImage: 'assets/images/wallet/currency_info_cards/seeds/background.jpg',
                  logo: 'assets/images/wallet/currency_info_cards/seeds/logo.jpg',
                  balanceSubTitle: 'Wallet Balance 1',
                ),
              ),
              const CurrencyInfoCardWidget(
                token: HyphaToken,
                backgroundImage: 'assets/images/wallet/currency_info_cards/hypha/background.jpg',
                logo: 'assets/images/wallet/currency_info_cards/hypha/logo.jpg',
                balanceSubTitle: 'Wallet Balance',
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: CurrencyInfoCardWidget(
                  token: HusdToken,
                  backgroundImage: 'assets/images/wallet/currency_info_cards/planted_seeds/background.jpg',
                  logo: 'assets/images/wallet/currency_info_cards/seeds/logo.jpg',
                  balanceSubTitle: 'Planted Seeds',
                  textColor: AppColors.lightGreen2,
                ),
              ),
            ],
            options: CarouselOptions(
              height: 220,
              viewportFraction: 0.89,
              enableInfiniteScroll: false,
              onPageChanged: onPageChange,
            ),
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
        )
      ],
    );
  }
}
