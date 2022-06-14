import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegates_tab/delegates_tab.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/delegators_tab/delegators_tab.dart';

class DelegateScreen extends StatelessWidget {
  const DelegateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          shape: const Border(bottom: BorderSide(color: AppColors.lightGreen2)),
          bottom: TabBar(
            unselectedLabelStyle: Theme.of(context).textTheme.buttonOpacityEmphasis,
            labelStyle: Theme.of(context).textTheme.buttonLowEmphasis,
            tabs: [
              const Padding(padding: EdgeInsets.all(16.0), child: Text("Delegates")),
              const Padding(padding: EdgeInsets.all(16.0), child: Text("Delegators"))
            ],
          ),
          title: const Text("Delegates"),
        ),
        body: const SafeArea(child: TabBarView(children: [DelegatesTab(), DelegatorsTab()])),
      ),
    );
  }
}
