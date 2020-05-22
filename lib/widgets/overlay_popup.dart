import 'package:flutter/material.dart';
import 'package:seeds/constants/app_colors.dart';

class OverlayPopup extends StatefulWidget {
  final String title;
  final Widget body;
  final Function backCallback;

  OverlayPopup({this.title, this.body, this.backCallback});

  @override
  _OverlayPopupState createState() => _OverlayPopupState();
}

class _OverlayPopupState extends State<OverlayPopup> {
  Widget buildHeader() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.35,
      padding: EdgeInsets.only(
          left: width * 0.23,
          right: width * 0.23,
          top: MediaQuery.of(context).padding.top,
          bottom: 30),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.32],
              colors: AppColors.gradient)),
      child: Image(
        image: AssetImage('assets/images/logo_title_white.png'),
      ),
    );
  }

  Widget buildCard() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: EdgeInsets.only(top: height * 0.35 - 30),
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: widget.backCallback != null
          ? Column(
              children: <Widget>[
                Hero(
                  tag: 'header',
                  child: InkWell(
                    onTap: () => widget.backCallback(),
                    child: Container(
                      padding: EdgeInsets.only(left: 7, bottom: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.arrow_back),
                          Text(
                            "Back",
                            style: TextStyle(
                                fontFamily: "worksans",
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                widget.body,
              ],
            )
          : widget.body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          buildHeader(),
          buildCard(),
        ],
      ),
    );
  }
}
