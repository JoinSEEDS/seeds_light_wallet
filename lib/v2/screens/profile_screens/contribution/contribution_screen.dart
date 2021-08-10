import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/v2/components/circular_progress_item.dart';
import 'package:seeds/i18n/contribution.18n.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

/// CONTRIBUTION SCREEN
class ContributionScreen extends StatefulWidget {
  const ContributionScreen({Key? key}) : super(key: key);

  @override
  _ContributionScreenState createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _contributionAnimation,
      _communityAnimation,
      _reputationAnimation,
      _seedsAnimation,
      _transactionsAnimation;
  int _contribution = 0, _community = 0, _reputation = 0, _seeds = 0, _transactions = 0;

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
    final scores = ModalRoute.of(context)!.settings.arguments;
    return BlocProvider(
      create: (_) => ContributionBloc()..add(SetScores(score: scores as ScoresViewModel?)),
      child: Scaffold(
        appBar: AppBar(title: Text('Contribution Score'.i18n)),
        body: BlocConsumer<ContributionBloc, ContributionState>(
          listenWhen: (previous, current) =>
              previous.pageState != PageState.success && current.pageState == PageState.success,
          listener: (context, state) {
            _contributionAnimation =
                Tween<double>(begin: 0, end: (state.score!.contributionScore?.value ?? 0).toDouble())
                    .animate(_controller)
                      ..addListener(() {
                        setState(() => _contribution = _contributionAnimation.value.toInt());
                      });
            _communityAnimation =
                Tween<double>(begin: 0, end: (state.score!.communityScore?.value ?? 0).toDouble()).animate(_controller)
                  ..addListener(() {
                    setState(() => _community = _communityAnimation.value.toInt());
                  });
            _reputationAnimation =
                Tween<double>(begin: 0, end: (state.score!.reputationScore?.value ?? 0).toDouble()).animate(_controller)
                  ..addListener(() {
                    setState(() => _reputation = _reputationAnimation.value.toInt());
                  });
            _seedsAnimation =
                Tween<double>(begin: 0, end: (state.score!.plantedScore?.value ?? 0).toDouble()).animate(_controller)
                  ..addListener(() {
                    setState(() => _seeds = _seedsAnimation.value.toInt());
                  });
            _transactionsAnimation =
                Tween<double>(begin: 0, end: (state.score!.transactionScore?.value ?? 0).toDouble())
                    .animate(_controller)
                      ..addListener(() {
                        setState(() => _transactions = _transactionsAnimation.value.toInt());
                      });
            _controller.forward();
          },
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return ListView(
                  padding: const EdgeInsets.only(top: 16.0),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularStepProgressIndicator(
                          totalSteps: 99,
                          currentStep: _contribution,
                          stepSize: 2.5,
                          selectedColor: AppColors.green1,
                          unselectedColor: AppColors.darkGreen2,
                          padding: 0,
                          width: 195,
                          height: 195,
                          selectedStepSize: 2.5,
                          roundedCap: (_, __) => true,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Contribution'.i18n,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.headline7),
                                const SizedBox(height: 8.0),
                                Text('$_contribution/99', style: Theme.of(context).textTheme.headline3),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    GridView.count(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      shrinkWrap: true,
                      primary: false,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 25,
                      crossAxisCount: 2,
                      children: <Widget>[
                        CircularProgressItem(
                          icon: SvgPicture.asset('assets/images/contribution/community.svg'),
                          totalStep: 99,
                          currentStep: _community,
                          circleRadius: 40,
                          title: 'Community'.i18n,
                          titleStyle: Theme.of(context).textTheme.buttonLowEmphasis,
                          rate: '$_community',
                          rateStyle: Theme.of(context).textTheme.headline4!,
                        ),
                        CircularProgressItem(
                          icon: SvgPicture.asset('assets/images/contribution/reputation.svg'),
                          totalStep: 99,
                          currentStep: _reputation,
                          circleRadius: 40,
                          title: 'Reputation'.i18n,
                          titleStyle: Theme.of(context).textTheme.buttonLowEmphasis,
                          rate: '$_reputation',
                          rateStyle: Theme.of(context).textTheme.headline4!,
                        ),
                        CircularProgressItem(
                          icon: SvgPicture.asset('assets/images/contribution/planted.svg'),
                          totalStep: 99,
                          currentStep: _seeds,
                          circleRadius: 40,
                          title: 'Planted'.i18n,
                          titleStyle: Theme.of(context).textTheme.buttonLowEmphasis,
                          rate: '$_seeds',
                          rateStyle: Theme.of(context).textTheme.headline4!,
                        ),
                        CircularProgressItem(
                          icon: SvgPicture.asset('assets/images/contribution/transaction.svg'),
                          totalStep: 99,
                          currentStep: _transactions,
                          circleRadius: 40,
                          title: 'Transactions'.i18n,
                          titleStyle: Theme.of(context).textTheme.buttonLowEmphasis,
                          rate: '$_transactions',
                          rateStyle: Theme.of(context).textTheme.headline4!,
                        ),
                      ],
                    ),
                  ],
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
