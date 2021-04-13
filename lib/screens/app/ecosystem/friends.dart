// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/v2/constants/app_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/notifiers/invites_notifier.dart';
import 'package:seeds/widgets/progress_bar.dart';
import 'package:seeds/widgets/reactive_widget.dart';
import 'package:seeds/widgets/seeds_button.dart';
import 'package:seeds/i18n/ecosystem.i18n.dart';

class Friends extends StatelessWidget {
  Widget buildInviteWidget(InviteModel model) {
    return Container(
      child: ListTile(
          title: Text("Sow: %s Transfer: %s".i18n.fill([model.sowQuantity, model.transferQuantity])),
          trailing: Container(
            width: 230,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SeedsButton("Copy".i18n),
                SizedBox(width: 10),
                SeedsButton("Cancel".i18n)
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Your invites".i18n,
          style: TextStyle(fontFamily: "worksans", color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: AppColors.green),
                ),
              ),
              margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Build community - gain reputation".i18n,
                    style: TextStyle(
                      fontFamily: "worksans",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            ReactiveWidget(
              model: InvitesNotifier()..init(http: Provider.of(context)),
              onModelReady: (model) => model.fetchInvites(),
              builder: (ctx, model, child) =>
                  model == null || model.invites == null
                      ? ProgressBar()
                      : ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) =>
                              buildInviteWidget(model.invites[index]),
                          itemCount: model.invites.length,
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
