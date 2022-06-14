import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/circular_progress_item.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/i18n/profile_screens/contribution/contribution.i18n.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/contribution_bloc.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ContributionScreen extends StatefulWidget {
  const ContributionScreen({super.key});

  @override
  _ContributionScreenState createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _contributionAnimation;
  late Animation<double> _communityAnimation;
  late Animation<double> _reputationAnimation;
  late Animation<double> _seedsAnimation;
  late Animation<double> _transactionsAnimation;
  int _contribution = 0;
  int _community = 0;
  int _reputation = 0;
  int _seeds = 0;
  int _transactions = 0;

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
    return BlocProvider(
      create: (_) => ContributionBloc()..add(const FetchScores()),
      child: Scaffold(
        appBar: AppBar(title: Text('Contribution Score'.i18n)),
        body: BlocConsumer<ContributionBloc, ContributionState>(
          listenWhen: (previous, current) =>
              current.pageCommand != null ||
              previous.pageState != PageState.success && current.pageState == PageState.success,
          listener: (context, state) {
            if (state.pageCommand != null) {
              final pageCommand = state.pageCommand;
              BlocProvider.of<ContributionBloc>(context).add(const ClearContributionPageCommand());
              if (pageCommand is NavigateToScoreDetails) {
                NavigationService.of(context).navigateTo(Routes.contributionDetail, pageCommand);
              }
            }
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
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 16.0),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () => BlocProvider.of<ContributionBloc>(context)
                                .add(const ShowScoreDetails(ScoreType.contributionScore)),
                            child: CircularStepProgressIndicator(
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
                            onPressed: () => BlocProvider.of<ContributionBloc>(context)
                                .add(const ShowScoreDetails(ScoreType.communityScore)),
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
                            onPressed: () => BlocProvider.of<ContributionBloc>(context)
                                .add(const ShowScoreDetails(ScoreType.reputationScore)),
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
                            onPressed: () => BlocProvider.of<ContributionBloc>(context)
                                .add(const ShowScoreDetails(ScoreType.plantedScore)),
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
                            onPressed: () => BlocProvider.of<ContributionBloc>(context)
                                .add(const ShowScoreDetails(ScoreType.transactionScore)),
                          ),
                        ],
                      ),
                    ],
                  ),
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
