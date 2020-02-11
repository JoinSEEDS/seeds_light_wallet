import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/notifiers/invites_notifier.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/progress_bar.dart';
import 'package:seeds/widgets/reactive_widget.dart';

class Invites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        title: Text(
          "Invites",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: ReactiveWidget<InvitesNotifier>(
          builder: (context, model, child) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Members invited by you: ",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        fontFamily: "worksans"),
                  ),
                  Expanded(
                    child: model.invitedMembers != null
                        ? ListView.builder(
                            itemCount: model.invitedMembers.length,
                            itemBuilder: (ctx, index) {
                              var member = model.invitedMembers[index];

                              return Text(member,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "worksans"));

                              // return ListTile(
                              //   leading: member.image,
                              //   title: member.nickname,
                              //   subtitle: member.accountName,
                              //   trailing: Column(
                              //     children: <Widget>[
                              //       Text("Sow: ${member.sow}"),
                              //       Text("Transfer: ${member.transfer}")
                              //     ],
                              //   ),
                              // );
                            },
                          )
                        : ProgressBar(),
                  ),
                  Divider(
                    thickness: 3,
                  ),
                  Text(
                    "Active invites: ",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: "worksans",
                    ),
                  ),
                  Expanded(
                    child: model.activeInvites != null
                        ? ListView.builder(
                            itemCount: model.activeInvites.length,
                            itemBuilder: (ctx, index) {
                              var invite = model.activeInvites[index];

                              print(invite.inviteId);

                              return ListTile(
                                leading: Icon(Icons.copyright),
                                title: Text("${invite.inviteHash} (copy)"),
                                trailing: Column(
                                  children: <Widget>[
                                    Text("Sow: ${invite.sowQuantity}"),
                                    Text(
                                        "Transfer: ${invite.transferQuantity}"),
                                  ],
                                ),
                              );
                            },
                          )
                        : Text("No active invites"),
                  ),
                  MainButton(
                    title: "Create new invite",
                  ),
                ],
              ),
            );
          },
          model: InvitesNotifier()..init(http: Provider.of(context)),
          onModelReady: (model) => model.fetchInvites(),
        ),
      ),
    );
  }
}
