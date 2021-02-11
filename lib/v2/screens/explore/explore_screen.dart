import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/v2/screens/explore/interactor/explore_bloc.dart';
import 'package:seeds/v2/screens/explore/interactor/viewmodels/events.dart';

/// Explore SCREEN
class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreBloc()..add(LoadExplore(userName: "raul11111111")),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              ExploreInfoCard(
                callback: () {},
                title: "Invite",
                amount: "3,245",
                icon: SvgPicture.asset("assets/images/explore/person_send_invite.svg", color: AppColors.white,),
                amountLabel: "Available Seeds",
              ),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ExploreInfoCard(
                      callback: () {},
                      title: "Plant",
                      amount: "245",
                      icon: SvgPicture.asset("assets/images/explore/plant_seed.svg"),
                      amountLabel: "Planted Seeds",
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ExploreInfoCard(
                      callback: () {},
                      title: "Vote",
                      amount: "2",
                      icon: SvgPicture.asset("assets/images/explore/thumb_up.svg"),
                      amountLabel: "Trust Tokens",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ExploreInfoCard(
                      callback: () {},
                      title: "Get Seeds",
                      amount: "15",
                      amountLabel: "Seeds",
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ExploreInfoCard(
                      callback: () {},
                      title: "Hypha DHO",
                      amount: "5",
                      amountLabel: "Hypha",
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ExploreInfoCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final String amount;
  final String amountLabel;
  final GestureTapCallback callback;

  const ExploreInfoCard({
    Key key,
    @required this.title,
    this.icon,
    @required this.amount,
    @required this.amountLabel,
    @required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: () {},
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.jungle,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: Text(title, style: Theme.of(context).textTheme.headline8)),
                icon != null ? icon : SizedBox.shrink(),
              ],
            ),
            SizedBox(height: 24),
            Text(amount, style: Theme.of(context).textTheme.headline8),
            SizedBox(height: 4),
            Text(amountLabel, style: Theme.of(context).textTheme.subtitle3),
          ],
        ),
      ),
    );
  }
}
