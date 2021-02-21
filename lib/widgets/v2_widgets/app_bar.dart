

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String profileAccount;
  final String profileNickname;
  final String profileImage;
  final String timestamp;
  final String amount;
  final String typeIcon;
  final AppBar appBar;
  final GestureTapCallback callback;

  const BuildAppBar({
    Key key,
    @required this.amount,
    @required this.callback,
    @required this.profileAccount,
    @required this.profileNickname,
    @required this.profileImage,
    @required this.timestamp,
    @required this.typeIcon,
    @required this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('navigationTabs[index].title'),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
  // Widget buildAppBar(BuildContext _context) {
  //   return AppBar(
  //     title: Text(navigationTabs[index].title),
  //     centerTitle: true,
  //     actions: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.only(right: 16),
  //         child: IconButton(
  //             icon: Icon(Icons.qr_code_scanner, size: 28),
  //             onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode)),
  //       ),
  //     ],
  //   );
  // }

}
