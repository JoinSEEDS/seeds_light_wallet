import 'package:flutter/material.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/seeds_button.dart';

class Overview extends StatelessWidget {
  const Overview({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          child: ListTile(
            leading: Icon(Icons.description),
            trailing: SeedsButton("PROPOSALS", () {
              NavigationService.of(context).navigateTo(Routes.proposals);
            }, false, 200),
            title: Text("Proposals"),
            subtitle: Text(
              "Participate in governance and decide on money distribution - for regeneration instead of destruction",
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.child_friendly),
            trailing: SeedsButton("INVITES", () {
              NavigationService.of(context).navigateTo(Routes.invites);
            }, false, 200),
            title: Text("Community"),
            subtitle: Text(
                "Invite friends to regenerative economy and support others in their dreams - get rewarded for their achievements"),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.close),
            trailing: SeedsButton("HYPHA", () {}, false, 200),
            title: Text("Hypha"),
            subtitle: Text(
                "Explore Hypha DAO organization behind Seeds and apply for open roles - get paid for your contributions"),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.settings_backup_restore),
            trailing: SeedsButton("HARVEST", () {}, false, 200),
            title: Text("Harvest"),
            subtitle: Text(
                "Earn contribution score and get involved in harvest distribution"),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.settings_cell),
            trailing: SeedsButton("CONTRACTS", () {}, false, 200),
            title: Text("Contracts"),
            subtitle: Text(
                "Interact with custom smart contracts inside of ecosystem"),
          ),
        ),
      ],
    );
  }
}
