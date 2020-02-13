import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/planted_notifier.dart';
import 'package:seeds/providers/notifiers/voice_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:seeds/widgets/main_card.dart';
import 'package:shimmer/shimmer.dart';

class Overview extends StatefulWidget {
  const Overview({
    Key key,
  }) : super(key: key);

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshData();
  }

  Future<void> refreshData() async {
    await Future.wait(<Future<dynamic>>[
      BalanceNotifier.of(context).fetchBalance(),
      VoiceNotifier.of(context).fetchBalance(),
      PlantedNotifier.of(context).fetchBalance(),
    ]);
  }

  void onVote() {
    NavigationService.of(context).navigateTo(Routes.proposals);
  }

  void onInvite() {
    NavigationService.of(context).navigateTo(Routes.createInvite);
  }

  void onPlant() {
    NavigationService.of(context).navigateTo(Routes.plantSeeds);
  }

  void onBuy() {
    NavigationService.of(context).navigateTo(Routes.buySeeds);
  }

  Widget buildCategory(
    String title,
    String subtitle,
    String iconName,
    String balanceTitle,
    String balanceValue,
    Function onTap,
  ) {
    return MainCard(
      onPressed: onTap,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                margin: EdgeInsets.only(right: 15),
                child: SvgPicture.asset(iconName),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                balanceTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: balanceValue != null
                    ? Text(
                        balanceValue,
                        style: TextStyle(fontSize: 14),
                      )
                    : Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Container(
                          width: 80.0,
                          height: 10,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String balance = BalanceNotifier.of(context).balance?.quantity;
    String planted = PlantedNotifier.of(context).balance?.quantity;
    String voice = VoiceNotifier.of(context).balance?.amount?.toString();

    return RefreshIndicator(
      onRefresh: refreshData,
      child: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                buildCategory(
                  'Proposals - Vote',
                  'Tap to participate in voting',
                  'assets/images/governance.svg',
                  'Trust Tokens',
                  voice,
                  onVote,
                ),
                Divider(),
                buildCategory(
                  'Community - Invite',
                  'Tap to generate invite',
                  'assets/images/community.svg',
                  'Liquid Seeds',
                  balance?.seedsFormatted,
                  onInvite,
                ),
                Divider(),
                buildCategory(
                  'Harvest - Plant',
                  'Tap to plant Seeds',
                  'assets/images/harvest.svg',
                  'Planted Seeds',
                  planted?.seedsFormatted,
                  onPlant,
                ),
                Divider(),
                buildCategory(
                  'Exchange - Buy',
                  'Tap to buy Seeds',
                  'assets/images/exchange.svg',
                  'Liquid TLOS',
                  '0',
                  onBuy,
                ),
              ],
            )),
      ),
    );
  }
}
