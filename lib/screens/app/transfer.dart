import 'package:flutter/material.dart';

import 'package:seeds/constants/custom_colors.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/viewmodels/members.dart';
import 'package:seeds/widgets/progress_bar.dart';
import 'package:seeds/services/http_service.dart';
import 'package:seeds/widgets/reactive_widget.dart';

import 'transfer_form.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart';

class Transfer extends StatefulWidget {
  final String accountName;

  Transfer(this.accountName);

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  "Send transactions - better than free",
                  style: TextStyle(
                    fontFamily: "worksans",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListTile(
              leading: Container(
                width: 42,
                child: Icon(
                  Icons.star_half,
                  color: CustomColors.Green,
                ),
              ),
              title: Text("You sent 5 transactions of 10 transactions"),
              subtitle: Text(
                  "Send more transactions to increase your score and upgrade your status"),
            ),
          ),
          // _usersTitle(),
          SizedBox(height: 5),
          _usersList(context),
        ],
      ),
    );
  }

  Widget _usersList(context) {
    print("rebuild users list");

    return ReactiveWidget(
      onModelReady: (model) => model.fetchMembers(),
      model: MembersModel(http: Provider.of<HttpService>(context)),
      builder: (context, model, child) => model != null && model.members != null
          ? ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: model.members.length,
              itemBuilder: (ctx, index) {
                final user = model.members[index];

                return ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            CachedNetworkImageProvider(user.image)),
                  ),
                  title: Text(
                    user.nickname,
                    style: TextStyle(fontFamily: "worksans"),
                  ),
                  subtitle: Text(
                    user.account,
                    style: TextStyle(fontFamily: "worksans"),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TransferForm(
                          this.widget.accountName,
                          user.nickname,
                          user.account,
                          user.image,
                        ),
                      ),
                    );
                  },
                );
              })
          : ProgressBar(),
    );
  }
}
