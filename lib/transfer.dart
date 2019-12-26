import 'dart:convert';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:seeds/progressBar.dart';

import 'customColors.dart';
import 'transferForm.dart';

class MemberModel {
  final String account;
  final String nickname;
  final String image;

  MemberModel({this.account, this.nickname, this.image});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
        account: json["account"],
        nickname: json["nickname"],
        image: json["image"]);
  }
}

class HttpService {
  final String membersURL = 'https://api.telos.eosindex.io/v1/chain/get_table_rows';

  Future<List<MemberModel>> getMembers() async {
    print('get members');
    
    String request = 
        '{"json":true,"code":"accts.seeds","scope":"accts.seeds","table":"users","table_key":"","lower_bound":null,"upper_bound":null,"index_position":1,"key_type":"i64","limit":"1000","reverse":false,"show_payer":false}';
    Map<String, String> headers = {"Content-type": "application/json"};

    Response res = await post(membersURL, headers: headers, body: request);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      List<dynamic> accountsWithProfile = body["rows"].where((dynamic item) {
        return item["image"] != "" &&
            item["nickname"] != "" &&
            item["account"] != "";
      }).toList();

      List<MemberModel> members =
          accountsWithProfile.map((item) => MemberModel.fromJson(item)).toList();

      return members;
    } else {
      print('Cannot fetch members...');

      return [];
    }
  }
}

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
              title: Text("Transactions Score: 30/100"),
              subtitle: Text("Send transactions to increase your score"),
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
