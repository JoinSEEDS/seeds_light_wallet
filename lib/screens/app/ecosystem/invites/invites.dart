import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/providers/notifiers/invites_notifier.dart';
import 'package:seeds/widgets/main_button.dart';
import 'package:seeds/widgets/progress_bar.dart';
import 'package:seeds/widgets/reactive_widget.dart';
import 'package:seeds/i18n/invites.i18n.dart';

class Invites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        title: Text(
          "Invites".i18n,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: ReactiveWidget<InvitesNotifier>(
          builder: (context, model, child) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Members invited by you:".i18n,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, fontFamily: "worksans"),
                  ),
                  Expanded(
                    child: model.invitedMembers != null
                        ? ListView.builder(
                            itemCount: model.invitedMembers!.length,
                            itemBuilder: (ctx, index) {
                              var member = model.invitedMembers![index]!;

                              return Text(member,
                                  style: const TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.w400, fontFamily: "worksans"));
                            },
                          )
                        : ProgressBar(),
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  Text(
                    "Active invites:".i18n,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: "worksans",
                    ),
                  ),
                  Expanded(
                    child: model.activeInvites != null
                        ? ListView.builder(
                            itemCount: model.activeInvites!.length,
                            itemBuilder: (ctx, index) {
                              var invite = model.activeInvites![index];

                              return ListTile(
                                leading: const Icon(Icons.copyright),
                                title: Text("%s (copy)".i18n.fill(["${invite.inviteHash}"])),
                                trailing: Column(
                                  children: <Widget>[
                                    Text("Sow: %s".i18n.fill(["${invite.sowQuantity}"])),
                                    Text("Transfer: %s".i18n.fill(["${invite.transferQuantity}"])),
                                  ],
                                ),
                              );
                            },
                          )
                        : Text("No active invites".i18n),
                  ),
                  MainButton(
                    title: "Create new invite".i18n,
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
