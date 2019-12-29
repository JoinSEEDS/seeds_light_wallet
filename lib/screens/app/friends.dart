import 'package:flutter/material.dart';
import 'package:seeds/constants/custom_colors.dart';
import 'package:seeds/services/http_service/http_service.dart';
import 'package:seeds/services/http_service/invite_model.dart';
import 'package:seeds/widgets/progress_bar.dart';
import 'package:seeds/widgets/seeds_button.dart';

class Friends extends StatelessWidget {
  Widget createInviteWidget(InviteModel model) {
    return Container(
      child: ListTile(
          title: Text("Sow: " +
              model.sowQuantity +
              " Transfer: " +
              model.transferQuantity),
          trailing: Container(
            width: 230,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SeedsButton("Copy"),
                SizedBox(width: 10),
                SeedsButton("Cancel")
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: CustomColors.Green),
              ),
            ),
            margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
            padding: EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Build community - gain reputation",
                  style: TextStyle(
                    fontFamily: "worksans",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: HttpService().getInvites(),
            builder: (context, snapshot) => snapshot.data != null ? ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => createInviteWidget(snapshot.data[index]),
              itemCount: snapshot.data.length
            ) : ProgressBar()
          )
        ],
      ),
    );
  }
}
