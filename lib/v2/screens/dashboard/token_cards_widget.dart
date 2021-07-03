import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/screens/dashboard/interactor/token_balances_bloc.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/token_balances_event.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/token_balances_state.dart';

import 'components/currency_info_card_widget.dart';

class TokenCardsWidget extends StatelessWidget {

  const TokenCardsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TokenBalancesBloc()..add(const OnLoadTokenBalances()),
        child: BlocBuilder<TokenBalancesBloc, TokenBalancesState>(builder: (context, state) {
          return Column(
            children: <Widget>[
              SingleChildScrollView(
                child: CarouselSlider(
                  items: List.of(state.availableTokens.map(
                    (item) => Container(
                      margin: EdgeInsets.only(
                          left: item.token == state.availableTokens.first.token ? 0 : 10.0,
                          right: item.token == state.availableTokens.last.token ? 0 : 10.0),
                      child: CurrencyInfoCardWidget(
                        tokenBalance: item,
                      ),
                    ),
                  )),
                  options: CarouselOptions(
                    height: 220,
                    viewportFraction: 0.89,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, controller) =>
                        BlocProvider.of<TokenBalancesBloc>(context).add(OnSelectedTokenChanged(index)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DotsIndicator(
                dotsCount: state.availableTokens.length,
                position: state.selectedIndex.toDouble(),
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
        }));
  }
}
