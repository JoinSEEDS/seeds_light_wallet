import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';

class OverlayPopup extends StatelessWidget {
  final String title;
  final Widget body;

  OverlayPopup({this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            title,
            style: TextStyle(
                fontFamily: "worksans",
                color: Colors.black87,
                fontSize: 24,
                fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          actions: <Widget>[
            if (Navigator.of(context).canPop())
              IconButton(
                  icon: Icon(
                    CommunityMaterialIcons.close_circle,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
            padding: EdgeInsets.only(bottom: 5),
            child: body,
          ),
        ),
      ),
    );
  }
}
