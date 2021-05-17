import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/interactor/viewmodels/bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:seeds/v2/components/circular_progress_item.dart';
import 'package:seeds/i18n/citizenship.18n.dart';

class ResidentView extends StatefulWidget {
  const ResidentView();

  @override
  _ResidentViewState createState() => _ResidentViewState();
}

class _ResidentViewState extends State<ResidentView> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _timeLineAnimation,
      _reputationAnimation,
      _residentsAnimation,
      _ageAnimation,
      _seedsAnimation,
      _transactionsAnimation,
      _visitorsAnimation;
  int _timeLine = 0, _reputation = 0, _residents = 0, _age = 0, _seeds = 0, _transactions = 0, _visitors = 0;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CitizenshipBloc, CitizenshipState>(
      listenWhen: (previous, current) =>
          previous.pageState != PageState.success && current.pageState == PageState.success,
      listener: (context, state) {
        _timeLineAnimation = Tween<double>(begin: 0, end: state.progressTimeline).animate(_controller)
          ..addListener(() {
            setState(() => _timeLine = _timeLineAnimation.value.toInt());
          });
        _reputationAnimation =
            Tween<double>(begin: 0, end: state.score!.reputationScore.toDouble()).animate(_controller)
              ..addListener(() {
                setState(() => _reputation = _reputationAnimation.value.toInt());
              });
        _residentsAnimation = Tween<double>(begin: 0, end: state.invitedResidents!.toDouble()).animate(_controller)
          ..addListener(() {
            setState(() => _residents = _residentsAnimation.value.toInt() * 100);
          });
        _ageAnimation = Tween<double>(begin: 0, end: state.profile!.accountAge.toDouble()).animate(_controller)
          ..addListener(() {
            setState(() => _age = _ageAnimation.value.toInt());
          });
        _seedsAnimation = Tween<double>(begin: 0, end: state.score!.plantedScore.toDouble()).animate(_controller)
          ..addListener(() {
            setState(() => _seeds = _seedsAnimation.value.toInt());
          });
        _transactionsAnimation =
            Tween<double>(begin: 0, end: state.score!.transactionsScore.toDouble()).animate(_controller)
              ..addListener(() {
                setState(() => _transactions = _transactionsAnimation.value.toInt());
              });
        _visitorsAnimation = Tween<double>(begin: 0, end: state.invitedVisitors!.toDouble()).animate(_controller)
          ..addListener(() {
            setState(() => _visitors = _visitorsAnimation.value.toInt() * 100);
          });
        _controller.forward();
      },
      builder: (context, state) {
        switch (state.pageState) {
          case PageState.initial:
            return const SizedBox.shrink();
          case PageState.loading:
            return const FullPageLoadingIndicator();
          case PageState.failure:
            return const FullPageErrorIndicator();
          case PageState.success:
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        ProfileAvatar(
                          size: 100,
                          image: state.profile!.image,
                          nickname: state.profile!.nickname,
                          account: state.profile!.account,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          state.profile!.nickname ?? '',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          state.profile!.statusString.i18n,
                          style: Theme.of(context).textTheme.headline7LowEmphasis,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.lightGreen2,
                    borderRadius: BorderRadius.all(Radius.circular(defaultCardBorderRadius)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Progress Timeline'.i18n, style: Theme.of(context).textTheme.button),
                            Text('$_timeLine%', style: Theme.of(context).textTheme.subtitle2LowEmphasis),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        StepProgressIndicator(
                          totalSteps: 100,
                          currentStep: _timeLine,
                          size: 4,
                          padding: 0,
                          selectedColor: AppColors.green1,
                          unselectedColor: AppColors.primary,
                          roundedEdges: const Radius.circular(10),
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ),
                GridView.count(
                  padding: const EdgeInsets.symmetric(vertical: 26.0),
                  shrinkWrap: true,
                  primary: false,
                  mainAxisSpacing: 20,
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  children: <Widget>[
                    CircularProgressItem(
                      icon: SvgPicture.asset('assets/images/citizenship/reputation.svg'),
                      totalStep: citizen_required_reputation,
                      currentStep: _reputation,
                      circleRadius: 30,
                      title: 'Reputation Score'.i18n,
                      titleStyle: Theme.of(context).textTheme.subtitle3,
                      rate: '$_reputation/$citizen_required_reputation',
                      rateStyle: Theme.of(context).textTheme.subtitle1!,
                    ),
                    CircularProgressItem(
                      icon: SvgPicture.asset('assets/images/citizenship/community.svg'),
                      totalStep: citizen_required_residents_invited * 100,
                      currentStep: _residents,
                      circleRadius: 30,
                      title: 'Residents Invited'.i18n,
                      titleStyle: Theme.of(context).textTheme.subtitle3,
                      rate: '${_residents ~/ 100}/$citizen_required_residents_invited',
                      rateStyle: Theme.of(context).textTheme.subtitle1!,
                    ),
                    CircularProgressItem(
                      icon: SvgPicture.asset('assets/images/citizenship/age.svg'),
                      totalStep: citizen_required_account_age,
                      currentStep: _age,
                      circleRadius: 30,
                      title: 'Account Age'.i18n,
                      titleStyle: Theme.of(context).textTheme.subtitle3,
                      rate: '$_age/$citizen_required_account_age',
                      rateStyle: Theme.of(context).textTheme.subtitle1!,
                    ),
                    CircularProgressItem(
                      icon: SvgPicture.asset('assets/images/citizenship/planted.svg'),
                      totalStep: citizen_required_planted_seeds,
                      currentStep: _seeds,
                      circleRadius: 30,
                      title: 'Planted Seeds'.i18n,
                      titleStyle: Theme.of(context).textTheme.subtitle3,
                      rate: '$_seeds/$citizen_required_planted_seeds',
                      rateStyle: Theme.of(context).textTheme.subtitle1!,
                    ),
                    CircularProgressItem(
                      icon: SvgPicture.asset('assets/images/citizenship/transaction.svg'),
                      totalStep: citizen_required_seeds_transactions,
                      currentStep: _transactions,
                      circleRadius: 30,
                      title: 'Transactions with Seeds'.i18n,
                      titleStyle: Theme.of(context).textTheme.subtitle3,
                      rate: '${_transactions}/$citizen_required_seeds_transactions',
                      rateStyle: Theme.of(context).textTheme.subtitle1!,
                    ),
                    CircularProgressItem(
                      icon: SvgPicture.asset('assets/images/citizenship/community.svg'),
                      totalStep: citizen_required_visitors_invited,
                      currentStep: _visitors,
                      circleRadius: 30,
                      title: 'Invited Users'.i18n,
                      titleStyle: Theme.of(context).textTheme.subtitle3,
                      rate: '${_visitors ~/ 100}/$citizen_required_visitors_invited',
                      rateStyle: Theme.of(context).textTheme.subtitle1!,
                    ),
                  ],
                ),
              ],
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
