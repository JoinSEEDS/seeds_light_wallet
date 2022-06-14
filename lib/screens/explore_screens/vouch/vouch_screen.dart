import 'package:flutter/material.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/screens/explore_screens/vouch/sponsor_tab/sponsor_tab.dart';
import 'package:seeds/screens/explore_screens/vouch/vouched_tab/vouched_tab.dart';

class VouchScreen extends StatelessWidget {
  const VouchScreen({super.key});

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
              const Padding(padding: EdgeInsets.only(bottom: 16), child: Text("Vouched for")),
              const Padding(padding: EdgeInsets.only(bottom: 16), child: Text("Vouched for me"))
            ],
          ),
          title: const Text("Vouch"),
        ),
        body: const TabBarView(children: [VouchedTab(), SponsorTab()]),
      ),
    );
  }
}
