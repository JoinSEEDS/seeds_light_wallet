import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seeds/v2/components/profile_avatar.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:seeds/v2/components/circular_progress_item.dart';
import 'package:seeds/i18n/citizenship.18n.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';

/// CITIZENSHIP SCREEN
class CitizenshipScreen extends StatefulWidget {
  const CitizenshipScreen();

  @override
  _CitizenshipScreenState createState() => _CitizenshipScreenState();
}

class _CitizenshipScreenState extends State<CitizenshipScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _timeLineAnimation,
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
    _visitorsAnimation = Tween<double>(begin: 0, end: 100).animate(_controller)
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
    _transactionsAnimation = Tween<double>(begin: 0, end: 300).animate(_controller)
      ..addListener(() {
        setState(() => _transactions = _transactionsAnimation.value.toInt());
      });
    _friendsAnimation = Tween<double>(begin: 0, end: 100).animate(_controller)
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
    final ProfileModel profile = ModalRoute.of(context)!.settings.arguments as ProfileModel;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ProfileAvatar(
                    size: 100,
                    image: profile.image,
                    nickname: profile.nickname,
                    account: profile.account!,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    profile.nickname ?? '',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    profile.status ?? '',
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
                totalStep: 83,
                currentStep: _reputation,
                circleRadius: 30,
                title: 'Reputation Score'.i18n,
                titleStyle: Theme.of(context).textTheme.subtitle3,
                rate: '83/$_reputation',
                rateStyle: Theme.of(context).textTheme.subtitle1!,
              ),
              CircularProgressItem(
                icon: SvgPicture.asset('assets/images/citizenship/community.svg'),
                totalStep: 100,
                currentStep: _visitors,
                circleRadius: 30,
                title: 'Visitors Invited'.i18n,
                titleStyle: Theme.of(context).textTheme.subtitle3,
                rate: '${_visitors ~/ 100}/1',
                rateStyle: Theme.of(context).textTheme.subtitle1!,
              ),
              CircularProgressItem(
                icon: SvgPicture.asset('assets/images/citizenship/age.svg'),
                totalStep: 291,
                currentStep: _age,
                circleRadius: 30,
                title: 'Account Age'.i18n,
                titleStyle: Theme.of(context).textTheme.subtitle3,
                rate: '291/$_age',
                rateStyle: Theme.of(context).textTheme.subtitle1!,
              ),
              CircularProgressItem(
                icon: SvgPicture.asset('assets/images/citizenship/planted.svg'),
                totalStep: 213,
                currentStep: _seeds,
                circleRadius: 30,
                title: 'Planted Seeds'.i18n,
                titleStyle: Theme.of(context).textTheme.subtitle3,
                rate: '213/$_seeds',
                rateStyle: Theme.of(context).textTheme.subtitle1!,
              ),
              CircularProgressItem(
                icon: SvgPicture.asset('assets/images/citizenship/transaction.svg'),
                totalStep: 500,
                currentStep: _transactions,
                circleRadius: 30,
                title: 'Transactions with Seeds'.i18n,
                titleStyle: Theme.of(context).textTheme.subtitle3,
                rate: '${_transactions ~/ 100}/5',
                rateStyle: Theme.of(context).textTheme.subtitle1!,
              ),
              CircularProgressItem(
                icon: SvgPicture.asset('assets/images/citizenship/community.svg'),
                totalStep: 300,
                currentStep: _friends,
                circleRadius: 30,
                title: 'Friends Invited'.i18n,
                titleStyle: Theme.of(context).textTheme.subtitle3,
                rate: '${_friends ~/ 100}/3',
                rateStyle: Theme.of(context).textTheme.subtitle1!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
