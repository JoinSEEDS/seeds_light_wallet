import 'package:flutter/material.dart';
import 'package:seeds/screens/profile_screens/contribution/interactor/viewmodels/page_commands.dart';

class ContributionDetailScreen extends StatelessWidget {
  const ContributionDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreDetails = ModalRoute.of(context)?.settings.arguments as NavigateToScoreDetails?;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text(scoreDetails?.scoreType ?? ''),
              Text(scoreDetails?.score.toString() ?? ''),
              Text(scoreDetails?.title ?? ''),
              Text(scoreDetails?.subtitle ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}
