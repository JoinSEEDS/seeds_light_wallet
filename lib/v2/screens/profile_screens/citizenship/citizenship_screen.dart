import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:seeds/v2/screens/profile_screens/citizenship/components/citizenship_progress_item.dart';
import 'package:seeds/i18n/citizenship.18n.dart';

/// CITIZENSHIP SCREEN
class CitizenshipScreen extends StatefulWidget {
  const CitizenshipScreen();

  @override
  _CitizenshipScreenState createState() => _CitizenshipScreenState();
}

class _CitizenshipScreenState extends State<CitizenshipScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _timeLineAnimation,
      _reputationAnimation,
      _visitorsAnimation,
      _ageAnimation,
      _seedsAnimation,
      _transactionsAnimation,
      _friendsAnimation;
  int _timeLine = 0, _reputation = 0, _visitors = 0, _age = 0, _seeds = 0, _transactions = 0, _friends = 0;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _timeLineAnimation = Tween<double>(begin: 0, end: 85).animate(_controller)
      ..addListener(() {
        setState(() => _timeLine = _timeLineAnimation.value.toInt());
      });
    _reputationAnimation = Tween<double>(begin: 0, end: 50).animate(_controller)
      ..addListener(() {
        setState(() => _reputation = _reputationAnimation.value.toInt());
      });
    _visitorsAnimation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() => _visitors = _visitorsAnimation.value.toInt());
      });
    _ageAnimation = Tween<double>(begin: 0, end: 59).animate(_controller)
      ..addListener(() {
        setState(() => _age = _ageAnimation.value.toInt());
      });
    _seedsAnimation = Tween<double>(begin: 0, end: 200).animate(_controller)
      ..addListener(() {
        setState(() => _seeds = _seedsAnimation.value.toInt());
      });
    _transactionsAnimation = Tween<double>(begin: 0, end: 3).animate(_controller)
      ..addListener(() {
        setState(() => _transactions = _transactionsAnimation.value.toInt());
      });
    _friendsAnimation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() => _friends = _friendsAnimation.value.toInt());
      });
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const ProfileAvatar(
                      size: 100,
                      image: '',
                      nickname: 'raul',
                      account: 'raul',
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Raul',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Resident',
                      style: Theme.of(context).textTheme.headline7LowEmphasis,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
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
                        Text('Progress Timeline'.i18n, style: Theme.of(context).textTheme.buttonHighEmphasis),
                        Text('$_timeLine%', style: Theme.of(context).textTheme.subtitle4),
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
            const SizedBox(height: 26.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CitizenshipProgressItem(
                  icon: SvgPicture.asset('assets/images/citizenship/reputation.svg'),
                  totalStep: 83,
                  currentStep: _reputation,
                  title: 'Reputation Score'.i18n,
                  rate: '83/$_reputation',
                ),
                CitizenshipProgressItem(
                  icon: SvgPicture.asset('assets/images/citizenship/community.svg'),
                  totalStep: 1,
                  currentStep: _visitors,
                  title: 'Visitors Invited'.i18n,
                  rate: '$_visitors/1',
                ),
                CitizenshipProgressItem(
                  icon: SvgPicture.asset('assets/images/citizenship/age.svg'),
                  totalStep: 291,
                  currentStep: _age,
                  title: 'Account Age'.i18n,
                  rate: '291/$_age',
                ),
              ],
            ),
            const SizedBox(height: 35.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CitizenshipProgressItem(
                  icon: SvgPicture.asset('assets/images/citizenship/planted.svg'),
                  totalStep: 213,
                  currentStep: _seeds,
                  title: 'Planted Seeds'.i18n,
                  rate: '213/$_seeds',
                ),
                CitizenshipProgressItem(
                  icon: SvgPicture.asset('assets/images/citizenship/transaction.svg'),
                  totalStep: 5,
                  currentStep: _transactions,
                  title: 'Transactions with Seeds'.i18n,
                  rate: '$_transactions/5',
                ),
                CitizenshipProgressItem(
                  icon: SvgPicture.asset('assets/images/citizenship/community.svg'),
                  totalStep: 3,
                  currentStep: _friends,
                  title: 'Friends Invited'.i18n,
                  rate: '$_friends/3',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
