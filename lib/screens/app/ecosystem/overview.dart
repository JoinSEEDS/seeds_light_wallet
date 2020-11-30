import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/i18n/ecosystem.i18n.dart';
import 'package:seeds/providers/notifiers/balance_notifier.dart';
import 'package:seeds/providers/notifiers/dho_notifier.dart';
import 'package:seeds/providers/notifiers/planted_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/notifiers/telos_balance_notifier.dart';
import 'package:seeds/providers/notifiers/voice_notifier.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:seeds/widgets/main_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

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
      TelosBalanceNotifier.of(context).fetchBalance(),
      DhoNotifier.of(context).refresh(),
    ]);
  }

  void onGet() {
    String userAccount = SettingsNotifier.of(context).accountName;
    UrlLauncher.launch("https://www.joinseeds.com/buy-seeds?acc=$userAccount",
        forceSafariVC: false, forceWebView: false);
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

  void onDHO() {
    NavigationService.of(context).navigateTo(Routes.dho);
  }

  void onGuardians() {
    NavigationService.of(context).navigateTo(Routes.guardians);
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
    return RefreshIndicator(
      onRefresh: refreshData,
      child: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Consumer<BalanceNotifier>(
                  builder: (ctx, model, _) => buildCategory(
                    'Invite'.i18n,
                    'Tap to send an invite'.i18n,
                    'assets/images/community.svg',
                    'Available Seeds'.i18n,
                    model?.balance?.quantity?.seedsFormatted,
                    onInvite,
                  ),
                ),
                Consumer<VoiceNotifier>(
                  builder: (ctx, model, _) => buildCategory(
                    'Vote'.i18n,
                    'Tap to participate'.i18n,
                    'assets/images/governance.svg',
                    'Trust Tokens'.i18n,
                    valueString(model?.campaignBalance?.amount) +
                        "/" +
                        valueString(model?.allianceBalance?.amount),
                    onVote,
                  ),
                ),
                Consumer<PlantedNotifier>(
                  builder: (ctx, model, _) => buildCategory(
                    'Plant'.i18n,
                    'Tap to plant Seeds'.i18n,
                    'assets/images/harvest.svg',
                    'Planted Seeds'.i18n,
                    model?.balance?.quantity?.seedsFormatted,
                    onPlant,
                  ),
                ),
                Consumer<BalanceNotifier>(
                  builder: (ctx, model, _) => buildCategory(
                    'Get Seeds'.i18n,
                    'Tap to get Seeds'.i18n,
                    'assets/images/harvest.svg',
                    'Available Seeds'.i18n,
                    model?.balance?.quantity?.seedsFormatted,
                    onGet,
                  ),
                ),
                buildCategory(
                    'Guardians',
                    'Protect your account sharing trust with friends',
                    'assets/images/harvest.svg',
                    '',
                    '',
                    onGuardians),
                Consumer<DhoNotifier>(
                  builder: (ctx, model, _) => model.isDhoMember
                      ? buildCategory(
                          'Hypha DHO',
                          'Explore Decentralized Human Organization',
                          'assets/images/harvest.svg',
                          '',
                          '',
                          onDHO)
                      : Container(),
                ),
              ],
            )),
      ),
    );
  }

  String valueString(int amount) {
    return amount == null ? "-" : "$amount";
  }
}
