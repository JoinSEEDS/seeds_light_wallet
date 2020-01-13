import 'package:flutter/material.dart';

import 'package:seeds/constants/custom_colors.dart';
import 'package:seeds/viewmodels/auth.dart';
import 'package:seeds/viewmodels/members.dart';
import 'package:seeds/widgets/progress_bar.dart';
import 'package:seeds/services/http_service.dart';
import 'package:seeds/widgets/reactive_widget.dart';

import 'transfer_form.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:provider/provider.dart';

import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Transfer extends StatefulWidget {
  Transfer();

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _usersList(context),
        ),
      ],
    );
  }

  Widget _usersList(context) {
    print("rebuild users list");

    return Consumer<MembersModel>(builder: (ctx, model, _) {
      return model != null && model.members != null
          ? LiquidPullToRefresh(
              springAnimationDurationInMilliseconds: 500,
              showChildOpacityTransition: true,
              backgroundColor: CustomColors.LightGreen,
              color: CustomColors.LightBlue,
              onRefresh: () async {
                print("refresh");
                Provider.of<MembersModel>(context, listen: false)
                    .fetchMembers();
              },
              child: ListView.builder(
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
                            user.nickname,
                            user.account,
                            user.image,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          : ProgressBar();
    });
  }
}
