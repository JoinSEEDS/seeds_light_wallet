import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teloswallet/generated/r.dart';
import 'package:teloswallet/providers/services/navigation_service.dart';
import 'package:teloswallet/widgets/main_card.dart';

class Tools extends StatefulWidget {
  const Tools({
    Key key,
  }) : super(key: key);

  @override
  _ToolsState createState() => _ToolsState();
}

class _ToolsState extends State<Tools> {
  void onResources() {
    NavigationService.of(context).navigateTo(Routes.manageResources);
  }

  void onAccounts() {
    NavigationService.of(context).navigateTo(Routes.manageAccounts);
  }

  void onEndpoint() {
    NavigationService.of(context).navigateTo(Routes.changeEndpoint);
  }

  Widget buildCategory(
    String title,
    String iconName,
    Function onTap,
  ) {
    return MainCard(
      onPressed: onTap,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 24,
            height: 24,
            margin: EdgeInsets.only(right: 15),
            child: SvgPicture.asset(iconName),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              buildCategory(
                'Manage Resources',
                R.resources,
                onResources,
              ),
              Divider(),
              buildCategory(
                'Manage Accounts',
                R.accounts,
                onAccounts,
              ),
              Divider(),
              buildCategory(
                'Change Endpoint',
                R.endpoint,
                onEndpoint,
              ),
            ],
          )),
    );
  }
}
