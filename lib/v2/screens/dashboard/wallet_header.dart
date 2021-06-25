import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/screens/dashboard/interactor/available_tokens_bloc.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/available_tokens_event.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/available_tokens_state.dart';

import 'components/currency_info_card_widget.dart';

class WalletHeader extends StatefulWidget {
  const WalletHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WalletHeaderState();
  }
}

class WalletHeaderState extends State<WalletHeader> {
  final CarouselController _controller = CarouselController();
  int _selectedIndex = 0;
  late AvailableTokensBloc _bloc;
  ScrollController dd = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = AvailableTokensBloc()..add(const OnLoadAvailableTokens());
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void reload() {
    _bloc.add(const OnLoadAvailableTokens());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailableTokensBloc, AvailableTokensState>(
        bloc: _bloc,
        builder: (context, state) {
          return Column(
            children: <Widget>[
              SingleChildScrollView(
                child: CarouselSlider(
                  carouselController: _controller,
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
                    onPageChanged: onPageChange,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DotsIndicator(
                dotsCount: state.availableTokens.length,
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
        });
  }
}
