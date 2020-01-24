import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/services/links_service.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/screens/onboarding/show_invite.dart';
import 'package:seeds/widgets/overlay_popup.dart';
import 'package:seeds/widgets/seeds_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return OverlayPopup(
      title: "Import account / Scan Invite",
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
        padding: EdgeInsets.only(bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Do you have account?",
              style: TextStyle(
                fontFamily: "worksans",
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: SeedsButton(
                "Import private key",
                () {
                  NavigationService.of(context)
                      .navigateTo(Routes.importAccount);
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Do you have invite?",
              style: TextStyle(
                fontFamily: "worksans",
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: SeedsButton("Claim invite code", () {
                NavigationService.of(context).navigateTo(Routes.claimCode);
              }),
            ),
            // SizedBox(
            //   height: 40,
            //   width: MediaQuery.of(context).size.width,
            //   child: SeedsButton(
            //     "Scan QR Code",
            //     () {
            //       Navigator.of(context).pushReplacement(
            //         MaterialPageRoute(
            //           builder: (context) => ScanCode(),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(
              height: 40,
            ),
            Text(
              "You can ask for invite from other SEEDS member or subscribe for next campaign at joinseeds.com",
              style: TextStyle(
                color: Colors.black45,
                fontFamily: "worksans",
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Membership based on Web of Trust",
                style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "worksans",
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
