import 'package:flutter/material.dart';

import 'customColors.dart';
import 'transferForm.dart';
import 'members.dart';

class Transfer extends StatelessWidget {
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
                  title: Text("Activity Rating: 30/100"),
                  subtitle: Text("Send transactions to increase your activity"),
                ),
              ),
          // _usersTitle(),
          SizedBox(height: 5),
          _usersList(context),
        ],
      ),
    );
  }

  Widget _usersTitle() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 20),
      child: Text(
        'Users',
        style: TextStyle(
          fontFamily: "worksans",
          fontSize: 16,
          color: CustomColors.Grey,
        ),
      ),
    );
  }

  Widget _usersList(context) {
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
                backgroundImage: AssetImage(user["avatar"]),
              ),
            ),
            title: Text(
              user["fullName"],
              style: TextStyle(fontFamily: "worksans"),
            ),
            subtitle: Text(
              user["accountName"],
              style: TextStyle(fontFamily: "worksans"),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TransferForm(
                    user["fullName"],
                    user["accountName"],
                    user["avatar"],
                  ),
                ),
              );
            },
          );
        });
  }
}
