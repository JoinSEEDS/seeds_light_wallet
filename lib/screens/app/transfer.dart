import 'package:flutter/material.dart';

import 'package:seeds/constants/custom_colors.dart';
import 'package:seeds/widgets/progress_bar.dart';
import 'package:seeds/services/http_service.dart';

import 'transfer_form.dart';

class Transfer extends StatelessWidget {
  final String accountName;

  Transfer(this.accountName);

  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
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
              subtitle: Text("Send more transactions to increase your score and upgrade your status"),
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
    return FutureBuilder(
        future: httpService.getMembers(),
        builder: (BuildContext context, AsyncSnapshot<List<MemberModel>> snapshot) {
          if (snapshot.hasData) {
            final List<MemberModel> members = snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: members.length,
                itemBuilder: (ctx, index) {
                  final user = members[index];

                  return ListTile(
                    leading: Container(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(user.image),
                      ),
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
                            this.accountName,
                            user.nickname,
                            user.account,
                            user.image,
                          ),
                        ),
                      );
                    },
                  );
                });
          } else {
            return ProgressBar();
          }
        });
  }
}
