import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/providers/services/links_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/onboarding/show_invite.dart';
import 'package:provider/provider.dart';
import 'package:seeds/widgets/main_button.dart';

class OnboardingMethodChoice extends StatefulWidget {
  @override
  _OnboardingMethodChoiceState createState() => _OnboardingMethodChoiceState();
}

class _OnboardingMethodChoiceState extends State<OnboardingMethodChoice> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, this.acceptInviteLink);
  }

  void acceptInviteLink() async {
    final Map<String, String> queryParams =
        await Provider.of<LinksService>(context, listen: false)
            .parseInviteLink();

    NavigationService.of(context).navigateTo(
      Routes.showInvite,
      ShowInviteArguments(
        queryParams["inviterAccount"],
        queryParams["inviteSecret"],
      ),
      true,
    );
  }

  void onImport() {
                  NavigationService.of(context).navigateTo(Routes.importAccount);
  }

  void onInvite() {
                NavigationService.of(context).navigateTo(Routes.claimCode);

  }

  Widget buildHeader() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.35,
      padding: EdgeInsets.only(
        left: width * 0.23, 
        right: width * 0.23, 
        top: MediaQuery.of(context).padding.top,
        bottom: 30
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.32],
          colors: AppColors.gradient
        )
      ),
      child: Image(
        image: AssetImage('assets/images/logo_title.png'),
      ),
    );
  }

  Widget buildGroup(String text, String title, Function onPressed) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 7),
          child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18
            ),
          ),
        ),
        Icon(Icons.arrow_downward, 
          color: AppColors.blue,
          size: 25
        ),
        MainButton(
          margin: EdgeInsets.only(left: 33, right: 33, top: 10),
          title: title,
          onPressed: onPressed,
        ),
      ],
    );
  }

  Widget buildBottom() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'You can ask for invite at ',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey
                  )
                ),
                TextSpan(
                  text: 'joinseeds.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.blue
                  )
                ),
                TextSpan(
                  text: '\n\nMembership based on Web of Trust',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  )
                )
              ]
            )
          )
        ],
      )
    );
  }

  Widget buildCard() {
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: height * 0.35 - 30),
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildGroup('If you have an account\nclick here', 'Import private key', onImport),
          buildGroup('If you have an invite\nclick here', 'Claim invite code', onInvite),
          buildBottom()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          buildHeader(),
          buildCard(),
        ],
      ),
    );
  }
}
