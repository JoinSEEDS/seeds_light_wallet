import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/dashboard/components/tokens_cards/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/bloc.dart';

import '../currency_info_card_widget.dart';

class TokenCards extends StatefulWidget {
  const TokenCards({Key? key}) : super(key: key);

  @override
  _TokenCardsState createState() => _TokenCardsState();
}

class _TokenCardsState extends State<TokenCards> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => TokenBalancesBloc()..add(const OnLoadTokenBalances()),
      child: BlocListener<WalletBloc, WalletState>(
        listenWhen: (context, state) => state.pageState == PageState.loading,
        listener: (context, state) {
          BlocProvider.of<TokenBalancesBloc>(context).add(const OnLoadTokenBalances());
        },
        child: BlocBuilder<TokenBalancesBloc, TokenBalancesState>(
          builder: (context, state) {
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
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
